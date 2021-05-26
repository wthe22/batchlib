:entry_point > nul 2> nul
call %*
exit /b


:timeleft <return_var> <start_time_cs> <current_progress> <total_progress>
for /f "tokens=1-4 delims=," %%a in (
    "%~1,%~2,%~3,%~4"
) do (
    setlocal EnableDelayedExpansion
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
exit /b 0


:lib.build_system [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=difftime ftime clear_line_macro"
set "%~1category=time"
exit /b 0


:doc.man
::  NAME
::      timeleft - calculate the estimated time remaining for a task
::
::  SYNOPSIS
::      timeleft <return_var> <start_time_cs> <current_progress> <total_progress>
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
::  NOTES
::      - Based on: difftime(), ftime()
::      - Put the function below (not above) where you need it,
::        because it is much faster.
::      - If performance is still an issue, just integrate it
::        in your script (usually multiple times faster).
exit /b 0


:doc.demo
call :clear_line_macro CL
for %%m in (without called integrated) do (
    echo Doing some hard task - %%m timeleft
    set "start_time=!time!"
    echo [!start_time!] Start
    call :doc.demo.run_instance %%m
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
            set /a "count+=1"
        )

        if not "!time!"  == "!update_time!" (
            set /a "current_loop=%%a * !max! + %%b - (%%a * (%%a + 1) / 2)"
            if /i "!method!" == "called" (
                call :timeleft time_remaining !start_time_cs! !current_loop! !total_loops!
            )
            if /i "!method!" == "integrated" (
                for /f "tokens=1-4 delims=," %%a in (
                    "time_remaining,!start_time_cs!,!current_loop!,!total_loops!"
                ) do (
                    setlocal EnableDelayedExpansion
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
            )
            < nul set /p "=!CL![!time!] !current_loop!/!total_loops!: ETA !time_remaining!"
            set "update_time=!time!"
        )
    )
)
echo !CL![!time!] Result: !count!
exit /b 0


:EOF  # End of File
exit /b
