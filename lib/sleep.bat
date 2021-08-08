:entry_point  # Beginning of file
call %*
exit /b


:sleep <milliseconds>
(
    setlocal EnableDelayedExpansion
    set "_start=!time!"
    set /a "_sec=%~1 / 1000"
    if not "!_sec:~0,1!" == "-" timeout /t !_sec! /nobreak > nul
    set "_remaining=0"
    for %%t in ("!time!" "!_start!") do for /f "tokens=1-4 delims=:., " %%a in ("%%~t") do (
        set /a "_remaining+=24%%a %% 0x18 *0x57E40 +1%%b*0x1770 +1%%c*0x64 +1%%d -0x94F34"
        set /a "_remaining*=0xffffffff"
    )
    if "!_remaining:~0,1!" == "-" set /a "_remaining+=0x83D600"
    set /a "_remaining=%~1 - !_remaining! * 10"
    for %%t in (!_remaining!) do %wait%
)
exit /b 0


:lib.dependencies [return_prefix]
set "%~1install_requires=wait"
set "%~1extra_requires=Input.number difftime"
set "%~1category=time"
exit /b 0


:doc.man
::  NAME
::      sleep - delay for n milliseconds
::
::  SYNOPSIS
::      sleep <milliseconds>
::
::  POSITIONAL ARGUMENTS
::      milliseconds
::          The number of milliseconds to delay.
::
::  ENVIRONMENT
::      wait._increment
::          The increment speed for sleep(). This value is set by wait.calibrate().
::
::  NOTES
::      - Based on: difftime()
::      - This function have high CPU usage for maximum of 1 seconds on each call
::        because it is uses wait()
exit /b 0


:doc.demo
call :wait.setup_macro
call :wait.calibrate
echo=
call :Input.number time_in_milliseconds --range "0~2147483647"
echo=
echo Wait for !time_in_milliseconds! milliseconds...
set "start_time=!time!"

call :sleep !time_in_milliseconds!

call :difftime time_taken "!time!" "!start_time!"
set /a "time_taken*=10"
echo=
echo Actual time taken: ~!time_taken! milliseconds
exit /b 0


:tests.setup
:tests.teardown
exit /b 0


:tests.test_accuracy
set "threshold=300"  milliseconds
set "test_delay=2000"  milliseconds

call :wait.setup_macro
call :wait.calibrate > nul || (
    call %unittest% fail "Calibration failed"
    exit /b 0
)

set "start_time=!time!"
call :sleep !test_delay!
call :difftime time_taken "!time!" "!start_time!"
set /a "time_taken*=10"
set /a "inaccuracy=!time_taken! - !test_delay!"
set /a "fail=!inaccuracy!/!threshold!"
if not "!fail!" == "0" (
    call %unittest% fail "Given threshold '!threshold!', expected '!test_delay!', got '!time_taken!'"
)
exit /b 0


:EOF  # End of File
exit /b
