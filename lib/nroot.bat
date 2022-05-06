:entry_point
call %*
exit /b


:nroot <return_var> <integer> <n>
set "%~1="
setlocal EnableDelayedExpansion
set "_result=0"
for /l %%b in (31,-1,0) do (
    set "_guess=1"
    set "_limit=0x7FFFFFFF"
    for /l %%p in (1,1,%~3) do if not "!_limit!" == "0" (
        set /a "_guess*=!_result! + (1<<%%b)"
        set /a "_limit/=!_result! + (1<<%%b)"
    )
    if not "!_limit!" == "0" if !_guess! LEQ %~2 set /a "_result+=(1<<%%b)"
)
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
::      nroot - calculate nth root of x
::
::  SYNOPSIS
::      nroot <return_var> <integer> <n>
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the result (rounded down to the nearest integer).
::
::      integer
::          The number to root (the 'x').
::
::      n
::          The power of the root (the 'n'). Maximum supported is 31.
::
::  NOTES
::      - In case someone needs it: 0th root of x does not exist.
::      - The result is always 1 if the 'n' is too big.
exit /b 0


:doc.demo
call :input_number number --range "0~2147483647" --optional || (
    set /a "number=!random! %% 1000"
)
call :input_number power --range "0~2147483647"  --optional || (
    set /a "power=!random! %% 3 + 1"
)
echo=
call :nroot result !number! !power!
echo Root to the power of !power! of !number! is !result!
echo Result is round down
exit /b 0


:tests.setup
:tests.teardown
exit /b 0


:tests.test_zero_one
for /l %%p in (1,1,31) do for %%n in (0 1) do (
    call :nroot result %%n %%p
    if not "!result!" == "%%n" (
        call %unittest% fail "Given '%%n %%p', expected '%%n', got  '!result!'"
    )
)
exit /b 0


:tests.test_max
call :tests.check_result ^
    ^ "2147483647:    2147483647 1" ^
    ^ "46340:         2147395600 2" ^
    ^ "1290:          2146689000 3" ^
    ^ "215:           2136750625 4" ^
    ^ "73:            2073071593 5" ^
    ^ "35:            1838265625 6" ^
    ^ "21:            1801088541 7" ^
    ^ "4:             1073741824 15" ^
    ^ "2:             1073741824 30" ^
    ^ "1:             1 31" ^
    ^ %=end=%
exit /b 0


:tests.test_round_down
call :tests.check_result ^
    ^ "2147483647:    2147483647 1" ^
    ^ "46340:         2147483647 2" ^
    ^ "1290:          2147483647 3" ^
    ^ "215:           2147483647 4" ^
    ^ "73:            2147483647 5" ^
    ^ "35:            2147483647 6" ^
    ^ "21:            2147483647 7" ^
    ^ "4:             2147483647 15" ^
    ^ "2:             2147483647 30" ^
    ^ "1:             2147483647 31" ^
    ^ %=end=%
exit /b 0


:tests.check_result <expected:args> [...]
for %%a in (
    %*
) do for /f "tokens=1* delims=: " %%b in (%%a) do (
    set "given=%%c"
    call :nroot result !given! || (
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
