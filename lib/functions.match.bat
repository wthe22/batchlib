:entry_point > nul 2> nul
call %*
exit /b


:functions.match  <return_var> <input_file> <pattern>
setlocal EnableDelayedExpansion EnableExtensions
set "_return_var=%~1"
set "_input_file=%~f2"
set "_pattern=%~3"
cd /d "!tmp_dir!" 2> nul || cd /d "!tmp!"
for /f "delims= " %%t in ('robocopy /l . . /njh /njs') do set "TAB=%%t"
findstr /n /r /c:"^^[!TAB! @]*:[^^: ]" "!_input_file!" > "_tokens" 2> nul || (
    1>&2 echo%0: Cannot open file '!_input_file!' & exit /b 3
)
set "_parts="
set "_leftover=:!_pattern!:"
for /l %%n in (1,1,10) do if defined _leftover (
    for /f "tokens=1* delims=*" %%a in ("!_leftover!") do (
        set _parts=!_parts! "%%a"
        set "_leftover=%%b"
    )
)
set "_result="
for /f "usebackq tokens=*" %%o in ("_tokens") do (
    set "_label=%%o"
    set "_label=!_label:*:=!"
    for /f "tokens=* delims=@%TAB% " %%a in ("!_label!") do set "_label=%%a"
    for /f "tokens=1 delims=:%TAB% " %%a in ("!_label!") do set "_label=%%a"
    set "_leftover=:!_label!:"
    set "_match=true"
    for %%p in (!_parts!) do if defined _match (
        set "_leftover=!_leftover:*%%~p= !"
        if not "!_leftover:~0,1!" == " " set "_match="
        set "_leftover=!_leftover:~1!"
    )
    if defined _match set "_result=!_result! !_label!"
)
for /f "tokens=1* delims= " %%q in ("Q !_result!") do (
    endlocal
    set "%_return_var%=%%r"
    if not defined %_return_var% exit /b 2
)
exit /b 0


:lib.build_system [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=Input.string Input.path capchar"
set "%~1category=packaging"
exit /b 0


:doc.man
::  NAME
::      functions.match - find labels that matches the specified pattern
::
::  SYNOPSIS
::      functions.match  <return_var> <input_file> <pattern>
::
::  DESCRIPTION
::      Find all labels that matches the pattern in the input file.
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the results, each seperated by space.
::
::  OPTIONS
::      -p PATTERN, --pattern PATTERN
::          Pattern of the function label to match. Supports up to 4 wildcards '*'.
::          It uses path pattern matching sytle. By default, it is '*'.
::
::      -f INPUT_FILE, --file INPUT_FILE
::          Path of the input file. By default, it is the current file.
::
::  ENVIRONMENT
::      cd
::          Affects the base path of input_file if relative path is given.
::
::  EXIT STATUS
::      0:  - Label is found.
::      2:  - Label is not found.
::
::  NOTES
::      - The label of the function MUST only be preceeded by either nothing or
::        spaces (i.e. only space indentation is allowed)
::      - Does not support labels that have:
::          - '^' or '*' in label name
::      - Only Windows EOL is supported.
exit /b 0


:doc.demo
call :Input.path input_file --file --exist
call :Input.string pattern || set "pattern=l*e*"
echo=
echo Input file : !input_file!
echo Pattern    : !pattern!
call :functions.match label_match "!input_file!" "!pattern!"
echo=
echo Found match:
set "match_count=0"
for %%l in (!label_match!) do (
    set /a "match_count+=1"
    set "match_count=   !match_count!"
    set "match_count=!match_count:~-3,3!"
    echo !match_count!. %%l
)
exit /b 0


:tests.setup
set "return.found=0"
set "return.not_found=2"
call :capchar TAB
call :capchar LF
> "left_side" (
    echo=call %*
    echo exit /b
    echo=
    echo :plain
    echo    :space
    echo !TAB!:tab
    echo @:at
    echo !TAB!@ :mix
    echo ::comment
    echo exit /b 0
    echo=
)
> "right_side" (
    echo=call %*
    echo exit /b
    echo=
    echo :plain
    echo :space    %=END=%
    echo :tab!TAB!%=END=%
    echo :colon:%=END=%
    echo :argspecs ^<arg1^> [--opt]%=END=%
    echo exit /b 0
    echo=
)
> "pattern_basic" (
    echo=call %*
    echo exit /b
    echo=
    echo :
    echo :scripts.main
    echo :scripts.call
    echo :hello
    echo :hi
    echo :howdy
    echo ::comment
)
> "for_unittest" (
    echo :tests.test_
    echo :tests.test_single_dot
    echo :tests..test_double_dot
    echo :tests.test_1
    echo :tests.test_1.prepare
    echo :tests.part.test_1
)
exit /b 0


:tests.teardown
exit /b 0


:tests.test_trim_leading
for %%a in (
    "plain"
    "space"
    "tab"
    "at"
    "mix"
) do (
    set "given=%%~a"
    set "expected=%%~a"
    call :functions.match result "left_side" "!given!"
    if not "!result!" == "!expected!" (
        call %unittest% fail "Given '!given!' expected '!expected!', got '!result!'"
    )
)
exit /b 0


:tests.test_trim_trailing
for %%a in (
    "plain"
    "space"
    "tab"
    "colon"
    "argspecs"
) do (
    set "given=%%~a"
    set "expected=%%~a"
    call :functions.match result "right_side" "!given!"
    if not "!result!" == "!expected!" (
        call %unittest% fail "Given '!given!' expected '!expected!', got '!result!'"
    )
)
exit /b 0


:tests.test_match
set test_cases= ^
    ^ 5:*!LF!^
    ^ 0:*z*!LF!^
    ^ 1:*e*!LF!^
    ^ 3:*i*!LF!^
    ^ 2:h*o*!LF!^
    ^ 2:scripts.*!LF!^
    ^ %=end=%
for /f "tokens=1* delims=: " %%a in ("!test_cases!") do (
    set "given=%%b"
    set "expected=%%a"
    call :functions.match labels "pattern_basic" "!given!"
    set "result=0"
    for %%l in (!labels!) do set /a "result+=1"
    if not "!result!" == "!expected!" (
        call %unittest% fail "Given '!given!', expected '!expected!', got '!result!'"
    )
)
exit /b 0


:tests.test_errorlevel
for %%t in (
    "found: hello"
    "not_found: ola"
) do for /f "tokens=1* delims=: " %%a in (%%t) do (
    set "given=%%b"
    call :functions.match labels "pattern_basic" "!given!"
    set "result=!errorlevel!"
    set "expected=!return.%%a!"
    if not "!result!" == "!expected!" (
        call %unittest% fail "Given '!given!' expected '!expected!', got '!result!'"
    )
)
exit /b 0


:tests._test_for_unittest
rem TODO: Make pattern for unittest labels
set "expected=4"
call :functions.match labels "for_unittest" "tests*.test_*"
set "result=0"
for %%l in (!labels!) do set /a "result+=1"
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:EOF  # End of File
exit /b
