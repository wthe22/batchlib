:entry_point
call %*
exit /b


:functions.list <input_file>
setlocal EnableDelayedExpansion EnableExtensions
set "_input_file=%~f1"
cd /d "!tmp_dir!" 2> nul || cd /d "!tmp!"
for /f "delims= " %%t in ('robocopy /l . . /njh /njs') do set "TAB=%%t"
findstr /n /r /c:"^^[!TAB! @]*:[^^: ]" "!_input_file!" ^
    ^ > ".functions.list._tokens" 2> nul ^
    ^ || ( 1>&2 echo%0: Cannot open file '!_input_file!' & exit /b 2 )
set "_result="
for /f "usebackq tokens=*" %%o in (".functions.list._tokens") do (
    set "_label=%%o"
    set "_label=!_label:*:=!"
    for /f "tokens=* delims=@%TAB% " %%a in ("!_label!") do set "_label=%%a"
    for /f "tokens=1 delims=:%TAB% " %%a in ("!_label!") do set "_label=%%a"
    echo !_label!
)
exit /b 0


:lib.dependencies [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=Input.string Input.path capchar"
set "%~1category=packaging"
exit /b 0


:doc.man
::  NAME
::      functions.list - display all labels in a file
::
::  SYNOPSIS
::      functions.list <input_file>
::
::  ENVIRONMENT
::      cd
::          Affects the base path of input_file if relative path is given.
::
::      tmp_dir
::          Path to store the temporary results.
::
::      tmp
::          Fallback path for tmp_dir if tmp_dir does not exist
::
::  EXIT STATUS
::      0:  - Label is found.
::      2:  - Cannot open input file.
::
::  NOTES
::      - Only spaces, tabs, and at (@) is allowed before the label
::        spaces (i.e. only indentations and '@' are allowed)
::      - Does not support labels that have:
::          - '^' or '*' in label name
::      - Only Windows EOL is supported.
exit /b 0


:doc.demo
call :Input.path input_file --file --exist
echo=
echo Input file : !input_file!
echo=
echo Labels:
call :functions.list "!input_file!"
exit /b 0


:tests.setup
set "return.found=0"
set "return.not_found=3"
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
exit /b 0


:tests.teardown
exit /b 0


:tests.test_trim_leading
set "expected= plain space tab at mix"
call :functions.list "left_side" > result
set "result="
for /f "usebackq tokens=*" %%r in ("result") do set "result=!result! %%r"
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_trim_trailing
set "expected= plain space tab colon argspecs"
call :functions.list "right_side" > result
set "result="
for /f "usebackq tokens=*" %%r in ("result") do set "result=!result! %%r"
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:EOF
exit /b
