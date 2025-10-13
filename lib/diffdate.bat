:entry_point
call %*
exit /b


:metadata [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=input_string"
set "%~1category=time"
exit /b 0


:diffdate <return_var> <end_date> [start_date]
setlocal EnableDelayedExpansion
set "_difference=0"
set "_args=/%~2"
if "%~3" == "" (
    set "_args=!_args! /1/01/1970"
) else set "_args=!_args! /%~3"
set "_args=!_args:/ =/!"
set "_args=!_args:/0=/!"
for %%d in (!_args!) do for /f "tokens=1-3 delims=/" %%a in ("%%d") do (
    set /a "_difference+=(%%c-1970)*365 + (%%c/4 - %%c/100 + %%c/400 - 477) + (336 * (%%a-1) + 7) / 11 + %%b - 2"
    if %%a LEQ 2 set /a "_difference+=2-(((%%c %% 4)-8)/-8)*((((%%c %% 400)-512)/-512)+((((%%c %% 100)-128)/-128)-1)/-1)"
    set /a "_difference*=-1"
)
for /f "tokens=*" %%r in ("!_difference!") do (
    endlocal
    set "%~1=%%r"
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
::          The start date. By default, it is epoch (1/01/1970).
::
::  NOTES
::      - This function uses Gregorian calendar system (the generally used one).
::      - The date format used is 'mm/dd/YYYY'.
exit /b 0


:doc.demo
call :input_string --optional start_date || set "start_date=1/01/1970"
call :input_string --optional end_date || set "end_date=!date:* =!"
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


:tests.test_diff_year
call :tests.check_result ^
    ^ "01/01/2000 12/31/1999=1" ^
    ^ "01/01/2100 12/31/2099=1" ^
    ^ "01/01/2004 12/31/2003=1" ^
    ^ %=end=%
exit /b 0


:tests.test_diff_leap
call :tests.check_result ^
    ^ "03/01/2000  02/28/2000=2" ^
    ^ "03/01/2004  02/28/2004=2" ^
    ^ "03/01/2001  02/28/2001=1" ^
    ^ %=end=%
exit /b 0


:tests.test_diff_today
call :tests.check_result ^
    ^ "!date:~4! !date:~4!=0" ^
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
