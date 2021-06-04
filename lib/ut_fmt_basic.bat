:entry_point > nul 2> nul
call %*
exit /b


:ut_fmt_basic
setlocal EnableDelayedExpansion EnableExtensions
2> nul (
    for /f "usebackq tokens=* delims= eol=#" %%v in (".ut_fmt_basic._vars") do set %%v
)
call :ut_fmt_basic.%*
> ".ut_fmt_basic._vars" (
    for %%v in (
        _start_time _stop_time
        _tests_run _test_count
        _success_count _fail_count _error_count _skip_count
    ) do echo "%%v=!%%v!"
)
exit /b 0
#+++

:ut_fmt_basic.start
set "_start_time=!time!"
set "_tests_run=0"
set "_test_count="
for /f "usebackq" %%k in ("%unittest.tmp_dir%\.unittest_test_cases") do set /a "_test_count+=1"
for %%e in (success fail error skip) do set "_%%e_count=0"
exit /b 0
#+++

:ut_fmt_basic.run <test_name>
set /a "_tests_run+=1"
call :difftime _elapsed_time !time! !_start_time!
call :ftime _elapsed_time !_elapsed_time!
echo !_elapsed_time! [!_tests_run!/!_test_count!] %~1
exit /b 0
#+++

:ut_fmt_basic.outcome <test_name> <outcome> [message]
set /a "_%~2_count+=1"
if "%~2" == "success" exit /b 0
if "%~3" == "" echo test '%~1' %~2
if not "%~3" == "" echo test '%~1' %~2: %~3
exit /b 0
#+++

:ut_fmt_basic.stop
set "_stop_time=!time!"
call :difftime _time_taken !_stop_time! !_start_time!
call :ftime _time_taken !_time_taken!
if "!_tests_run!" == "1" (
    set "_s="
) else set "_s=s"
echo=
echo ----------------------------------------------------------------------
echo Ran !_tests_run! test!s! in !_time_taken!
echo=

set "_status=OK"
for %%e in (fail error) do (
    if not "!_%%e_count!" == "0" set "_status=FAILED"
)
< nul set /p "=!_status! "
set "_info= "
if not "!_fail_count!" == "0" set "_info=!_info! failures=!_fail_count!"
if not "!_error_count!" == "0" set "_info=!_info! errors=!_error_count!"
if not "!_skip_count!" == "0"  set "_info=!_info! skipped=!_skip_count!"
set "_info=!_info:~2!"
if defined _info < nul set /p "=(!_info!)"
echo=
exit /b 0


:ut_fmt_basic._num_padded
set "_num_min=1"
set "_num_width=0"
for /l %%n in (1,1,4) do if !_num_min! GEQ !_test_count! (
    set /a "_num_width=%%n"
    set /a "_num_min*=10"
)
set "_num_padding="
for /l %%n in (1,1,!_num_width!) do set "_num_padding=!_num_padding! "
set "_test_num=!_num_padding!!_tests_run!"
set "_test_num=!_test_num:~-%_num_width%,%_num_width%!"
exit /b 0


:lib.build_system [return_prefix]
set "%~1install_requires=difftime ftime"
set "%~1extra_requires=unittest functions.range readline"
set "%~1category=devtools"
exit /b 0


:doc.man
::  NAME
::      ut_fmt_basic - basic outcome formatter/report generator for unittest
::
::  SYNOPSIS
::      ut_fmt_basic start
::      ut_fmt_basic run <test_case>
::      ut_fmt_basic outcome <test_name> <outcome> [message]
::      ut_fmt_basic stop
::
::  ACTIONS
::      Actions are the outputs from the unittest() library.
::      For more information, read documentation of unittest()
exit /b 0


:doc.demo
cd /d "!tmp_dir!" 2> nul || cd /d "!tmp!"
set "test_reporter=call :ut_fmt_basic"
call :tests.type template.simple > "simple.bat"
call :unittest "simple.bat" -a "" -s "" -o test_reporter
exit /b 0


:tests.setup
exit /b 0


:tests.teardown
exit /b 0


:tests.template.simple
::  call %*
::  exit /b
::
::  :tests.setup
::  :tests.teardown
::  exit /b 0
::
::  :tests.test_success
::  exit /b 0
::
::  :tests.test_skip
::  call %unittest% skip "Not ready"
::  exit /b 0
::
::  :tests.test_fail
::  call %unittest% fail "1 + 1 is not 3"
::  exit /b 0
::
::  :tests.test_error
::  call %unittest% error "Something unexpected happen"
::  exit /b 0
exit /b 0


:tests.type <name>
call :functions.range _range "%~f0" tests.%~1 || exit /b
call :readline "%~f0" !_range! 1:-1 4
exit /b


:EOF  # End of File
exit /b