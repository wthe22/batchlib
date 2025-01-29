:entry_point
call %*
exit /b


:timeit [-n loops] [-r repetitions] <code>
setlocal EnableDelayedExpansion
set "_is_macro="
call :timeit._setup %*
if not defined _code ( 1>&2 echo%0: No command to execute & exit /b 1 )
set _code=!_code:'="!
call :timeit._measure
call :timeit._show_result
exit /b 0
#+++

:timeit._setup
(
    if not defined _is_macro goto 2> nul
    for %%v in (_code _loops) do set "%%v="
    set "_repeat=5"
    call :argparse --name timeit ^
        ^ "[code]:              set _code" ^
        ^ "[-n,--number LOOPS]: set _loops" ^
        ^ "[-r,--repeat N]:     set _repeat" ^
        ^ -- %* || exit /b 2
    if defined _loops (
        set "_start_repeat=1"
    ) else (
        set "_loops=1"
        set "_start_repeat=-5"
    )
    set "_min_time=20"
    set "_best_time=2147483647"
    set "_result=0"
    ( call )
)
exit /b 0
#+++

:timeit._measure
for /l %%r in (!_start_repeat!,1,!_repeat!) do (
    set "_measure=true"
    if %%r LEQ 0 if !_result! GEQ !_min_time! set "_measure="
    if defined _measure (
        set "_start_time=!time!"
        for /l %%l in (1,1,!_loops!) do %_code%
        call :difftime _result "!time!" "!_start_time!"
        if %%r LEQ 0 (
            if !_result! LSS !_min_time! (
                set /a "_loops=!_loops! * !_min_time! / (!_result! + 1)"
                set /a "_loops=1!_loops! - 9!_loops:~1!"
            )
        ) else if !_result! LSS !_best_time! set "_best_time=!_result!"
    )
)
exit /b 0
#+++

:timeit._show_result
call :timeit._format_time
echo !_loops! loops, best of !_repeat!: !_result! !_unit! per loop
exit /b 0
#+++

:timeit._format_time
set "_unit="
for %%a in (
    "nsec:10000000"
    "usec:10000"
    "msec:10"
    "sec:1/100"
    "min:1/6000"
    "hour:1/360000"
) do for /f "tokens=1* delims=:" %%b in (%%a) do (
    for /f "usebackq delims=" %%o in (
        `powershell -Command "'{0:g3}' -f (!_best_time! * %%c / !_loops!)"`
    ) do set "_result=%%o"
    set "_unit=%%b"
    if "!_result:e=!" == "!_result!" (
        for /f "tokens=1-2 delims=." %%d in ("!_result!") do (
            if %%d GTR 0 if %%d LSS 1000 exit /b 0
        )
    )
)
exit /b 0
#+++

:timeit.setup_macro
rem Mostly derived from timeit._measure()
set LF=^
%=REQUIRED=%
%=REQUIRED=%
call :macroify timeit "%~f0" "timeit._macro" || exit /b 3
set "timeit=!timeit:~0,-1!"
exit /b 0
#+++

:timeit._macro %:$args=[-n loops] [-r repetitions]% <code>
for /l %%# in (1,1,4) do ^
if "%%#" == "1" (
    setlocal EnableDelayedExpansion EnableExtensions
    set "_abort="
    set "_is_macro=true"
    call :timeit._setup  $args  || set "_abort=true"
) else if "%%#" == "3" (
    if not defined _abort call :timeit._show_result
) else if "%%#" == "4" (
    endlocal
) else if "%%#" == "2" if not defined _abort ^
for /l %%r in (!_start_repeat!,1,!_repeat!) do (
    set "_measure=true"
    if %%r LEQ 0 if !_result! GEQ !_min_time! set "_measure="
    ) & if defined _measure ^
    for /l %%# in (1,1,2) do ^
        if "%%#" == "2" (
            call :difftime _result "!time!" "!_start_time!"
            if %%r LEQ 0 (
                if !_result! LSS !_min_time! (
                    set /a "_loops=!_loops! * !_min_time!1 / !_result!1"
                    set /a "_loops=1!_loops! - 9!_loops:~1!"
                )
            ) else if !_result! LSS !_best_time! set "_best_time=!_result!"
        ) else if "%%#" == "1" (
            set "_start_time=!time!"
            ) & for /l %%l in (1,1,!_loops!) do
exit /b 0


:lib.dependencies [return_prefix]
set "%~1install_requires=argparse difftime macroify ext_powershell"
set "%~1category=time devtools"
exit /b 0


:doc.man
::  NAME
::      timeit - measure execution time of code
::
::  SYNOPSIS
::      timeit [-n loops] [-r repetitions] <code>
::      timeit.setup_macro
::      %timeit% <code>
::      %timeit:$args=[-n loops] [-r repetitions]% <code>
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the result.
::
::      code
::          Code to execute. Single quotes in code is converted
::          to double quotes when not used as macro.
::
::  OPTIONS
::      -n N, --number N
::          How many times to execute the code. By default, function repeatedly
::          execute the code until the total time is at least 0.2 second per
::          measurement.
::
::      -r N, --repeat N
::          How many times to repeat the timer (default 5).
::
::  NOTES
::      - Code is executed inside a SETLOCAL so no variables are affected.
::      - Macro can be used inside a FOR loop.
::      - The FOR loop parameter '%#' is used internally.
exit /b 0


:doc.demo
call :timeit.setup_macro

echo Measure time taken to run "REM"
call :timeit "rem"
echo=
echo Measure time taken to run "CALL"
call :timeit "call"
echo=
echo Measure time taken to read this file (using call)
call :timeit "for /f 'usebackq tokens=*' %%%%o in ('%~f0') do rem"
echo=
echo Measure time taken to read this file (using macro)
%timeit% for /f "usebackq tokens=*" %%o in ("%~f0") do rem
echo=
echo Measure time taken to read this file (using macro with parameters)
%timeit: $args = -n 234 -r 6 % for /f "usebackq tokens=*" %%o in ("%~f0") do rem
exit /b 0


:tests.setup
exit /b 0


:tests.teardown
exit /b 0


:tests.test_with_call
call :timeit "rem" > nul || (
    call %unittest% fail "Got error when testing valid command"
)
call :timeit -n 10000 -r 3 "call" > nul || (
    call %unittest% fail "Got error when testing valid command with arguments"
)
exit /b 0


:tests.test_with_macro
set "timeit="
call :timeit.setup_macro || (
    call %unittest% fail "Got error when testing setting up macro"
)
call :tests._test_with_macro._without_arguments > nul || (
    call %unittest% fail "Got error when testing valid command"
)
call :tests._test_with_macro._with_arguments > nul || (
    call %unittest% fail "Got error when testing valid command with arguments"
)
exit /b 0

:tests._test_with_macro._without_arguments
%timeit% help > nul
exit /b

:tests._test_with_macro._with_arguments
%timeit: $args = -n 30 -r 3 % help > nul
exit /b


:EOF
exit /b
