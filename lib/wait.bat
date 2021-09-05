:entry_point
call %*
exit /b


:wait <delay>
for %%t in (%~1) do %wait%
exit /b 0
#+++

:wait.calibrate [delay_target]
setlocal EnableDelayedExpansion
call :wait.setup_macro
set "wait._increment=100000"
if not "%~1" == "" set /a "_delay_target=%~1" || exit /b 1
set "_time_taken=-1"
for /l %%i in (1,1,12) do if not "!_time_taken!" == "!_delay_target!" (
    if "%~1" == "" set "_delay_target=!wait._increment:~0,3!"
    set "_start_time=!time!"
    for %%t in (!_delay_target!) do %wait%
    call :difftime _time_taken "!time!" "!_start_time!"
    set /a "_time_taken*=10"
    echo [%%i] !wait._increment!: !_delay_target! -^> ~!_time_taken!
    set /a "_next=!wait._increment! * !_time_taken! / !_delay_target!"
    if "!_next!" == "0" (
        set /a "wait._increment=!wait._increment! / 10 + 1"
    ) else set "wait._increment=!_next!"
)
echo [END] !wait._increment!
for /f "tokens=*" %%r in ("!wait._increment!") do (
    endlocal
    set "wait._increment=%%r"
)
exit /b 0
#+++

:wait.setup_macro
set wait=for /l %%w in (0,^^!wait._increment^^!,%%t00000) do call
exit /b 0


:lib.dependencies [return_prefix]
set "%~1install_requires=difftime"
set "%~1extra_requires=Input.number difftime"
set "%~1category=time"
exit /b 0


:doc.man
::  NAME
::      wait - delay for n milliseconds
::
::  SYNOPSIS
::      wait.calibrate [delay_target]
::      wait <delay>
::      wait.setup_macro
::      for %t in (delay) do %wait%
::
::  POSITIONAL ARGUMENTS
::      delay
::          The number of milliseconds to delay. Supports up to 21474 milliseconds.
::
::      delay_target
::          The delay (in milliseconds) to use for calibration. By default, it is
::          automatically adjusted according to the result of each calibration.
::
::  ENVIRONMENT
::      wait._increment
::          The increment speed for wait(). This value is set by wait.calibrate().
::          Higher value means that the computer is slower.
::
::  NOTES
::      - wait() have high CPU usage
::      - Using %wait% macro is more preferable than calling the function
::        because it has more consistent results
::      - Accuracy depends on power mode of windows. Best Performance mode have
::        the best accuracy while Battery Saver mode have the worst accuracy.
exit /b 0


:doc.demo
echo Calibrating wait()
call :wait.calibrate
echo Calibration done: !wait._increment!
call :wait.setup_macro
echo=
call :Input.number time_in_milliseconds --range "0~10000"
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
set "threshold=250"  milliseconds
set "expected=1250"  milliseconds
call :wait.calibrate > nul || (
    call %unittest% error "Calibration failed"
    exit /b 0
)
call :wait.setup_macro
exit /b 0


:tests.teardown
exit /b 0


:tests.test_macro_accuracy
set "start_time=!time!"
for %%t in (!expected!) do %wait%
call :difftime result "!time!" "!start_time!"
set /a "result*=10"
set /a "inaccuracy=!result! - !expected!"
set /a "fail=!inaccuracy!/!threshold!"
if not "!fail!" == "0" (
    call %unittest% fail "Given threshold '!threshold!', expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_call_accuracy
set "start_time=!time!"
call :wait !expected!
call :difftime result "!time!" "!start_time!"
set /a "result*=10"
set /a "inaccuracy=!result! - !expected!"
set /a "fail=!inaccuracy!/!threshold!"
if not "!fail!" == "0" (
    call %unittest% fail "Given threshold '!threshold!', expected '!expected!', got '!result!'"
)
exit /b 0


:EOF
exit /b
