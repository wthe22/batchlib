:entry_point  # Beginning of file
call %*
exit /b


:timeit [-n loops] [-r repetitions] <code>
setlocal EnableDelayedExpansion
set "_is_macro="
call :timeit._setup %*
if not defined _code ( 1>&2 echo error: No command to execute & exit /b 1 )
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
    call :argparse ^
        ^ "#1:store                 :_code" ^
        ^ "-n,--number:store        :_loops" ^
        ^ "-r,--repeat:store        :_repeat" ^
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
call :macroify timeit "%~f0" "timeit._macro" || exit /b 3
set "timeit=!timeit:~0,-1!"
exit /b 0
#+++

:timeit._macro
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


:lib.build_system [return_prefix]
set "%~1install_requires=argparse difftime macroify"
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
echo Measure time taken to read this file (using macro with parameters)
%timeit: $args = -n 10 -r 5 % for /f "usebackq tokens=*" %%o in ("%~f0") do rem
exit /b 0


:EOF  # End of File
exit /b
