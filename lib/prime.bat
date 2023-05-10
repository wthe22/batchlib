:entry_point
call %*
exit /b


:prime <return_var> <integer>
setlocal EnableDelayedExpansion
set "_return_var=%~1"
set "_integer=%~2"
set "_factor=0"
if !_integer! GEQ 2 (
    set /a "_remainder=%~2 %% 2"
    if "!_remainder!" == "0" (
        set "_factor=2"
        ) else (
        call :nroot _max !_integer! 2
        set "_factor="
        for /l %%f in (3,2,!_max!) do if not defined _factor (
            set /a "_remainder=!_integer! %% %%f"
            if "!_remainder!" == "0" set "_factor=%%f"
        )
        if not defined _factor set "_factor=!_integer!"
    )
)
for /f "tokens=*" %%r in ("!_factor!") do (
    endlocal
    set "%_return_var%=%%r"
)
exit /b 0


:lib.dependencies [return_prefix]
set "%~1install_requires=nroot"
set "%~1extra_requires=input_number"
set "%~1category=number"
exit /b 0


:doc.man
::  NAME
::      prime - check if a number is a prime number
::
::  SYNOPSIS
::      prime <return_var> <integer>
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the smallest factor.
::
::      integer
::          The number to test for prime.
::
::  BEHAVIOR
::      - If it is a prime number, the same number is returned, since
::        the smallest factor of a prime number is itself.
::      - If it is a composite number, the smallest factor is returned.
::      - If it is neither a prime nor a composite number, 0 is returned.
exit /b 0


:doc.demo
call :input_number number --range "0~2147483647" --optional || (
    set "number=!random!"
)
call :prime factor !number!
echo=
if "!factor!" == "!number!" (
    echo !number! is a prime number
) else if "!factor!" == "0" (
    echo !number! is not a prime number nor a composite number
) else (
    echo !number! is a composite number. It is divisible by !factor!
)
exit /b 0


:tests.setup
:tests.teardown
exit /b 0


:tests.test_all
for %%a in (
    "2147483647:    2147483647"
    "2:             2147483646"
    "5:             2147483645"
    "3:             2147483643"
    "2699:          2147483641"
    "46337:         2147117569"
) do for /f "tokens=1* delims=: " %%b in (%%a) do (
    set "given=%%c"
    call :prime result !given!
    set "expected=%%b"
    if not "!result!" == "!expected!" (
        call %unittest% fail "Given '!given!', expected '!expected!', got '!result!'"
    )
)
exit /b 0


:EOF
exit /b
