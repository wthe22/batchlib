:entry_point
call %*
exit /b


:is_in_range <number> <range>
setlocal EnableDelayedExpansion
set "_evaluated="
set /a "_evaluated=%~1" || ( 1>&2 echo error: failed to evaluate number & exit /b 2 )
set /a "_input=!_evaluated!" || ( 1>&2 echo error: failed to evaluate number & exit /b 2 )
if !_input! GEQ 0 (
    set "_input.sym=+"
) else set "_input.sym=-"
set "_range=%~2"
if not defined _range set "_range=-2147483647~2147483647"
for %%r in (!_range!) do for /f "tokens=1,2 delims=~ " %%a in ("%%~r") do (
    set "_min=%%a"
    set "_max=%%b"
    if not defined _max set "_max=!_min!"
    for %%v in (_min _max) do (
        set "_evaluated="
        set /a "_evaluated=!%%v!" || ( 1>&2 echo error: invalid range '!%%v!' & exit /b 3 )
        set /a "%%v=!_evaluated!" || ( 1>&2 echo error: invalid range '!%%v!' & exit /b 3 )
        if !%%v! GEQ 0 (
            set "%%v.sym=+"
        ) else set "%%v.sym=-"
    )
    set "_invalid=true"
    for %%v in (_min _max) do if "!_input.sym!" == "!%%v.sym!" set "_invalid="
    if "!_input.sym!" == "!_min.sym!" if !_input! LSS !_min! set "_invalid=true"
    if "!_input.sym!" == "!_max.sym!" if !_input! GTR !_max! set "_invalid=true"
    if not defined _invalid exit /b 0
)
exit /b 2


:lib.dependencies [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=Input.number Input.string"
set "%~1category=number"
exit /b 0


:doc.man
::  NAME
::      is_in_range - check if a number is within the specified domain
::
::  SYNOPSIS
::      is_in_range <number> <start~end|number [...]>
::
::  POSITIONAL ARGUMENTS
::      number
::          The number to check. Hexadecimal and octal are also supported.
::
::      start~end|number
::          The set of valid values, each seperated by space and/or comma. All
::          values must be within the same quote. Use '~' to specify a range
::          (e.g -9 to 71 is written as '-9~71'). Hexadecimal and octal are also
::          supported. By default, it is '-2147483647~2147483647'.
::
::  EXIT STATUS
::      0:  - The number is within the specified range.
::      2:  - The number is not within the specified range.
::          - The number is invalid.
::      3:  - The range is invalid.
exit /b 0


:doc.demo
call :Input.number number --optional || set "number=!random!"
call :Input.string range || set "range=-99~111, 123, -1, 10240~20480"
echo=
echo Number : !number!
echo Range  : !range!
call :is_in_range "!number!" "!range!" && (
    echo Number is within range
) || echo Number is not within range
exit /b 0


:tests.setup
set "return.true=0"
set "return.false=2"
set "return.invalid=3"
exit /b 0


:tests.teardown
exit /b 0


:tests.test_invalid_num
for %%a in (
    "false: "
    "false: -2147483648"
) do for /f "tokens=1* delims=: " %%b in (%%a) do (
    set "given=%%c"
    call :is_in_range !given! 2> nul
    set "result=!errorlevel!"
    set "expected=!return.%%b!"
    if not "!result!" == "!expected!" (
        call %unittest% fail "Given '!given!', expected '!expected!', got '!result!'"
    )
)
exit /b 0


:tests.test_numbers
call :tests.check_errorlevel ^
    ^ "true: -2147483647" ^
    ^ "true: 2147483647" ^
    ^ "true: -2" ^
    ^ "true: 2" ^
    ^ "true: -1" ^
    ^ "true: 1" ^
    ^ "true: -0" ^
    ^ "true: 0" ^
    ^ %=end=%
exit /b 0


:tests.test_single_values
call :tests.check_errorlevel ^
    ^ "true: 10 '10,20,30'" ^
    ^ "false: 11 '10,20,30'" ^
    ^ "false: 29 '10,20,30'" ^
    ^ "true: 30 '10,20,30'" ^
    ^ %=end=%
exit /b 0


:tests.check_errorlevel <expected:args> [...]
for %%a in (
    %*
) do for /f "tokens=1* delims=: " %%b in (%%a) do (
    set "given= %%c"
    set given=!given:'="!
    call :is_in_range !given!
    set "result=!errorlevel!"
    set given=!given:"=`!
    set "expected=!return.%%b!"
    if not "!result!" == "!expected!" (
        call %unittest% fail "Given '!given!', expected '!expected!', got '!result!'"
    )
)
exit /b 0


:EOF
exit /b
