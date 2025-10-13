:entry_point
call %*
exit /b


:metadata [return_prefix]
set "%~1dependencies=macroify"
set "%~1dev_dependencies=difftime ftime clear_line_macro"
set "%~1categories=time"
exit /b 0


:timeleft
call :timeleft._macro %* || exit /b
exit /b 0
#+++

:timeleft.setup_macro
set LF=^
%=REQUIRED=%
%=REQUIRED=%
call :macroify timeleft "%~f0" "timeleft._macro" || exit /b 3
set "timeleft=!timeleft:~0,-1!"
exit /b 0
#+++

:timeleft._macro %% <return_var> <start_time_cs> <current_progress> <total_progress>
for /l %%# in (1,1,3) do ^
if "%%#" == "1" (
    setlocal EnableDelayedExpansion
) else if "%%#" == "3" (
    for /f "tokens=1-4" %%a in ("!_args!") do (
        for /f "tokens=1-4 delims=:., " %%p in ("!time!") do (
            set /a "_remainder=24%%p %% 0x18 *0x57E40 +1%%q*0x1770 +1%%r*0x64 +1%%s -0x94F34 -%%b"
        )
        if "!_remainder:~0,1!" == "-" set /a "_remainder+=0x83D600"
        set /a "_remainder=!_remainder! * (%%d - %%c) / %%c"
        set "_result="
        for %%s in (0x57E40 0x1770 0x64 0x1) do (
            set /a "_digits=!_remainder! / %%s + 0x64"
            set /a "_remainder%%= %%s"
            set "_result=!_result!!_digits:~-2,2!:"
        )
        set "_result=!_result:~0,-4!.!_result:~-3,2!"
        for /f "tokens=*" %%r in ("!_result!") do (
            endlocal
            set "%%a=%%r"
        )
    )
) else if "%%#" == "2" ^
if "%0" == ":timeleft._macro" (
        call set _args=%%*
    ) else set _args=
exit /b 0


rem ############################################################################
rem Documentation
rem ############################################################################

:doc.man
::  NAME
::      timeleft - calculate the estimated time remaining for a task
::
::  SYNOPSIS
::      timeleft <return_var> <start_time_cs> <current_progress> <total_progress>
::      timeleft.setup_macro
::      %timeleft% <return_var> <start_time_cs> <current_progress> <total_progress>
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the time remaining. The time format is 'HH:MM:SS.SS'.
::
::      start_time_cs
::          The start time of the task (centiseconds since '00:00:00.00').
::
::      current_progress
::          Current iteration of the task.
::
::      total_progress
::          The total number of iterations to complete the task.
::
::  EXIT STATUS
::      0:  - Success
::      1:  - An unexpected error occured
::      3:  - Setup macro failed
::
::  NOTES
::      - Based on: difftime(), ftime()
exit /b 0


:doc.demo
call :clear_line_macro CL
call :timeleft.setup_macro
echo Count numbers of Quadratic Residue
echo=
for %%m in (without called macro) do (
    echo Run code - %%m timeleft

    set "start_time=!time!"
    echo [!start_time!] Start
    call :doc.demo.run_instance %%m > nul
    set "end_time=!time!"
    echo [!end_time!] End

    call :difftime time_taken "!end_time!" "!start_time!"
    if /i "%%m" == "without" set "base_time=!time_taken!"
    set /a "overhead_time+=!time_taken! - !base_time!"
    call :ftime time_taken !time_taken!
    call :ftime overhead_time !overhead_time!

    echo Actual time taken  : !time_taken!
    echo Overhead time      : !overhead_time!
    echo=
)
exit /b 0


:doc.demo.run_instance <method>
:: Quadratic Residue
setlocal EnableDelayedExpansion
set "method=%~1"
set "max=160"
set "expected_residue=1"
set "n=32"
set "count=0"
set /a "total_loops=!max! * (1+!max!) / 2"
call :difftime start_time_cs "!time!"
set "time_remaining=???"
for /l %%a in (0,1,!max!) do for /l %%b in (%%a,1,!max!) do (
    if not "%%a" == "%%b" (
        set /a "loops+=1"
        set /a "residue1=%%a*%%a %% !n!"
        set /a "residue2=%%b*%%b %% !n!"
        if "!residue1!,!residue2!" == "!residue2!,!expected_residue!" (
            echo p=%%a, a=%%b
            set /a "count+=1"
        )
        if not "!time!"  == "!update_time!" (
            set /a "current_loop=%%a * !max! + %%b - (%%a * (%%a + 1) / 2)"
            if /i "!method!" == "called" (
                call :timeleft time_remaining !start_time_cs! !current_loop! !total_loops!
            )
            if /i "!method!" == "macro" (
                %timeleft% time_remaining !start_time_cs! !current_loop! !total_loops!
            )
            < nul set /p "=!CL![!time!] Calculating... [!current_loop!/!total_loops!] ETA !time_remaining!" 1>&2
            set "update_time=!time!"
        )
    )
)
echo !CL![!time!] Found !count! numbers 1>&2
exit /b 0


rem ############################################################################
rem Tests
rem ############################################################################

:tests.setup
call :timeleft.setup_macro
exit /b 0


:tests.teardown
exit /b 0


:tests.test_call
call :difftime start_time_cs "!time!"
set /a "start_time_cs-=1"
if "!start_time_cs:~0,1!" == "-" set /a "start_time_cs+=8640000"
call :timeleft time_remaining !start_time_cs! 1 100
call :difftime result "!time_remaining!"
set "expected=99"
if !result! LSS !expected! (
    call %unittest% fail "Expected minimum of '!expected!', got '!result!'"
)
exit /b 0


:tests.test_macro
call :difftime start_time_cs "!time!"
set /a "start_time_cs-=1"
if "!start_time_cs:~0,1!" == "-" set /a "start_time_cs+=8640000"
%timeleft% time_remaining !start_time_cs! 1 100
call :difftime result "!time_remaining!"
set "expected=99"
if !result! LSS !expected! (
    call %unittest% fail "Expected minimum of '!expected!', got '!result!'"
)
exit /b 0


rem ############################################################################
rem End of File
rem ############################################################################

:EOF
@rem DO NOT WRITE ANYTHING YOU NEED TO KEEP BELOW THIS FUNCTION.
@rem ANYTHING BEYOND THIS FUNCTION WILL BE REMOVED WHEN ADDING DEPENDENCIES.
@exit /b
