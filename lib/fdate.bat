:entry_point
call %*
exit /b


:fdate <return_var> <days_since_epoch>
setlocal EnableDelayedExpansion
set /a "_dso=%~2 + 135140 - 60"
set /a "_era=!_dso! / 146097"
set /a "_doe=!_dso! - !_era! * 146097"
set /a "_yoe=(!_doe! - !_doe!/1460 + !_doe!/36524 - !_doe!/146096) / 365"
set /a "_year=!_yoe! + !_era! * 400 + 1600"
set /a "_doy=!_doe! - (!_yoe!*365 + !_yoe!/4 - !_yoe!/100)"
set /a "_mp=(5 * !_doy! + 2) / 153"
set /a "_day=!_doy! - (153 * !_mp! + 2) / 5 + 1"
if !_mp! LSS 10 (
    set /a "_month=!_mp! + 3"
) else set /a "_month=!_mp! - 9"
if !_month! LEQ 2 set /a "_year+=1"
for %%v in (_month _day) do (
    set "%%v=0!%%v!"
    set "%%v=!%%v:~-2,2!"
)
set "_result=!_month!/!_day!/!_year!"
for /f "tokens=*" %%r in ("!_result!") do (
    endlocal
    set "%~1=%%r"
)
exit /b 0


:lib.dependencies [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=Input.string"
set "%~1category=time"
exit /b 0


:doc.man
::  NAME
::      fdate - convert days since epoch to human readable date
::
::  SYNOPSIS
::      fdate <return_var> <days_since_epoch>
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the result.
::
::      days_since_epoch
::          The number of days since epoch (January 1, 1970).
::
::  NOTES
::      - This function uses Gregorian calendar system.
::      - The format of the date is 'mm/dd/YYYY'.
exit /b 0


:doc.demo
call :Input.string days_since_epoch || set "days_since_epoch=365"
call :fdate result !days_since_epoch!
echo=
echo Days since epoch   : !days_since_epoch!
echo Formatted date     : !result!
exit /b 0


:tests.setup
:tests.teardown
exit /b 0


:tests.test_day
call :tests.check_result ^
    ^ "01/01/1970=0" ^
    ^ "01/02/1970=1" ^
    ^ "01/10/1970=9" ^
    ^ "01/31/1970=30" ^
    ^ %=end=%
exit /b 0


:tests.test_month
call :tests.check_result ^
    ^ "01/01/1970=0" ^
    ^ "02/01/1970=31" ^
    ^ "03/01/1970=59" ^
    ^ "04/01/1970=90" ^
    ^ "05/01/1970=120" ^
    ^ "06/01/1970=151" ^
    ^ "07/01/1970=181" ^
    ^ "08/01/1970=212" ^
    ^ "09/01/1970=243" ^
    ^ "10/01/1970=273" ^
    ^ "11/01/1970=304" ^
    ^ "12/01/1970=334" ^
    ^ %=end=%
exit /b 0


:tests.test_leap_year_4
call :tests.check_result ^
    ^ "02/29/1972=789" ^
    ^ "03/01/1972=790" ^
    ^ "02/28/1973=1154" ^
    ^ "03/01/1973=1155" ^
    ^ %=end=%
exit /b 0


:tests.test_leap_year_100
call :tests.check_result ^
    ^ "02/29/2000=11016" ^
    ^ "03/01/2000=11017" ^
    ^ "02/28/2100=47540" ^
    ^ "03/01/2100=47541" ^
    ^ %=end=%
exit /b 0


:tests.test_leap_year_400
call :tests.check_result ^
    ^ "02/29/2400=157113" ^
    ^ "03/01/2400=157114" ^
    ^ %=end=%
exit /b 0


:tests.check_result <expected:args> [...]
for %%a in (
    %*
) do for /f "tokens=1* delims==" %%b in (%%a) do (
    set "given=%%c"
    call :fdate result !given! || (
        call %unittest% fail "Given '!given!', got failure"
    )
    set "expected=%%b"
    if not "!result!" == "!expected!" (
        call %unittest% fail "Given '!given!', expected '!expected!', got '!result!'"
    )
)
exit /b 0


rem ======================== notes ========================

rem Implementation details:
rem http://howardhinnant.github.io/date_algorithms.html


:EOF
exit /b
