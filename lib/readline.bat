:entry_point
call %*
exit /b


:readline <input_file> <range> [offset] [substr]
setlocal EnableDelayedExpansion
set "_input_file=%~f1"
set "_range=%~2"
set "_offset=%~3"
set "_substr=%~4"
cd /d "!tmp_dir!" 2> nul || cd /d "!tmp!"
call :readline._adjust_range || ( 1>&2 echo%0: Invalid arguments & exit /b 2 )
if !_start! LEQ 0 set "_start=1"
if defined _end if !_start! GTR !_end! exit /b 0
if !_start! GTR 1 (
    set /a "_skip=!_start! - 1"
    set "_skip=skip=!_skip!"
) else set "_skip="
findstr /n "^^" "!_input_file!" > ".readline._numbered"
setlocal DisableDelayedExpansion
for /f "usebackq %_skip% tokens=*" %%o in (".readline._numbered") do (
    set "_line=%%o"
    setlocal EnableDelayedExpansion
    set "_line=!_line:*:=!"
    if defined _substr set "_line=!_line:~%_substr%!"
    echo(!_line!
    endlocal
    for /f "tokens=1 delims=:" %%n in ("%%o") do if "%%n" == "%_end%" exit /b 0
)
exit /b 0
#+++

:readline._adjust_range
if not defined _range exit /b 2
set "_start="
set "_end="
for /f "tokens=1-2 delims=:" %%a in ("!_range!") do (
    if %%a LSS 1 exit /b 2
    if %%a GTR 2147483647 exit /b 2
    set /a "_start=%%a" || exit /b 2
    if not "%%b" == "" (
        if %%b LSS 1 exit /b 2
        if %%b GTR 2147483647 exit /b 2
        set /a "_end=%%b" || exit /b 2
    )
)
for /f "tokens=1-2 delims=:" %%a in ("!_offset!") do (
    set /a "_start+=%%a" || exit /b 2
    if defined _end if not "%%b" == "" set /a "_end+=%%b" || exit /b 2
)
exit /b 0


:lib.dependencies [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=Input.number Input.path"
set "%~1category=file"
exit /b 0


:doc.man
::  NAME
::      readline - read lines from a file
::
::  SYNOPSIS
::      readline <input_file> <range> [offset] [substr]
::
::  POSITIONAL ARGUMENTS
::      input_file
::          Path of the input file.
::
::      range
::          Range of lines to read. The syntax is <start>:[end]. By default, it
::          reads until the end of the file. First line starts at 1.
::          This value is validated.
::
::      offset
::          Offset to apply to RANGE. The syntax is <start_offset>:[end_offset].
::          E.g. to exclude first line and last line of RANGE, use 1:-1 as the
::          offset. End offset have no effect if end range is not specified.
::          This value is not validated.
::
::      substr
::          Substring to apply to each line. The syntax is the same as using
::          substring: <start>[,<length>]. This must be placed as the fourth
::          argument. This value is not validated.
::
::  EXIT STATUS
::      0:  - Successful.
::      2:  - Invalid arguments.
::
::  ENVIRONMENT
::      cd
::          Affects the base path of input_file if relative path is given.
::
::      tmp_dir
::          Path to store the temporary output.
::
::      temp
::          Fallback path for tmp_dir if tmp_dir does not exist
::
::  NOTES
::      - No lines are read if line ends before the START line.
::      - If the final range, after considering the offset, causes start to be
::        negative (e.g. start at line 0 or -1) it will be set to 1.
::      - No line is read (with exit code 0) if the final range, after considering
::        the offset, causes the end line to appear before the start line.
::      - Validated: Invalid values are checked before usage
::      - Not validated: Invalid values can cause unexpected behaviors
exit /b 0


:doc.demo
call :Input.path input_file --optional || set "input_file=%~f0"
call :Input.number start_line --optional || set "start_line=1"
call :Input.number end_line --optional || set "end_line=15"
echo=
echo Reading "!input_file!" from line !start_line! to !end_line!
call :readline "%~f0" "!start_line!:!end_line!"
exit /b 0


:tests.setup
> "simple" (
    for /l %%n in (1,1,5) do echo %%n
)
> "commented" (
    for /l %%n in (1,1,5) do echo ::  %%n
)
exit /b 0


:tests.teardown
exit /b 0


:tests.test_read
call :readline simple 2:4 > "result"
set expected=2;3;4;
set "result="
for /f "usebackq tokens=* delims=" %%o in ("result") do set "result=!result!%%o;"
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_offset
call :readline simple 2:4 1:-1 > "result"
set expected=3;
set "result="
for /f "usebackq tokens=* delims=" %%o in ("result") do set "result=!result!%%o;"
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_no_end_offset
call :readline simple 2:4 1 > "result"
set expected=3;4;
set "result="
for /f "usebackq tokens=* delims=" %%o in ("result") do set "result=!result!%%o;"
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_invalid_range
call :readline simple hello > nul 2> nul && (
    call %unittest% fail "Success with invalid range"
)
exit /b 0


:tests.test_negative_start
call :readline simple 1:4 -2: > "result"
set expected=1;2;3;4;
set "result="
for /f "usebackq tokens=* delims=" %%o in ("result") do set "result=!result!%%o;"
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_negative_ranges
call :readline simple 1:1 -2:-1 > "result" || (
    call %unittest% fail "Exit status is not successful"
)
set expected=
set "result="
for /f "usebackq tokens=* delims=" %%o in ("result") do set "result=!result!%%o;"
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_substr
call :readline commented 2:4 0:0 4 > "result"
set expected=2;3;4;
set "result="
for /f "usebackq tokens=* delims=" %%o in ("result") do set "result=!result!%%o;"
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_no_end
call :readline simple 2: > "result"
set expected=2;3;4;5;
set "result="
for /f "usebackq tokens=* delims=" %%o in ("result") do set "result=!result!%%o;"
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:EOF
exit /b
