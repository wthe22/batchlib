:entry_point
call %*
exit /b


:int.from_bin <return_var> <unsigned_binary>
setlocal EnableDelayedExpansion
set "_input=00000000000000000000000000000000%~2"
set "_result=0"
for /l %%i in (1,1,32) do set /a "_result+=!_input:~-%%i,1! << %%i-1"
for /f "tokens=*" %%r in ("!_result!") do (
    endlocal
    set "%~1=%%r"
)
exit /b 0


:lib.dependencies [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=Input.string"
set "%~1category=number"
exit /b 0


:doc.man
::  NAME
::      Convert binary to decimal
::
::  SYNOPSIS
::      int.from_bin <return_var> <unsigned_binary>
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the result.
::
::      unsigned_binary
::          The unsigned binary to convert. The maximum length supported is 31.
exit /b 0


:doc.demo
call :Input.string binary || set "binary=10110"
call :int.from_bin result !binary!
echo=
echo The decimal value of '!binary!' is !result!
exit /b 0


:tests.setup
:tests.teardown
exit /b 0


:tests.test_decode
for %%a in (
    "0          = 0"
    "1          = 1"
    "0          = 00"
    "1          = 01"
    "2          = 10"
    "3          = 11"
    "536870910  = 0011111111111111111111111111110"
    "1073741820 = 0111111111111111111111111111100"
    "2147483647 = 1111111111111111111111111111111"
) do for /f "tokens=1* delims== " %%b in (%%a) do (
    set "given=%%c"
    call :int.from_bin result !given! || (
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
