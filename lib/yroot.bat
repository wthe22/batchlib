:entry_point
call %*
exit /b


:yroot <return_var> <integer> <power>
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
set "%~1extra_requires=Input.number"
set "%~1category=number"
exit /b 0


:doc.man
::  NAME
::      yroot - calculate y root of x
::
::  SYNOPSIS
::      yroot <return_var> <integer> <power>
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the result (rounded down to the nearest integer).
::
::      integer
::          The number to yroot (the 'x').
::
::      power
::          The power of the root (the 'y').
::
::  NOTES
::      - In case someone needs it: yroot of x to the power of 0 does not exist.
exit /b 0


:doc.demo
call :Input.number number --range "0~2147483647" --optional || (
    set /a "number=!random! %% 1000"
)
call :Input.number power --range "0~2147483647"  --optional || (
    set /a "power=!random! %% 3 + 1"
)
echo=
call :yroot result !number! !power!
echo Root to the power of !power! of !number! is !result!
echo Result is round down
exit /b 0


:tests.setup
:tests.teardown
exit /b 0


:tests.test_zero_one
for /l %%p in (1,1,31) do for %%n in (0 1) do (
    call :yroot result %%n %%p
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
    call :yroot result !given! || (
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
