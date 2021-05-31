:entry_point > nul 2> nul
call %*
exit /b


:wait <delay>
for %%t in (%~1) do %wait%
exit /b 0
#+++

:wait.calibrate [delay_target]
setlocal EnableDelayedExpansion
echo Calibrating wait()
call :wait.setup_macro
set "wait._increment=100000"
if not "%~1" == "" set /a "_delay_target=%~1" || exit /b 1
set "_time_taken=-1"
for /l %%i in (1,1,12) do if not "!wait._increment!" == "-1" if not "!_time_taken!" == "!_delay_target!" (
    if "%~1" == "" set "_delay_target=!wait._increment:~0,3!"
    set "_start_time=!time!"
    for %%t in (!_delay_target!) do %wait%
    set "_time_taken=0"
    for %%t in ("!time!" "!_start_time!") do for /f "tokens=1-4 delims=:., " %%a in ("%%~t") do (
        set /a "_time_taken+=24%%a %% 0x18 *0x57E40 +1%%b*0x1770 +1%%c*0x64 +1%%d -0x94F34"
        set /a "_time_taken*=0xffffffff"
    )
    if "!_time_taken:~0,1!" == "-" set /a "_time_taken+=0x83D600"
    set /a "_time_taken*=10"
    echo Calibration #%%i: !wait._increment!, !_delay_target! -^> ~!_time_taken! milliseconds
    set /a "_next=!wait._increment! * !_time_taken! / !_delay_target!"
    if "!_next!" == "0" (
        set /a "wait._increment=!wait._increment! / 10"
    ) else set "wait._increment=!_next!"
    if !wait._increment! LEQ 0 set "wait._increment=-1"
)
echo Calibration done: !wait._increment!
for /f "tokens=*" %%r in ("!wait._increment!") do (
    endlocal
    set "wait._increment=%%r"
)
if "!wait._increment!" == "-1" exit /b 1
exit /b 0
#+++

:wait.setup_macro
set wait=for /l %%w in (0,^^!wait._increment^^!,%%t00000) do call
exit /b 0


:lib.build_system [return_prefix]
set "%~1install_requires= "
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
::          The number of milliseconds to delay. Supports delay up to 21474 milliseconds.
::
::      delay_target
::          The delay (in milliseconds) to use for calibration. This is used to adjust the
::          calibration time. By default, it is automatically adjusted according
::          to the result of each calibration.
::
::  ENVIRONMENT
::      wait._increment
::          The increment speed for wait(). This value is set by wait.calibrate().
::
::  NOTES
::      - wait.calibrate():
::          - Based on: difftime()
::      - wait() have high CPU usage
::      - Using %wait% macro is more preferable than calling the function
::        because it has more consistent results
::      - wait.calibrate() calibrates up to 12 times before exiting.
exit /b 0


:doc.demo
call :wait.setup_macro
call :wait.calibrate
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
set "threshold=200"  milliseconds
set "expected=1250"  milliseconds
call :wait.setup_macro
call :wait.calibrate > nul || set "wait._increment="
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
    call %unittest% fail "given threshold '!threshold!', expected '!expected!', got '!result!'"
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
    call %unittest% fail "given threshold '!threshold!', expected '!expected!', got '!result!'"
)
exit /b 0


:EOF  # End of File
exit /b
