:entry_point
call %*
exit /b


:metadata [return_prefix]
set "%~1dependencies= "
set "%~1dev_dependencies=input_string isotime"
set "%~1categories=time"
exit /b 0


:diffdate <return_var> <end_date> [start_date]
setlocal EnableDelayedExpansion
set "_return_var=%~1"
set "_end_date=%~2"
set "_start_date=%~3"
if not defined _start_date set "_start_date=1970-01-01"
set "_dates=-!_end_date! -!_start_date!"
set "_dates=!_dates:- =-!"
set "_dates=!_dates:-0=-!"
set "_difference=0"
for %%d in (!_dates!) do for /f "tokens=1-3 delims=-" %%a in ("%%d") do (
    set /a "_difference+=(%%a-1970)*365 + (%%a/4 - %%a/100 + %%a/400 - 477) + (336 * (%%b-1) + 7) / 11 + %%c - 2"
    if %%b LEQ 2 set /a "_difference+=2-(((%%a %% 4)-8)/-8)*((((%%a %% 400)-512)/-512)+((((%%a %% 100)-128)/-128)-1)/-1)"
    set /a "_difference*=-1"
)
for /f "tokens=*" %%r in ("!_difference!") do (
    endlocal
    set "%_return_var%=%%r"
)
exit /b 0


:doc.man
::  NAME
::      diffdate - calculate date difference in days
::
::  SYNOPSIS
::      diffdate <return_var> <end_date> [start_date]
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the result.
::
::      end_date
::          The end date.
::
::      start_date
::          The start date. By default, it is epoch (1970-1-01).
::
::  NOTES
::      - This function uses Gregorian calendar system (the generally used one).
::      - The date format used is 'YYYY-MM-DD'.
exit /b 0


:doc.demo
call :input_string --optional start_date || set "start_date=1970-1-01"
call :input_string --optional end_date || call :isotime end_date
call :diffdate difference !end_date! !start_date!
echo=
echo Start date : !start_date!
echo End date   : !end_date!
echo Difference : !difference! Days
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


:tests.test_diff_year
call :tests.check_result ^
    ^ "2000-01-01 1999-12-31=1" ^
    ^ "2100-01-01 2099-12-31=1" ^
    ^ "2004-01-01 2003-12-31=1" ^
    ^ %=end=%
exit /b 0


:tests.test_diff_leap
call :tests.check_result ^
    ^ "2000-03-01  2000-02-28=2" ^
    ^ "2004-03-01  2004-02-28=2" ^
    ^ "2001-03-01  2001-02-28=1" ^
    ^ %=end=%
exit /b 0


:tests.test_padding
call :tests.check_result ^
    ^ "2000-1-1=10957" ^
    ^ "2000-01-01=10957" ^
    ^ %=end=%
exit /b 0


:tests.test_known
call :tests.check_result ^
    ^ "2025-10-14=20375" ^
    ^ %=end=%
exit /b 0


:tests.check_result <expected:args> [...]
for %%a in (
    %*
) do for /f "tokens=1* delims==" %%b in (%%a) do (
    set "given=%%b"
    call :diffdate result !given! || (
        call %unittest% fail "Given '!given!', got failure"
    )
    set "expected=%%c"
    if not "!result!" == "!expected!" (
        call %unittest% fail "Given '!given!', expected '!expected!', got '!result!'"
    )
)
exit /b 0


rem ======================== notes ========================

rem Days from month formula
rem
rem         days_from_month = (336 * (%%a-1) + 7) / 11
rem
rem     In this formula we assume february to be 30 days, so we need to fix it:
rem
rem         if month > 2:
rem             days_from_month -= 2
rem
rem Leap year detection
rem
rem         is_zero = (( (your_value_here) -max_value)/-max_value)
rem         is_divisible_by_4 = (((year %% 4)-8)/-8)
rem         is_divisible_by_100 = (((year %% 100)-128)/-128)
rem         is_divisible_by_400 = (((year %% 400)-512)/-512)
rem         is_leap_year = is_divisible_by_4 * (is_divisible_by_400 + (is_divisible_by_100 - 1)/-1)
rem         is_leap_year = is_divisible_by_4 AND (is_divisible_by_400 OR (NOT is_divisible_by_100))
rem
rem     In here, 1 means it is true and 0 means it is false.


:EOF
exit /b
