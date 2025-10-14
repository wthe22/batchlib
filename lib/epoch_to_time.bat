:entry_point
call %*
exit /b


:metadata [return_prefix]
set "%~1dependencies=fdate ftime"
set "%~1dev_dependencies=input_number"
set "%~1categories=convert time"
exit /b 0


:epoch_to_time <return_var> <epoch_time>
setlocal EnableDelayedExpansion
set /a "_days=%~2 / 86400"
set /a "_time=(%~2 %% 86400) * 100"
call :ftime _time "!_time!"
call :fdate _days "!_days!" "Y-M-D"
set "_result=!_days!_!_time:~0,-3!"
for /f "tokens=*" %%r in ("!_result!") do (
    endlocal
    set "%~1=%%r"
)
exit /b 0


:doc.man
::  NAME
::      epoch_to_time - convert epoch time to human readable date and time
::
::  SYNOPSIS
::      epoch_to_time <return_var> <epoch_time>
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the result.
::
::      epoch_time
::          The number of seconds since epoch (1 Jan 1970 00:00:00).
::
::  NOTES
::      - The date time format is 'YYYY-MM-DD_HH:MM:SS'.
::      - Function is not timezone aware thus no timezone conversion is done
exit /b 0


:doc.demo
call :input_number seconds_since_epoch --optional || (
    set "seconds_since_epoch=1234567890"
)
echo=
echo Seconds since epoch    : !seconds_since_epoch!
call :epoch_to_time result !seconds_since_epoch!
echo Formatted time         : !result!
exit /b 0


:tests.setup
:tests.teardown
exit /b 0


:tests.test_epoch
call :tests.check_conversion ^
    ^ "0            = 1970-01-01_00:00:00" ^
    ^ "2147483647   = 2038-01-19_03:14:07" ^
    ^ %=end=%
exit /b 0


:tests.test_new_year
call :tests.check_conversion ^
    ^ "946684799    = 1999-12-31_23:59:59" ^
    ^ "946684800    = 2000-01-01_00:00:00" ^
    ^ "1072915199   = 2003-12-31_23:59:59" ^
    ^ "1072915200   = 2004-01-01_00:00:00" ^
    ^ %=end=%
exit /b 0


:tests.test_leap_year
call :tests.check_conversion ^
    ^ "954287999    = 2000-03-28_23:59:59" ^
    ^ "951868800    = 2000-03-01_00:00:00" ^
    ^ "1048895999   = 2003-03-28_23:59:59" ^
    ^ "1046476800   = 2003-03-01_00:00:00" ^
    ^ "1080518399   = 2004-03-28_23:59:59" ^
    ^ "1078099200   = 2004-03-01_00:00:00" ^
    ^ %=end=%
exit /b 0


:tests.check_conversion <expected=args> [...]
for %%a in (
    %*
) do for /f "tokens=1* delims== " %%b in (%%a) do (
    set "given=%%b"
    call :epoch_to_time result "!given!" || (
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
