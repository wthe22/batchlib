:entry_point
call %*
exit /b


:metadata [return_prefix]
set "%~1dependencies= "
set "%~1dev_dependencies=macroify input_string"
set "%~1categories=time extension"
exit /b 0


:isotime <return_var> [datetime]
setlocal EnableDelayedExpansion
set _return_var=$return_var
if "!_return_var!" == "$!!return_var" (
    set "_return_var=%~1"
    set "_datetime=%~2"
) else (
    if "%%~d" == "%%!!~d" (
        set "_datetime="
    ) else set "_datetime=%%~d"
)
if not defined _datetime set "_datetime=!date!"
for %%v in (_ymd _h _m _s) do set "%%v="
for %%p in (!_datetime!) do (
    set "_part=%%p"
    set "_sep="
    for %%s in (/ - :) do (
        if not "!_part:%%s=!" == "!_part!" set "_sep=!_sep!%%s"
    )
    if "!_sep:~1,1!" == "" for %%s in (!_sep!) do (
        set "_part=%%s!_part!"
        set "_part=!_part:%%s0=%%s!"
    )
    if /i "!_part!" == "AM" (
        set /a "_h=!_h! %% 12"
    ) else if /i "!_part!" == "PM" (
        set /a "_h=!_h! %% 12 + 12"
    ) else for /f "tokens=1-3 delims=/-:" %%a in ("!_part!") do (
        if "!_sep!" == "-" (
            if %%a GTR 1000 (
                set "_ymd=%%a-%%b-%%c"
            ) else set "_ymd=%%c-%%b-%%a"
        )
        if "!_sep!" == "/" (
            if %%a GTR 12 (
                set "_ymd=%%a-%%b-%%c"
            ) else set "_ymd=%%c-%%a-%%b"
        )
        if "!_sep!" == ":" (
            set "_h=%%a"
            set "_m=%%b"
            set "_s=%%c"
        )
    )
)
for /f "tokens=1-3 delims=/-. " %%a in ("!_ymd!") do (
    if %%a LSS 1000 (
        set /a "_year=2000+%%a"
    ) else set /a "_year=%%a"
    set "_month=%%b"
    set "_day=%%c"
    
    for %%l in (
        1:Jan 2:Feb 3:Mar 4:Apr 5:May 6:Jun
        7:Jul 8:Aug 9:Sep 10:Oct 11:Nov 12:Dec
    ) do for /f "tokens=1-3 delims=:" %%m in ("%%l") do (
        if /i "!_month!" == "%%n" set "_month=%%m"
    )
)
for %%v in (_year _month _day _h _m _s) do if defined %%v (
    if "!%%v:~1,1!" == "" (
        set "%%v=0!%%v!"
    ) else if "!%%v:~1,1!" == "." set "%%v=0!%%v!"
)
set "_result="
if defined _year set "_result=!_result!!_year!-!_month!-!_day!"
if defined _year if defined _h set "_result=!_result!T"
if defined _h set "_result=!_result!!_h!:!_m!"
if defined _s set "_result=!_result!:!_s!"
for %%v in (!_return_var!) do for /f "tokens=1* delims=:" %%q in ("Q:!_result!") do (
    endlocal
    set "%%v=%%r"
    if not defined %%v set /a 2> nul
)
exit /b


rem ############################################################################
rem Documentation
rem ############################################################################

:doc.man
::  NAME
::      isotime - Convert date/time into ISO format
::
::  SYNOPSIS
::      isotime <return_var> <datetime>
::
::  DESCRIPTION
::      Convert date, time, datetime to ISO format.
::
::      Supported date formats:
::          - a m/d/y (Tue 9/11/2001, Tue 9/11/01)
::          - m/d/y (9/11/2001, 09/11/01)
::          - y/m/d (01/09/11)
::          - y-m-d (2001-09-11)
::          - d-b-y (11-Sep-01)
::
::      Supported time formats:
::          - HH:MM[:SS[.SSS]] (7:30, 09:11, 09:11:01, 7:30:59.001)
::          - HH:MM[:SS[.SSS]] AM/PM (7:30 AM, 09:11:20 PM)
::
::      The result will be in ISO format:
::          - YYYY-MM-DD (date)
::          - HH:MM[:SS[.SSS]] (time)
::          - YYYY-MM-DDTHH:MM[:SS[.SSS]] (datetime)
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the result.
::
::      datetime
::          The date/time/datetime to convert. By default, it is today's date.
::
::  EXIT STATUS
::      What the exit code of your function means. Some examples are:
::      0:  - Success
::      1:  - An unexpected error occured
::      n:  - Invalid format
::
::  NOTES
::      - Function can distinguish all the supported dates format given that the
::        year is known to be 2013 or later, otherwise there no way to guarantee
::        correctness.
::      - Function can be converted to macro using macroify()
exit /b 0


