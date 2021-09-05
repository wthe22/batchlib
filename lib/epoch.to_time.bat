:entry_point
call %*
exit /b


:epoch.to_time <return_var> <epoch_time>
setlocal EnableDelayedExpansion
set /a "_days=%~2 / 86400"
set /a "_time=(%~2 %% 86400) * 100"
call :ftime _time "!_time!"
call :fdate _days "!_days!"
set "_result=!_days!_!_time:~0,-3!"
for /f "tokens=*" %%r in ("!_result!") do (
    endlocal
    set "%~1=%%r"
)
exit /b 0


:lib.dependencies [return_prefix]
set "%~1install_requires=fdate ftime"
set "%~1extra_requires=Input.number"
set "%~1category=time"
exit /b 0


:doc.man
::  NAME
::      epoch.to_time - convert epoch time to human readable date and time
::
::  SYNOPSIS
::      epoch.to_time <return_var> <epoch_time>
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the result.
::
::      epoch_time
::          The number of seconds since epoch (January 1, 1970 00:00:00).
::
::  NOTES
::      - The date time format is 'mm/dd/YYYY_HH:MM:SS'.
exit /b 0


:doc.demo
call :Input.number seconds_since_epoch --optional || (
    set "seconds_since_epoch=1234567890"
)
echo=
echo Seconds since epoch    : !seconds_since_epoch!
call :epoch.to_time result !seconds_since_epoch!
echo Formatted time         : !result!
exit /b 0


:tests.setup
:tests.teardown
exit /b 0


:tests.test_epoch
call :tests.check_conversion ^
    ^ "0            = 01/01/1970_00:00:00" ^
    ^ "2147483647   = 01/19/2038_03:14:07" ^
    ^ %=end=%
exit /b 0


:tests.test_new_year
call :tests.check_conversion ^
    ^ "946684799    = 12/31/1999_23:59:59" ^
    ^ "946684800    = 01/01/2000_00:00:00" ^
    ^ "1072915199   = 12/31/2003_23:59:59" ^
    ^ "1072915200   = 01/01/2004_00:00:00" ^
    ^ %=end=%
exit /b 0


:tests.test_leap_year
call :tests.check_conversion ^
    ^ "954287999    = 03/28/2000_23:59:59" ^
    ^ "951868800    = 03/01/2000_00:00:00" ^
    ^ "1048895999   = 03/28/2003_23:59:59" ^
    ^ "1046476800   = 03/01/2003_00:00:00" ^
    ^ "1080518399   = 03/28/2004_23:59:59" ^
    ^ "1078099200   = 03/01/2004_00:00:00" ^
    ^ %=end=%
exit /b 0


:tests.check_conversion <expected=args> [...]
for %%a in (
    %*
) do for /f "tokens=1* delims== " %%b in (%%a) do (
    set "given=%%b"
    call :epoch.to_time result "!given!" || (
        call %unittest% fail "Given '!given!', got failure"
    )
    set "expected=%%c"
    if not "!result!" == "!expected!" (
        call %unittest% fail "Given '!given!', expected '!expected!', got '!result!'"
    )
)
exit /b 0


:EOF
exit /b
