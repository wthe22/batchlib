:entry_point
call %*
exit /b


:epoch.from_time <return_var> <date_time>
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


:lib.dependencies [return_prefix]
set "%~1install_requires=diffdate difftime"
set "%~1extra_requires=Input.string"
set "%~1category=time"
exit /b 0


:doc.man
::  NAME
::      epoch.from_time - convert human readable date and time to epoch time
::
::  SYNOPSIS
::      epoch.from_time <return_var> <date_time>
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the result.
::
::      date_time
::          The input date and time.
::
::  NOTES
::      - The date time format is 'mm/dd/YYYY_HH:MM:SS'.
exit /b 0


:doc.demo
call :Input.string date_time || set "date_time=!date:* =!_!time!"
call :epoch.from_time result !date_time!
echo=
echo Epoch time : !result!
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


:tests.test_padding
call :tests.check_conversion ^
    ^ "946684800    = 1/1/2000_00:00:00" ^
    ^ "946684800    = 01/01/2000_ 0:00:00" ^
    ^ %=end=%
exit /b 0



:tests.check_conversion <expected=args> [...]
for %%a in (
    %*
) do for /f "tokens=1* delims== " %%b in (%%a) do (
    set "given=%%c"
    call :epoch.from_time result "!given!" || (
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
