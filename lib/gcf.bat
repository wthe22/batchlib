:entry_point > nul 2> nul
call %*
exit /b


:gcf <return_var> <integer1> <integer2>
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


:lib.build_system [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=Input.number"
set "%~1category=number"
exit /b 0


:doc.man
::  NAME
::      gcf - calculate the greatest common factor of two numbers
::
::  SYNOPSIS
::      gcf <return_var> <integer1> <integer2>
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the result.
::
::      integer
::          The numbers to calculate its GCF.
exit /b 0


:doc.demo
call :Input.number number1 --range "0~2147483647" --optional || set "number1=!random!"
call :Input.number number2 --range "0~2147483647" --optional || set "number2=!random!"
call :gcf result !number1! !number2!
echo=
echo GCF of !number1! and !number2! is !result!
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
    call :gcf result !given! || (
        call %unittest% fail "given '!given!', got failure"
    )
    set "expected=%%b"
    if not "!result!" == "!expected!" (
        call %unittest% fail "given '!given!', expected '!expected!', got '!result!'"
    )
)
exit /b 0


:EOF  # End of File
exit /b
