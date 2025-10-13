:entry_point
call %*
exit /b


:metadata [return_prefix]
set "%~1dependencies= "
set "%~1dev_dependencies=input_number"
set "%~1categories=number"
exit /b 0


:gcd <return_var> <integer1> <integer2>
setlocal EnableDelayedExpansion
set /a "_result=%~2"
set /a "_temp=%~3"
for /l %%l in (1,1,46) do for %%n in (!_temp!) do if not "!_temp!" == "0" (
    set /a "_temp=!_result! %% %%n"
    set /a "_result=%%n"
)
for /f "tokens=*" %%r in ("!_result!") do (
    endlocal
    set "%~1=%%r"
)
exit /b 0


:doc.man
::  NAME
::      gcd - calculate the greatest common factor of two numbers
::
::  SYNOPSIS
::      gcd <return_var> <integer1> <integer2>
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the result.
::
::      integer
::          The numbers to calculate its gcd.
exit /b 0


:doc.demo
call :input_number number1 --range "0~2147483647" --optional || set "number1=!random!"
call :input_number number2 --range "0~2147483647" --optional || set "number2=!random!"
call :gcd result !number1! !number2!
echo=
echo gcd of !number1! and !number2! is !result!
exit /b 0


:tests.setup
:tests.teardown
exit /b 0


:tests.test_all
for %%a in (
    "1:             1836311903 1134903170"
    "28657:         1836311903 1134903171"
) do for /f "tokens=1* delims=:" %%b in (%%a) do (
    set "given=%%c"
    call :gcd result !given! || (
        call %unittest% fail "Given '!given!', got failure"
    )
    set "expected=%%b"
    if not "!result!" == "!expected!" (
        call %unittest% fail "Given '!given!', expected '!expected!', got '!result!'"
    )
)
exit /b 0


:EOF
exit /b
