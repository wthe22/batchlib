:entry_point  # Beginning of file
call %*
exit /b


:what_day <return_var> <date> [--number|--short]
setlocal EnableDelayedExpansion
call :diffdate _day "%~2" 1/01/1583
set /a _day=(!_day! + 6) %% 7
if /i not "%3" == "--number" (
    if "!_day!" == "0" set "_day=Sunday"
    if "!_day!" == "1" set "_day=Monday"
    if "!_day!" == "2" set "_day=Tuesday"
    if "!_day!" == "3" set "_day=Wednesday"
    if "!_day!" == "4" set "_day=Thursday"
    if "!_day!" == "5" set "_day=Friday"
    if "!_day!" == "6" set "_day=Saturday"
    if /i "%3" == "--short" set "_day=!_day:~0,3!"
)
for /f "tokens=*" %%r in ("!_day!") do (
    endlocal
    set "%~1=%%r"
)
exit /b 0


:lib.dependencies [return_prefix]
set "%~1install_requires=diffdate"
set "%~1extra_requires=Input.string"
set "%~1category=time"
exit /b 0


:doc.man
::  NAME
::      what_day - determine what day is a date
::
::  SYNOPSIS
::      what_day <return_var> <date> [--number|--short]
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the result.
::
::      date
::          The input date.
::
::  OPTIONS
::      --number
::          Returns number value (0: Sunday, 1: Monday). This must be placed as
::          the third argument. Mutually exclusive with '--short'.
::
::      --short
::          Returns short date name (first 3 letters). This must be placed as
::          the third argument. Mutually exclusive with '--number'.
::
::  NOTES
::      - This function uses Gregorian calendar system.
exit /b 0


:doc.demo
call :Input.string a_date || set "a_date=!date:* =!"
echo=
call :what_day day "!a_date!"
echo Date '!a_date!' is !day!
exit /b 0


:tests.setup
:tests.teardown
exit /b 0


:tests.test_all
for %%a in (
    "Saturday:      1/01/1583"
    "Monday:        1/01/1923"
    "Thursday:      1/01/1970"
    "Saturday:      1/01/2000"

    "Sat:   1/01/2000 --short"
    "6:   1/01/2000 --number"
) do for /f "tokens=1* delims=:" %%b in (%%a) do (
    set "given=%%c"
    call :what_day result !given!
    set "expected=%%b"
    if not "!result!" == "!expected!" (
        call %unittest% fail "Given '!given!', expected '!expected!', got '!result!'"
    )
)
exit /b 0


:EOF  # End of File
exit /b
