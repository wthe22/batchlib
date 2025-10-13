:entry_point
call %*
exit /b


:metadata [return_prefix]
set "%~1install_requires=difftime"
set "%~1extra_requires=input_number difftime"
set "%~1category=time"
exit /b 0


:wait <milliseconds>
for %%t in (%~1) do %wait%
exit /b 0
#+++

:wait.calibrate [delay_target]
setlocal EnableDelayedExpansion
call :wait.setup_macro
set ".wait._increment=100000"
if not "%~1" == "" set /a "_delay_target=%~1" || exit /b 1
set "_time_taken=-1"
for /l %%i in (1,1,12) do if not "!_time_taken!" == "!_delay_target!" (
    if "%~1" == "" set "_delay_target=!.wait._increment:~0,3!"
    set "_start_time=!time!"
    for %%t in (!_delay_target!) do %wait%
    call :difftime _time_taken "!time!" "!_start_time!"
    set /a "_time_taken*=10"
    echo [%%i] !.wait._increment!: !_delay_target! -^> ~!_time_taken!
    set /a "_next=!.wait._increment! * !_time_taken! / !_delay_target!"
    if "!_next!" == "0" (
        set /a ".wait._increment=!.wait._increment! / 10 + 1"
    ) else set ".wait._increment=!_next!"
)
echo [END] !.wait._increment!
for /f "tokens=*" %%r in ("!.wait._increment!") do (
    endlocal
    set ".wait._increment=%%r"
)
exit /b 0
#+++

:wait.setup_macro
set wait=for /l %%w in (0,^^!.wait._increment^^!,%%t00000) do call
exit /b 0


:doc.man
::  NAME
::      wait - delay for n milliseconds
::
::  SYNOPSIS
::      wait.calibrate [delay_target]
::      wait <milliseconds>
::      wait.setup_macro
::      for %t in (<milliseconds>) do %wait%
::
::  POSITIONAL ARGUMENTS
::      milliseconds
::          The number of milliseconds to delay.
::          The valid range is from 0 to 21474 milliseconds.
::
::      delay_target
::          The delay (in milliseconds) to use for calibration. By default, it is
::          automatically adjusted according to the result of each calibration.
::
::  ENVIRONMENT
::      This function uses global variables.
::
::      .wait._increment
::          The increment speed for wait(). This value is set by wait.calibrate().
::          Higher value means that the computer is slower.
::
::  NOTES
::      - wait() have high CPU usage (for 1 logical processor only)
::      - Using %wait% macro is more preferable than calling the function
::        because it has more consistent results
::      - Consistency depends greatly on system state. It is best when device is
::        plugged in, uses Best Performance mode, and is idle. The worst is seen
::        when the device is on battery, uses Battery Saver mode, or under
::        significat load.
exit /b 0


:doc.demo
echo Calibrating wait()
call :wait.calibrate
echo Calibration done: !.wait._increment!
call :wait.setup_macro
echo=
call :input_number time_in_milliseconds --range "0~21474" --optional || (
    set /a "time_in_milliseconds=!random! %% 300 * 10 + 100"
)
echo=
echo Wait for !time_in_milliseconds! milliseconds...
set "start_time=!time!"

rem Using macro
for %%t in (!time_in_milliseconds!) do %wait%

rem Called
rem call :wait !time_in_milliseconds!

call :difftime time_taken "!time!" "!start_time!"
set /a "time_taken*=10"
echo=
echo Actual time taken: ~!time_taken! milliseconds
exit /b 0


:tests.setup
set "expected=1250"  milliseconds
rem The computer might get a bit faster sometimes
set "minimum=1000"  milliseconds
rem Although it tends to get significantly slower most of the time
set "maximum=1750"  milliseconds
call :wait.calibrate > nul || (
    call %unittest% error "Calibration failed"
    exit /b 0
)
call :wait.setup_macro
exit /b 0


:tests.teardown
exit /b 0


:tests.test_macro_consistency
set "start_time=!time!"
for %%t in (!expected!) do %wait%
call :difftime result "!time!" "!start_time!"
set /a "result*=10"
if !result! LSS !minimum! (
    call %unittest% fail "Given '!expected!', expected minimum '!minimum!', got '!result!'"
)
if !result! GTR !maximum! (
    call %unittest% fail "Given '!expected!', expected maximum '!maximum!', got '!result!'"
)
exit /b 0


:tests.test_call_consistency
set "start_time=!time!"
call :wait !expected!
call :difftime result "!time!" "!start_time!"
set /a "result*=10"
if !result! LSS !minimum! (
    call %unittest% fail "Given '!expected!', expected minimum '!minimum!', got '!result!'"
)
if !result! GTR !maximum! (
    call %unittest% fail "Given '!expected!', expected maximum '!maximum!', got '!result!'"
)
exit /b 0


:EOF
exit /b
