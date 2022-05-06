:entry_point
call %*
exit /b


:pow <return_var> <base> <exponent>
set "%~1="
setlocal EnableDelayedExpansion
set "_base=%~2"
set "_power=%~3"
set "_result=1"
set "_limit=0x7FFFFFFF"
for /l %%p in (1,1,!_power!) do (
    set /a "_result*=!_base!" || ( 1>&2 echo error: integer is too large & exit /b 2 )
    if not "!_base!" == "0" set /a "_limit/=!_base!"
)
if "!_limit!" == "0" ( 1>&2 echo error: result is too large & exit /b 2 )
for /f "tokens=*" %%r in ("!_result!") do (
    endlocal
    set "%~1=%%r"
)
exit /b 0


:lib.dependencies [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=input_number"
set "%~1category=number"
exit /b 0


:doc.man
::  NAME
::      pow - calculate x to the power of y
::
::  SYNOPSIS
::      pow <return_var> <base> <exponent>
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the result.
::
::      base
::          The base integer (the 'x').
::
::      exponent
::          How many times to multiply (the 'y').
::
::  EXIT STATUS
::      0:  - Success.
::      2:  - The result is too large (> 2147483647).
::          - The integer is too large (> 2147483647).
exit /b 0


:doc.demo
call :input_number number --range "0~2147483647" --optional || (
    set "number=!random:~-1,1!"
)
call :input_number power --range "0~2147483647" --optional || (
    set "power=!random:~-1,1!"
)
call :pow result !number! !power!
echo=
echo !number! to the power of !power! is !result!
exit /b 0


:tests.setup
set "return.success=0"
set "return.fail=2"
exit /b 0


:tests.teardown
exit /b 0


:tests.test_max
call :tests.check_result ^
    ^ "2147483647:  2147483647 1" ^
    ^ "2147395600:  46340 2" ^
    ^ "2146689000:  1290 3" ^
    ^ "2136750625:  215 4" ^
    ^ "2073071593:  73 5" ^
    ^ "1838265625:  35 6" ^
    ^ "1801088541:  21 7" ^
    ^ "1073741824:  4 15" ^
    ^ "1073741824:  2 30" ^
    ^ "1:           1 31" ^
    ^ %=end=%
exit /b 0


:tests.test_valid
call :tests.check_errorlevel ^
    ^ "success: 2147483647 1" ^
    ^ "success: 46340 2" ^
    ^ "success: 1290 3" ^
    ^ "success: 215 4" ^
    ^ "success: 73 5" ^
    ^ "success: 35 6" ^
    ^ "success: 21 7" ^
    ^ "success: 4 15" ^
    ^ "success: 2 30" ^
    ^ "success: 1 31" ^
    ^ %=end=%
exit /b 0


:tests.test_out_of_range
call :tests.check_errorlevel ^
    ^ "fail: 2147483648 1" ^
    ^ "fail: 2147483647 2" ^
    ^ "fail: 46340 3" ^
    ^ "fail: 1290 4" ^
    ^ "fail: 215 5" ^
    ^ "fail: 73 6" ^
    ^ "fail: 35 7" ^
    ^ "fail: 21 8" ^
    ^ "fail: 4 16" ^
    ^ "fail: 2 31" ^
    ^ %=end=%
exit /b 0


:tests.test_zero
call :tests.check_result ^
    ^ "1:  0 0" ^
    ^ "0:  0 1" ^
    ^ "0:  0 2" ^
    ^ %=end=%
exit /b 0


:tests.check_result <expected:args> [...]
for %%a in (
    %*
) do for /f "tokens=1* delims=: " %%b in (%%a) do (
    set "given=%%c"
    call :pow result !given! || (
        call %unittest% fail "Given '!given!', got failure"
    )
    set "expected=%%b"
    if not "!result!" == "!expected!" (
        call %unittest% fail "Given '!given!', expected '!expected!', got '!result!'"
    )
)
exit /b 0


:tests.check_errorlevel <expected:args> [...]
for %%a in (
    %*
) do for /f "tokens=1* delims=: " %%b in (%%a) do (
    set "given=%%c"
    call :pow ans !given! 2> nul
    set "result=!errorlevel!"
    set "expected=!return.%%b!"
    if not "!result!" == "!expected!" (
        call %unittest% fail "Given '!given!', expected '!expected!', got '!result!'"
    )
)
exit /b 0


:EOF
exit /b
