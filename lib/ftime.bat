:entry_point
call %*
exit /b


:metadata [return_prefix]
set "%~1dependencies= "
set "%~1dev_dependencies=input_string"
set "%~1categories=time"
exit /b 0


:ftime <return_var> <centiseconds>
setlocal EnableDelayedExpansion
set "_result="
set /a "_remainder=%~2"
for %%s in (360000 6000 100 1) do (
    set /a "_digits=!_remainder! / %%s + 100"
    set /a "_remainder%%= %%s"
    set "_result=!_result!!_digits:~-2,2!:"
)
set "_result=!_result:~0,-4!.!_result:~-3,2!"
for /f "tokens=*" %%r in ("!_result!") do (
    endlocal
    set "%~1=%%r"
)
exit /b 0


:doc.man
::  NAME
::      ftime - convert time to human readable time
::
::  SYNOPSIS
::      ftime <return_var> <centiseconds>
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the result. The hour is zero padded.
::
::      centiseconds
::          The time in centiseconds (1/100 second).
::
::  NOTES
::      - The format of the time is 'HH:MM:SS.SS'.
::      - Hours is truncated to 2 digits only.
exit /b 0


:doc.demo
call :input_string --optional time_in_centisecond || set "time_in_centisecond=1234567"
call :ftime time_taken !time_in_centisecond!
echo=
echo Centiseconds   : !time_in_centisecond!
echo Formatted time : !time_taken!
exit /b 0


:tests.setup
:tests.teardown
exit /b 0


:tests.test_units
call :tests.check_result ^
    ^ "00:00:00.00 = 0" ^
    ^ "00:00:00.01 = 1" ^
    ^ "00:00:01.00 = 100" ^
    ^ "00:01:00.00 = 6000" ^
    ^ "01:00:00.00 = 360000" ^
    ^ %=end=%
exit /b 0


:tests.test_mixed
call :tests.check_result ^
    ^ "23:59:59.99 = 8639999" ^
    ^ "23:59:59.99 = 8639999" ^
    ^ "24:00:00.00 = 8640000" ^
    ^ "99:59:59.99 = 35999999" ^
    ^ %=end=%
exit /b 0


:tests.check_result <expected:args> [...]
for %%a in (
    %*
) do for /f "tokens=1* delims== " %%b in (%%a) do (
    call :ftime result %%c || (
        call %unittest% fail "Given '%%c', got failure"
    )
    set "expected=%%b"
    if not "!result!" == "!expected!" (
        call %unittest% fail "Given '%%c', expected '!expected!', got '!result!'"
    )
)
exit /b 0


:EOF
exit /b
