:entry_point
call %*
exit /b


:metadata [return_prefix]
set "%~1dependencies=diffdate difftime"
set "%~1dev_dependencies=input_string"
set "%~1categories=convert time"
exit /b 0


:epoch_from_time <return_var> <date_time>
setlocal EnableDelayedExpansion
for /f "tokens=1-2 delims=_" %%a in ("%~2") do (
    call :diffdate _days "%%a"
    call :difftime _seconds "%%b"
)
set /a "_epoch=!_days!*86400 + !_seconds!/100"
for /f "tokens=*" %%r in ("!_epoch!") do (
    endlocal
    set "%~1=%%r"
)
exit /b 0


:doc.man
::  NAME
::      epoch_from_time - convert human readable date and time to epoch time
::
::  SYNOPSIS
::      epoch_from_time <return_var> <date_time>
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the result.
::
::      date_time
::          The input date and time.
::
::  NOTES
::      - The date time format is 'YYYY/MM/DD_HH:MM:SS'.
::      - Function is not timezone aware thus no timezone conversion is done
exit /b 0


:doc.demo
call :input_string --optional date_time || set "date_time=!date:* =!_!time!"
call :epoch_from_time result !date_time!
echo=
echo Date and time:
echo=!date_time!
echo=
echo Epoch time : !result!
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
    set "given=%%c"
    call :epoch_from_time result "!given!" || (
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
