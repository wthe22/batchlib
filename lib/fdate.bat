:entry_point
call %*
exit /b


:metadata [return_prefix]
set "%~1dependencies= "
set "%~1dev_dependencies=input_string"
set "%~1categories=time"
exit /b 0


:fdate <return_var> <days_since_epoch> <format>
setlocal EnableDelayedExpansion
set "_return_var=%~1"
set "_epoch=%~2"
set "_format=%~3"
if not defined _format set "_format=Y-M-D"
set /a "_dso=!_epoch! + 135140 - 60"
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
set "_result=!_format!"
for %%a in (
    Y:_year M:_month D:_day
) do for /f "tokens=1-2 delims=:" %%b in ("%%a") do (
    for %%v in (!%%c!) do set "_result=!_result:%%b=%%v!"
)
for %%v in (!_return_var!) do for /f "tokens=1* delims=:" %%q in ("Q:!_result!") do (
    endlocal
    set "%%v=%%r"
)
exit /b 0


:doc.man
::  NAME
::      fdate - convert days since epoch to human readable date
::
::  SYNOPSIS
::      fdate <return_var> <days_since_epoch> <format>
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the result.
::
::      days_since_epoch
::          The number of days since epoch (January 1, 1970).
::
::      format
::          Date format. By default, it is 'Y-M-D'. To use old format, use "M/D/Y".
::
::  NOTES
::      - This function uses Gregorian calendar system (the generally used one).
exit /b 0


:doc.demo
call :input_string --optional days_since_epoch || set "days_since_epoch=365"
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
    ^ "1970-01-01=0" ^
    ^ "1970-01-02=1" ^
    ^ "1970-01-10=9" ^
    ^ "1970-01-31=30" ^
    ^ %=end=%
exit /b 0


:tests.test_month
call :tests.check_result ^
    ^ "1970-01-01=0" ^
    ^ "1970-02-01=31" ^
    ^ "1970-03-01=59" ^
    ^ "1970-04-01=90" ^
    ^ "1970-05-01=120" ^
    ^ "1970-06-01=151" ^
    ^ "1970-07-01=181" ^
    ^ "1970-08-01=212" ^
    ^ "1970-09-01=243" ^
    ^ "1970-10-01=273" ^
    ^ "1970-11-01=304" ^
    ^ "1970-12-01=334" ^
    ^ %=end=%
exit /b 0


:tests.test_leap_year_4
call :tests.check_result ^
    ^ "1972-02-29=789" ^
    ^ "1972-03-01=790" ^
    ^ "1973-02-28=1154" ^
    ^ "1973-03-01=1155" ^
    ^ %=end=%
exit /b 0


:tests.test_leap_year_100
call :tests.check_result ^
    ^ "2000-02-29=11016" ^
    ^ "2000-03-01=11017" ^
    ^ "2100-02-28=47540" ^
    ^ "2100-03-01=47541" ^
    ^ %=end=%
exit /b 0


:tests.test_leap_year_400
call :tests.check_result ^
    ^ "2400-02-29=157113" ^
    ^ "2400-03-01=157114" ^
    ^ %=end=%
exit /b 0


:tests.test_format
call :tests.check_result ^
    ^ "09/11/2001=11576 M/D/Y" ^
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
