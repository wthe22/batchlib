:entry_point
call %*
exit /b


:ut_fmt_basic <action> [args] ...
setlocal EnableDelayedExpansion EnableExtensions
2> nul (
    for /f "usebackq tokens=* delims= eol=#" %%v in (
        "!unittest.tmp_dir!\.ut_fmt_basic_vars"
    ) do set %%v
)
call :ut_fmt_basic.%*
> "!unittest.tmp_dir!\.ut_fmt_basic_vars" (
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
for /f "usebackq" %%k in ("!unittest.tmp_dir!\.unittest_test_cases") do set /a "_test_count+=1"
for %%e in (success fail error skip) do set "_%%e_count=0"
exit /b 0
#+++

:ut_fmt_basic.run <test_file> <test_label>
set /a "_tests_run+=1"
call :difftime _elapsed_time !time! !_start_time!
call :ftime _elapsed_time !_elapsed_time!
echo !_elapsed_time! [!_tests_run!/!_test_count!] %~1:%~2
exit /b 0
#+++

:ut_fmt_basic.outcome <test_file> <test_label> <outcome> [message]
set /a "_%~3_count+=1"
if "%~3" == "success" exit /b 0
if "%~4" == "" echo test '%~1:%~2' %~3
if not "%~4" == "" echo test '%~1:%~2' %~3: %~4
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


:lib.dependencies [return_prefix]
set "%~1install_requires=difftime ftime"
set "%~1extra_requires=unittest functions.range readline"
set "%~1category=devtools"
exit /b 0


:doc.man
::  NAME
::      ut_fmt_basic - basic outcome formatter/report generator for unittest
::
::  SYNOPSIS
::      ut_fmt_basic <action> [args] ...
::      ut_fmt_basic start
::      ut_fmt_basic run <test_file> <test_label>
::      ut_fmt_basic outcome <test_file> <test_label> <outcome> [message]
::      ut_fmt_basic stop
::
::  ACTIONS
::      Actions are the outputs from the unittest() library.
::      For more information, read documentation of unittest()
::
::  ENVIRONMENT
::      unittest.tmp_dir
::          Directory to store state information.
exit /b 0


:doc.demo
cd /d "!tmp_dir!" 2> nul || cd /d "!tmp!"
call :tests.type template.simple > "simple.bat"
call :unittest "simple.bat" -a "" -s "" -o "call :ut_fmt_basic"
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


:EOF
exit /b
