:entry_point
call %*
exit /b


:functions_list <input_file>
if not defined ._shared.TAB (
    for /f "delims= " %%t in ('robocopy /l . . /njh /njs') do set "._shared.TAB=%%t"
)
setlocal EnableDelayedExpansion EnableExtensions
set "_input_file=%~f1"
cd /d "!tmp_dir!" 2> nul || cd /d "!tmp!"
set "TAB=!._shared.TAB!"
findstr /n /r /c:"^^[!TAB! @]*:[^^: ]" "!_input_file!" ^
    ^ > ".functions_list._tokens" 2> nul ^
    ^ || ( 1>&2 echo%0: Cannot open file '!_input_file!' & exit /b 2 )
set "_result="
for /f "usebackq tokens=*" %%o in (".functions_list._tokens") do (
    set "_label=%%o"
    set "_label=!_label:*:=!"
    for /f "tokens=* delims=@%TAB% " %%a in ("!_label!") do set "_label=%%a"
    for /f "tokens=1 delims=:%TAB% " %%a in ("!_label!") do set "_label=%%a"
    echo !_label!
)
exit /b 0


:lib.dependencies [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=input_string input_path capchar"
set "%~1category=algorithms"
exit /b 0


:doc.man
::  NAME
::      functions_list - display all labels in a file
::
::  SYNOPSIS
::      functions_list <input_file>
::
::  POSITIONAL ARGUMENTS
::      input_file
::          Path of the input file
::
::  ENVIRONMENT
::      This function uses:
::      - Temporary files
::      - Shared global variables (TAB)
::
::      Global variables that affects this function:
::      - tmp_dir: Path to store the temporary files
::      - tmp: Fallback path of tmp_dir
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
call :input_path --file --exist --optional input_file || set "input_file=%~f0"
echo=
echo Input file : !input_file!
echo=
echo Labels:
call :functions_list "!input_file!"
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
call :functions_list "left_side" > result
set "result="
for /f "usebackq tokens=*" %%r in ("result") do set "result=!result! %%r"
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_trim_trailing
set "expected= plain space tab colon argspecs"
call :functions_list "right_side" > result
set "result="
for /f "usebackq tokens=*" %%r in ("result") do set "result=!result! %%r"
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:EOF
exit /b
