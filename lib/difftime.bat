:entry_point  # Beginning of file
call %*
exit /b


:difftime <return_var> <end_time> [start_time] [--no-fix]
set "%~1=0"
for %%t in ("%~2.0" "%~3.0") do for /f "tokens=1-4 delims=:., " %%a in ("%%~t.0.0.0.0") do (
    set /a "%~1+=(1%%a*2-2%%a)*360000 + (1%%b*2-2%%b)*6000 + (1%%c*2-2%%c)*100 + (1%%d*2-2%%d)*100/(2%%d-1%%d)"
    set /a "%~1*=-1"
)
if /i not "%4" == "--no-fix" if "!%~1:~0,1!" == "-" set /a "%~1+=8640000"
exit /b 0


:lib.build_system [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=Input.string"
set "%~1category=time"
exit /b 0


:doc.man
::  NAME
::      difftime - calculate time difference in centiseconds
::
::  SYNOPSIS
::      difftime <return_var> <end_time> [start_time] [--no-fix]
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the result.
::
::      end_time
::          The end time. The hour is zero padded.
::
::      start_time
::          The start time. By default, it is '00:00:00.00'. Supports
::          hours that are padded with spaces and zeros.
::
::  OPTIONS
::      --no-fix
::          Don't fix negative centiseconds. This must be placed
::          as the fourth argument.
::
::  NOTES
::      - The format of the time is 'HH:MM:SS.SS'.
::      - Supported time seperators: colon ':', dot '.', comma ',' space ' '
::      - If milliseconds (or higher precision) are provided, it will be
::        truncated to centiseconds.
exit /b 0


:doc.demo
call :Input.string start_time || set "start_time=!time!"
call :Input.string end_time || set "end_time=!time!"
call :difftime time_taken "!end_time!" "!start_time!"
echo=
echo Start time     : !start_time!
echo End time       : !end_time!
echo Difference     : !time_taken! centiseconds
exit /b 0


:tests.setup
:tests.teardown
exit /b 0


:tests.test_padding
call :tests.check_conversion ^
    ^ "4391999=12:11:59.99" ^
    ^ "4391900=12:11:59" ^
    ^ "4386000=12:11" ^
    ^ "4320000=12" ^
    ^ "0=" ^
    ^ %=end=%
exit /b 0


:tests.test_trimming
call :tests.check_conversion ^
    ^ "3288908= 9:08:09.08" ^
    ^ "4391987=12:11:59.876" ^
    ^ %=end=%
exit /b 0


:tests.test_diff_single_unit
call :tests.check_result ^
    ^ "1        = 00:00:00.12  00:00:00.11" ^
    ^ "100      = 00:00:12.00  00:00:11.00" ^
    ^ "6000     = 00:12:00.00  00:11:00.00" ^
    ^ "360000   = 12:00:00.00  11:00:00.00" ^
    ^ %=end=%
exit /b 0


:tests.test_diff_between_units
call :tests.check_result ^
    ^ "1        = 00:00:01.00  00:00:00.99" ^
    ^ "100      = 00:01:00.00  00:00:59.00" ^
    ^ "6000     = 01:00:00.00  00:59:00.00" ^
    ^ %=end=%
exit /b 0


:tests.test_warp_fix
call :tests.check_result ^
    ^ "1        = 00:00:00.00  23:59:59.99" ^
    ^ "8639999  = 00:00:00.00  00:00:00.01" ^
    ^ %=end=%
exit /b 0


:tests.test_seperator
call :tests.check_conversion ^
    ^ "366101=01:01:01.01" ^
    ^ "366101=01.01.01,01" ^
    ^ %=end=%
exit /b 0


:tests.check_conversion <expected=args> [...]
for %%a in (
    %*
) do for /f "tokens=1* delims==" %%b in (%%a) do (
    call :difftime result "%%c" || (
        call %unittest% fail "Given '%%c', got failure"
    )
    set "expected=%%b"
    if not "!result!" == "!expected!" (
        call %unittest% fail "Given '%%c', expected '!expected!', got '!result!'"
    )
)
exit /b 0


:tests.check_result <expected = args> [...]
for %%a in (
    %*
) do for /f "tokens=1* delims== " %%b in (%%a) do (
    call :difftime result %%c || (
        call %unittest% fail "Given '%%c', got failure"
    )
    set "expected=%%b"
    if not "!result!" == "!expected!" (
        call %unittest% fail "Given '%%c', expected '!expected!', got '!result!'"
    )
)
exit /b 0


rem ======================== function ========================

rem This is faster, assuming minutes, seconds, and centiseconds is always 2 digits
set /a "_centiseconds=24%%a %% 0x18 *0x57E40 +1%%b*0x1770 +1%%c*0x64 +1%%d -0x94F34"


:EOF  # End of File
exit /b
