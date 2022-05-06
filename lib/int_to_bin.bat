:entry_point
call %*
exit /b


:int_to_bin <return_var> <positive_integer>
setlocal EnableDelayedExpansion
set "_result="
for /l %%i in (0,1,31) do (
    set /a "_bits=(%~2>>%%i) & 0x1"
    set "_result=!_bits!!_result!"
)
for /f "tokens=1* delims=0" %%a in ("Q0!_result!") do (
    endlocal
    if "%%b" == "" (
        set "%~1=0"
    ) else set "%~1=%%b"
)
exit /b 0


:lib.dependencies [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=Input.number"
set "%~1category=number"
exit /b 0


:doc.man
::  NAME
::      int_to_bin - convert decimal to unsigned binary
::
::  SYNOPSIS
::      int_to_bin <return_var> <positive_integer>
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the result.
::
::      positive_integer
::          The positive integer to convert.
exit /b 0


:doc.demo
call :Input.number decimal --range "0~2147483647" --optional || (
    set "decimal=!random!"
)
call :int_to_bin result !decimal!
echo=
echo The binary value of '!decimal!' is !result!
exit /b 0


:tests.setup
:tests.teardown
exit /b 0


:tests.test_encode
for %%a in (
    "0          = 0"
    "1          = 1"
    "2          = 10"
    "3          = 11"
    "536870910  = 11111111111111111111111111110"
    "1073741820 = 111111111111111111111111111100"
    "2147483647 = 1111111111111111111111111111111"
) do for /f "tokens=1* delims== " %%b in (%%a) do (
    set "given=%%b"
    call :int_to_bin result !given! || (
        call %unittest% fail "Given '!given!', got failure"
    )
    set "expected=%%c"
    if not "!result!" == "!expected!" (
        call %unittest% fail "Given '!given!', expected '!expected!', got '!result!'"
    )
)
exit /b 0


:EOF
exit /b
