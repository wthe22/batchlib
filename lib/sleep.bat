:entry_point
call %*
exit /b


:sleep <milliseconds>
(
    setlocal EnableDelayedExpansion
    set "_start=!time!"
    set /a "_sec=%~1 / 1000 - 1"
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
set "%~1extra_requires=input_number difftime"
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
::          The valid range is from 0 to 100,000,000.
::
::  ENVIRONMENT
::      wait._increment
::          The increment speed for sleep(). This value is set by wait.calibrate().
::
::  NOTES
::      - Based on: difftime()
::      - This function have high CPU usage for maximum of 2 seconds on each call
::        because it is uses wait()
exit /b 0


:doc.demo
call :wait.setup_macro
call :wait.calibrate
echo=
call :input_number time_in_milliseconds --range "0~100000000" --optional || (
    set /a "time_in_milliseconds=!random! %% 500 * 10 + 100"
)
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
call :wait.calibrate > nul || (
    call %unittest% error "Calibration failed"
    exit /b 0
)
call :wait.setup_macro
exit /b 0


:tests.teardown
exit /b 0


:tests.test_consistency
set "expected=2250"  milliseconds
set "minimum=2000"  milliseconds
set "maximum=2750"  milliseconds
set "start_time=!time!"
call :sleep !expected!
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
