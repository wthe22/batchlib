:entry_point > nul 2> nul
call %*
exit /b


:timeit [-n loops] [-r repetitions] <code>
setlocal EnableDelayedExpansion
call :timeit._parse_args %*
if defined _as_macro (
    endlocal
    call :timeit._parse_args %*
)
if defined _loops (
    set "_start_repeat=1"
) else (
    set "_loops=1"
    set "_start_repeat=-5"
)
set "_min_time=20"
set "_best_time=2147483647"
set "_result=0"
if defined _as_macro exit /b 0
set "_code= !_code!"
set _code=!_code:'="!
if "!_code: =!" == "" ( 1>&2 echo error: No command to execute & exit /b 1 )
set "_code=!_code:~1!"
call :timeit._measure
call :timeit._result
exit /b 0
#+++

:timeit._parse_args
(
    goto 2> nul
    for %%v in (_as_macro _loops) do set "%%v="
    set "_repeat=5"
    call :argparse ^
        ^ "[]1:store                :_code" ^
        ^ "m/as-macro:store_const   :_as_macro=true" ^
        ^ "n/number:store           :_loops" ^
        ^ "r/repeat:store           :_repeat" ^
        ^ -- %* || exit /b 2
)
exit /b 1
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
                set /a "_loops=!_loops! * !_min_time!1 / !_result!1"
                set /a "_loops=1!_loops! - 9!_loops:~1!"
            )
        ) else if !_result! LSS !_best_time! set "_best_time=!_result!"
    )
)
exit /b 0
#+++

:timeit._result
set "_sf=1"
set "_nodot=-2"
set "_temp=!_best_time!"
for /l %%n in (1,1,10) do (
    set /a "_temp/=10"
    if not "!_temp!" == "0" set /a "_sf+=1"
)
for %%t in (3) do if !_sf! LEQ %%t (
    for /l %%n in (1,1,%%t) do set /a "_best_time*=10"
    set /a "_nodot-=%%t"
)
set /a "_best_time/=!_loops:~0,1!"
set "_temp=!_loops!"
for /l %%n in (1,1,5) do (
    set /a "_temp/=10"
    if not "!_temp!" == "0" set /a "_nodot-=1"
)
set "_unit="
for %%a in (
    "nsec:-9"
    "usec:-6"
    "msec:-3"
    "sec:0"
    "min:60"
    "hour:3600  :last"
) do for /f "tokens=1-2* delims=:" %%b in (%%a) do ( rem
) & if not defined _unit (
    if %%c LEQ 0 (
        set "_div=1"
        for /l %%n in (!_nodot!,1,%%c) do set "_div=10*!_div!"
    ) else (
        set "_div=%%c"
        for /l %%n in (!_nodot!,1,0) do set "_div=10*!_div!"
    )
    set /a "_div=!_div!/10"
    if "!_div!" == "0" set "_div=1"
    set /a "_whole=!_best_time!/!_div!"
    if !_whole! LSS 1000 set "_unit=%%b"
    if "%%c" == "last" set "_unit=%%b"
)
set /a "_remainder=!_best_time! %% !_div! * 100 / !_div!"
set "_remainder=00!_remainder!"
set "_remainder=!_remainder:~-2,2!"
set "_result=!_whole!.!_remainder!"
set "_result=!_result:~0,4!"
if "!_result:~3,1!" == "." set "_result=!_result:~0,3!"
echo !_loops! loops, best of !_repeat!: !_result! !_unit! per loop
exit /b 0
#+++

:timeit.setup_macro
rem Mostly derived from timeit._measure()
set LF=^
%=REQUIRED=%
%=REQUIRED=%
set timeit= ^( call !LF!^
    ^ ^) ^& for /l %%# in (1,1,4) do if "%%#" == "0" ^( call !LF!^
    ^ ^) else if "%%#" == "1" ^( !LF!^
    ^     setlocal EnableDelayedExpansion EnableExtensions !LF!^
    ^     set "_args_valid=" !LF!^
    ^     call :timeit --as-macro  $args  %=END=% ^&^& set "_args_valid=true" !LF!^
    ^ ^) else if "%%#" == "3" ^( !LF!^
    ^     if defined _args_valid call :timeit._result !LF!^
    ^ ^) else if "%%#" == "4" ^( !LF!^
    ^     endlocal !LF!^
    ^ ^) else if "%%#" == "2" if defined _args_valid ^( call !LF!^
    ^ ^) ^& for /l %%r in ^(^^!_start_repeat^^!,1,^^!_repeat^^!^) do ^( !LF!^
    ^     set "_measure=true" !LF!^
    ^     if %%r LEQ 0 if ^^!_result^^! GEQ ^^!_min_time^^! set "_measure=" !LF!^
    ^ ^) ^& if defined _measure ^( call !LF!^
    ^ ^) ^& for /l %%# in ^(1,1,2^) do if "%%#" == "0" ^( call !LF!^
    ^ ^) else if "%%#" == "2" ^( !LF!^
    ^     call :difftime _result ^"^^!time^^!^" ^"^^!_start_time^^!^" !LF!^
    ^     if %%r LEQ 0 ^( !LF!^
    ^         if ^^!_result^^! LSS ^^!_min_time^^! ^( !LF!^
    ^             set /a ^"_loops=^^!_loops^^! * ^^!_min_time^^!1 / ^^!_result^^!1^" !LF!^
    ^             set /a ^"_loops=1^^!_loops^^! - 9^^!_loops:~1^^!^" !LF!^
    ^         ^) !LF!^
    ^     ^) else if ^^!_result^^! LSS ^^!_best_time^^! set ^"_best_time=^^!_result^^!^" !LF!^
    ^ ^) else if "%%#" == "1" ^( !LF!^
    ^     set ^"_start_time=^^!time^^!^" !LF!^
    ^ ^) ^& for /l %%l in ^(1,1,^^!_loops^^!^) do
exit /b 0


:lib.build_system [return_prefix]
set "%~1install_requires=argparse difftime"
set "%~1category=time devtools"
exit /b 0


:doc.man
::  NAME
::      timeit - measure execution time of code
::
::  SYNOPSIS
::      timeit [-n loops] [-r repetitions] <code>
::      timeit.setup_macro
::      %timeit[:$args=[-n loops] [-r repetitions]]%   code
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
::          How many times to execute function.
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
echo Measure time taken to read this file line by line
call :timeit "for /f 'usebackq tokens=*' %%%%o in ('%~f0') do rem"
echo=
echo Measure time taken to read this file (using macro)
%timeit% for /f "usebackq tokens=*" %%o in ("%~f0") do rem
echo=
::echo Measure time taken to read this file (using macro with parameters)
::%timeit: $args = -n 10 -r 5 % for /f "usebackq tokens=*" %%o in ("%~f0") do rem
:: TODO: adjust $args to argparse
exit /b 0


:EOF  # End of File
exit /b