:doc.demo
echo Current
echo Date   : !date!
echo Time   : !time!
echo=
call :input_string --optional any_date || set "any_date=!date! !time!"
echo=
echo Date       : !any_date!
call :isotime result "!any_date!"
set "exit_code=!errorlevel!"
echo Exit code !exit_code!
echo=
echo ISO Date   : !result!
exit /b 0


rem ############################################################################
rem Tests
rem ############################################################################

:tests.setup
exit /b 0


:tests.teardown
exit /b 0


:tests.test_date
for %%a in (
    "2025-09-01=Mon 9/1/2025"
    "2025-09-01=Mon 9/1/25"
    "2025-09-01=9/1/25"
    "2025-09-01=9/1/2025"
    "2025-09-01=25/9/1"
    "2025-10-13=2025-10-13"
    "2025-10-13=13-Oct-25"
) do for /f "tokens=1* delims==" %%b in (%%a) do (
    set "given=%%c"
    set "expected=%%b"
    call :isotime result "!given!" || (
        call %unittest% fail "Given '!given!', got failure"
    )
    if not "!result!" == "!expected!" (
        call %unittest% fail "Given '!given!', expected '!expected!', got '!result!'"
    )
)
exit /b 0


:tests.test_time
for %%a in (
    "02:18=2:18 AM"
    "14:18=2:18 PM"
    "00:18=12:18 AM"
    "12:18=12:18 PM"
    "11:33:59=11:33:59 AM"
    "23:33:59.999=11:33:59.999 PM"
) do for /f "tokens=1* delims==" %%b in (%%a) do (
    set "given=%%c"
    set "expected=%%b"
    call :isotime result "!given!" || (
        call %unittest% fail "Given '!given!', got failure"
    )
    if not "!result!" == "!expected!" (
        call %unittest% fail "Given '!given!', expected '!expected!', got '!result!'"
    )
)
exit /b 0


:tests.test_datetime
for %%a in (
    "2021-04-30T09:55=04/30/2021 09:55 AM"
    "2021-04-30T10:55=04/30/2021 10:55 AM"
    "2021-04-30T00:55=04/30/2021 12:55 AM"
) do for /f "tokens=1* delims==" %%b in (%%a) do (
    set "given=%%c"
    set "expected=%%b"
    call :isotime result "!given!" || (
        call %unittest% fail "Given '!given!', got failure"
    )
    if not "!result!" == "!expected!" (
        call %unittest% fail "Given '!given!', expected '!expected!', got '!result!'"
    )
)
exit /b 0


:tests.test_zeros
for %%a in (
    "2008-09-08=Mon 09/08/2008"
    "2025-09-08=Mon 09/08/25"
    "2025-09-08=09/08/25"
    "2025-09-08=09/08/2025"
    "2025-09-08=25/09/08"
    "2001-09-08=2001-09-08"
    "2025-09-08=08-Sep-25"
    
    "09:08=09:08 AM"
    "21:08=09:08 PM"
    "07:08:09=07:08:09 AM"
    "19:08:09.009=07:08:09.009 PM"
    "00:00=00:00 AM"
    "12:00=00:00 PM"
    "00:00:00=00:00:00 AM"
    "12:00:00.000=00:00:00.000 PM"
) do for /f "tokens=1* delims==" %%b in (%%a) do (
    set "given=%%c"
    set "expected=%%b"
    call :isotime result "!given!" || (
        call %unittest% fail "Given '!given!', got failure"
    )
    if not "!result!" == "!expected!" (
        call %unittest% fail "Given '!given!', expected '!expected!', got '!result!'"
    )
)
exit /b 0


:tests.test_macro
call :macroify isotime "%~f0" "isotime" || exit /b 3
for %%a in (
    "2025-09-01=Mon 9/1/2025"
    "2025-09-01=Mon 9/1/25"
    "2025-09-01=9/1/25"
    "2025-09-01=9/1/2025"
    "2025-09-01=25/9/1"
    "04:06=04:06 AM"
    "16:06=4:06 PM"
    "2021-04-30T09:55=04/30/2021 09:55 AM"
) do for /f "tokens=1* delims==" %%b in (%%a) do (
    set "given=%%c"
    set "expected=%%b"
    for %%d in ("!given!") do ( %isotime:$return_var=result% ) || (
        call %unittest% fail "Given '!given!', got failure"
    )
    if not "!result!" == "!expected!" (
        call %unittest% fail "Given '!given!', expected '!expected!', got '!result!'"
    )
)
for %%d in ("potato") do ( %isotime:$return_var=result% ) && (
    call %unittest% fail "Given '%%d', expected failure, got '!result!'"
)
exit /b 0


rem ############################################################################
rem End of File
rem ############################################################################

:EOF
@rem DO NOT WRITE ANYTHING YOU NEED TO KEEP BELOW THIS FUNCTION.
@rem ANYTHING BEYOND THIS FUNCTION WILL BE REMOVED WHEN ADDING DEPENDENCIES.
@exit /b
