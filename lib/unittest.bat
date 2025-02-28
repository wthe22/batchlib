:entry_point
call %*
exit /b


:unittest [-f] [-p pattern] [-a target_args] [-o format] [target]
setlocal EnableDelayedExpansion EnableExtensions
for %%v in (
    target fail_fast pattern argument output_format output_cmd
) do set "unittest.%%v="
set "unittest.target=%~f0"
set "unittest.pattern=test*.test*"
set "unittest.target_args=-c"
call :argparse --name %0 ^
    ^ "[target]:                    set unittest.target" ^
    ^ "[-f,--failfast]:             set unittest.fail_fast=true" ^
    ^ "[-p,--pattern PATTERN]:      set unittest.pattern" ^
    ^ "[-a,--target-args ARGS]:     set unittest.target_args" ^
    ^ "[-o,--output FORMAT]:        set unittest.output_format" ^
    ^ -- %* || exit /b 2
call :unittest._init || (
    1>&2 echo%0: Failed to initialize unittest
    exit /b 4
)
call :unittest._load_tests || (
    1>&2 echo%0: Failed to load tests
    exit /b 4
)
%unittest.output_cmd% start
call :unittest._run
%unittest.output_cmd% stop
call :unittest._cleanup
if defined unittest._failed exit /b 3
exit /b 0
#+++

:unittest._init
set "unittest.start_dir=!cd!"
cd /d "!tmp_dir!" 2> nul || cd /d "!tmp!"
for %%f in ("unittest") do set "unittest.tmp_dir=%%~ff"
md "!unittest.tmp_dir!"
cd /d "!unittest.tmp_dir!" || exit /b 2
set "tmp_dir=!unittest.tmp_dir!"
rem Make sure unittest is callable from external scripts
call :functions_range _range "%~f0" "unittest" || exit /b 2
> "unittest.bat" (
    echo :entry_point
    echo call %%*
    echo exit /b
    echo=
    echo=
    call :readline "%~f0" !_range!
) || exit /b 3
for %%f in ("unittest.bat") do (
    set unittest="%%~ff" :unittest.outcome %=REQUIRED=%
)
if not defined unittest.output_format (
    set "unittest.output_cmd=echo"
) else if "!unittest.output_format!" == "raw" (
    set "unittest.output_cmd=echo"
) else if "!unittest.output_format!" == "basic" (
    set "unittest.output_cmd=call :unittest.fmt.basic"
) else if "!unittest.output_format!" == "experimental-tap" (
    set "unittest.output_cmd=call :unittest.fmt.etap"
) else if "!unittest.output_format:~0,7!" == "custom:" (
    set "unittest.output_cmd=!%unittest.output_format:~7%!"
)
if not defined unittest.output_cmd (
    1>&2 echo%0: Invalid output format '!unittest.output_format!'. Using default.
    set "unittest.output_cmd=echo"
)
exit /b 0
#+++

:unittest._load_tests
set "unittest.top_dir="
pushd "!unittest.start_dir!"
> "!unittest.tmp_dir!\.unittest_test_cases" (
    for %%f in ("!unittest.target!") do (
        if not defined unittest.top_dir set "unittest.top_dir=%%~dpf"
        call :functions_match _labels "%%~ff" "!unittest.pattern!"
        for %%l in (!_labels!) do echo %%~nf:%%l
    )
)
popd
if not exist "!unittest.top_dir!" exit /b 1
set "unittest.top_dir=!unittest.top_dir:~0,-1!"
exit /b 0
#+++

:unittest._cleanup
cd /d "!unittest.start_dir!"
rd /s /q "!unittest.tmp_dir!"
exit /b 0
#+++

:unittest._run
set "unittest._failed="
set "unittest._test_file="
setlocal EnableDelayedExpansion
for /f "usebackq tokens=1-2 delims=:" %%k in ("%unittest.tmp_dir%\.unittest_test_cases") do (
    if not "%%k" == "!unittest._test_file!" (
        if defined unittest._test_file (
            call "%unittest.top_dir%\!unittest._test_file!" ^
                ^ %unittest.target_args% :tests.teardown
            endlocal
        )
        setlocal EnableDelayedExpansion
        set "unittest._test_file=%%k"
        set "unittest._test_label="
        set "unittest._setup_outcome="
        call "%unittest.top_dir%\%%k" %unittest.target_args% :tests.setup || (
            call :unittest.outcome error ^
                ^ "Test setup did not exit correctly [exit code !errorlevel!]."
        )
    )
    set "unittest._test_label=%%l"
    set "unittest._outcome="
    %unittest.output_cmd% run "!unittest._test_file!","!unittest._test_label!"
    if defined unittest._setup_outcome (
        call :unittest.outcome !unittest._setup_outcome!
    ) else (
        setlocal EnableDelayedExpansion EnableExtensions
        call "%unittest.top_dir%\!unittest._test_file!" ^
            ^ %unittest.target_args% :!unittest._test_label!
        for %%e in (!errorlevel!) do (
            if "%%e" == "0" (
                if not defined unittest._outcome call :unittest.outcome success
            ) else (
                call :unittest.outcome error ^
                    ^ "Test function did not exit correctly [exit code %%e]."
            )
        )
        if defined unittest.fail_fast if defined unittest._failed exit /b 0
        endlocal
    )
)
if defined unittest._test_file (
    call "%unittest.top_dir%\!unittest._test_file!" %unittest.target_args% :tests.teardown
)
exit /b 0
#+++

:unittest.outcome <outcome> [message]
set "unittest._outcome=%~1"
for %%e in (fail error) do if "%~1" == "%%e" (
    set "unittest._failed=true"
)
if defined unittest._test_label (
    %unittest.output_cmd% outcome "!unittest._test_file!","!unittest._test_label!",%1,%2
) else set unittest._setup_outcome=%1,%2
exit /b 0
#+++

:unittest.fmt.basic <action> [args] ...
setlocal EnableDelayedExpansion EnableExtensions
2> nul (
    for /f "usebackq tokens=* delims= eol=#" %%v in (
        "!unittest.tmp_dir!\.unittest.fmt.basic_vars"
    ) do set %%v
)
call :unittest.fmt.basic.%*
> "!unittest.tmp_dir!\.unittest.fmt.basic_vars" (
    for %%v in (
        _start_time _stop_time
        _tests_run _test_count
        _success_count _fail_count _error_count _skip_count
    ) do echo "%%v=!%%v!"
)
exit /b 0
#+++

:unittest.fmt.basic.start
set "_start_time=!time!"
set "_tests_run=0"
set "_test_count="
for /f "usebackq" %%k in ("!unittest.tmp_dir!\.unittest_test_cases") do set /a "_test_count+=1"
for %%e in (success fail error skip) do set "_%%e_count=0"
exit /b 0
#+++

:unittest.fmt.basic.run <test_file> <test_label>
set /a "_tests_run+=1"
call :difftime _elapsed_time !time! !_start_time!
call :ftime _elapsed_time !_elapsed_time!
echo !_elapsed_time! [!_tests_run!/!_test_count!] %~1:%~2
exit /b 0
#+++

:unittest.fmt.basic.outcome <test_file> <test_label> <outcome> [message]
set /a "_%~3_count+=1"
if "%~3" == "success" exit /b 0
if "%~4" == "" echo test '%~1:%~2' %~3
if not "%~4" == "" echo test '%~1:%~2' %~3: %~4
exit /b 0
#+++

:unittest.fmt.basic.stop
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
#+++

:unittest.fmt.etap <action> [args] ...
rem TAP output formatter
rem Made for experimental purposes only. Probably not TAP compliant...
setlocal EnableDelayedExpansion EnableExtensions
2> nul (
    for /f "usebackq tokens=* delims= eol=#" %%v in (
        "!unittest.tmp_dir!\.experimental.fmt.tap_vars"
    ) do set %%v
)
call :unittest.fmt.etap.%*
> "!unittest.tmp_dir!\.experimental.fmt.tap_vars" (
    for %%v in (
        _test_number
        _reported
    ) do echo "%%v=!%%v!"
)
exit /b 0
#+++

:unittest.fmt.etap.start
set "_test_number=0"
set "_test_total=0"
for /f "usebackq" %%k in ("!unittest.tmp_dir!\.unittest_test_cases") do set /a "_test_total+=1"
echo 1..!_test_total!
exit /b 0
#+++

:unittest.fmt.etap.run <test_file> <test_label>
set /a "_test_number+=1"
set "_reported="
exit /b 0
#+++

:unittest.fmt.etap.outcome <test_file> <test_label> <outcome> [message]
if defined _reported exit /b 0
if "%~3" == "success" (
    echo ok !_test_number! - %~2
) else if "%~3" == "skip" (
    echo ok !_test_number! - # SKIP %~4
) else (
    echo not ok !_test_number! - %~4
)
set "_reported=true"
exit /b 0
#+++

:unittest.fmt.etap.stop
exit /b 0


:lib.dependencies [return_prefix]
set %~1install_requires= ^
    ^ argparse functions_match functions_range readline ^
    ^ difftime ftime ^
    ^ %=END=%
set "%~1extra_requires=functions_range readline"
set "%~1category=debug"
exit /b 0


:doc.man
::  NAME
::      unittest - unit testing framework
::
::  SYNOPSIS
::      unittest [-f] [-p pattern] [-a target_args] [-o output_cmd] [target]
::      call %unittest% <outcome> [message]
::
::  DESCRIPTION
::      unittest() is a unit testing framework for batch script. It search for
::      labels that match the pattern in the script and run the tests.
::
::      In unittest(), test cases that is successful is indicated by not having
::      outcome of fail/error/skip and return exit code 0.
::
::      Unittests can be initialized by adding tests.setup(). It will be called
::      first before running any tests in each file. Cleanup function can also
::      be run after running all tests by implementing tests.teardown().
::
::  POSITIONAL ARGUMENTS
::      target
::          Path/pattern to the script(s) to be tested. By default, it is the
::          current script.
::
::      outcome
::          Outcome of the test. Valid values are: fail, error, skip
::
::      message
::          Additional message to include at the outcome
::
::  OPTIONS
::      -f, --failfast
::          Stop on first fail or error
::
::      -p LABEL_PATTERN, --pattern LABEL_PATTERN
::          Pattern to match in tests labels ('test*.test*' default).
::
::      -a TARGET_ARGS, --target-args TARGET_ARGS
::          Arguments to add to call functions in the target script. For example,
::          if you use `myscript.bat run :tests.test_me` to call ':tests.test_me',
::          then the TARGET_ARGS is 'run'. By default, it is '-c'.
::
::      -o FORMAT, --output FORMAT
::          The output format. By default it is 'raw'.
::          Available formats: raw, basic, experimental-tap, custom:<MACRO_VAR>
::
::  UNITTEST USAGE
::      Test File
::          Each test file should contain tests.setup(), tests.teardown(), and at
::          least 1 test case to run unittest.
::
::      tests.setup()
::          A function called before tests in a file is run. Use skip/fail/error
::          here to mark all tests at once. If function is not callable, this
::          will be considered an error.
::
::      tests.teardown()
::          A function called after tests in a file is run. This is called even
::          if all tests or tests.setup() fails.
::
::      Success
::          A test is marked as successful if no failure/error/skip is signaled
::          and the test case returns exit code 0.
::
::      Failure
::              call %unittest% fail [message]
::
::          Signals a test as failure. Used when a test case fails
::          (e.g. the function did not give the expected result).
::
::          Can be used multiple times in a test case (e.g. for subtests).
::
::      Error
::              call %unittest% error [message]
::
::          Signals a test as error. Used when an unexpected error occur
::          (e.g. test case fails to run).
::
::      Skip
::              call %unittest% skip [reason]
::
::          Signals a test as skipped. Running the code above does not quit the
::          test case immediately so 'exit /b 0' is still required to actually
::          skip the test.
::
::  OUTPUTS
::      start
::          Preparation is done and unittest is about to start
::
::      run <file>,<label>
::          Unittest is running tests in the following file and label
::
::      outcome <file>,<label>,<success|fail|error|skip>,[message]
::          Report outcome of the test as either: success, fail, error, or skip,
::          with the following message/reason
::
::      stop
::          Unittest have stopped gracefully
::
::  ENVIRONMENT
::      This function uses:
::      - Temporary files
::
::      Global variables that affects this function:
::      - tmp_dir: Path to store the temporary files
::      - tmp: Fallback path of tmp_dir
::
::  EXIT STATUS
::      0:  - Unittest passed
::      1:  - An unexpected error occured
::      2:  - Invalid argument
::      3:  - Unittest failed
::      4:  - Cannot do necessary setups
::
::  NOTES
::      - The variable name 'unittest' and variable names that starts with
::        'unittest.*' are reserved.
::      - Using reserved variables in your tests might cause unexpected behavior.
exit /b 0


:doc.demo
cd /d "!tmp_dir!" 2> nul || cd /d "!tmp!"
> "simple.bat" (
    call :tests.type template.normal_entry_point || exit /b
    call :tests.type template.simple || exit /b
)
echo=
echo Using 'raw' output
echo=
call :unittest "simple.bat"
echo=
echo=
echo Using 'basic' output
echo=
call :unittest "simple.bat" -o basic
echo=
echo=
echo Using 'experimental-tap' output
echo=
call :unittest "simple.bat" -o experimental-tap
exit /b 0


:tests.setup
set "STDERR_REDIRECTION=2> nul"
call :tests.type template.normal_entry_point > "normal_entry_point.bat" || exit /b
> "simple.bat" (
    type "normal_entry_point.bat" || exit /b
    call :tests.type template.simple || exit /b
)
> "success.bat" (
    type "normal_entry_point.bat" || exit /b
    call :tests.type template.success || exit /b
)
exit /b 0


:tests.teardown
exit /b 0


:tests.template.normal_entry_point
::  if not ^"%1^" == "-c" (
::      echo mark missing_argument
::      exit /b 2
::  )
::  call :%*
::  exit /b
::
::  :-c
::  call %*
::  exit /b
::
exit /b 0


:tests.template.simple
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


:tests.template.success
::  :tests.setup
::  :tests.teardown
::  exit /b 0
::
::  :tests.test_success_only
::  exit /b 0
exit /b 0


:tests.test_default
call :tests.type expected.default > expected || exit /b
call :unittest "simple.bat" > result
fc /a /lb1 result expected > nul || (
    call %unittest% fail
)
exit /b 0

:tests.expected.default
::  start
::  run "simple","tests.test_success"
::  outcome "simple","tests.test_success",success,
::  run "simple","tests.test_skip"
::  outcome "simple","tests.test_skip",skip,"Not ready"
::  run "simple","tests.test_fail"
::  outcome "simple","tests.test_fail",fail,"1 + 1 is not 3"
::  run "simple","tests.test_error"
::  outcome "simple","tests.test_error",error,"Something unexpected happen"
::  stop
exit /b 0


:tests.test_failfast
call :tests.type expected.failfast > expected || exit /b
call :unittest "simple.bat" -f > result
fc /a /lb1 result expected > nul || (
    call %unittest% fail
)
exit /b 0

:tests.expected.failfast
::  start
::  run "simple","tests.test_success"
::  outcome "simple","tests.test_success",success,
::  run "simple","tests.test_skip"
::  outcome "simple","tests.test_skip",skip,"Not ready"
::  run "simple","tests.test_fail"
::  outcome "simple","tests.test_fail",fail,"1 + 1 is not 3"
::  stop
exit /b 0


:tests.test_pattern
call :tests.type expected.pattern > expected || exit /b
call :unittest "simple.bat" -p "test*.test_s*" > result
fc /a /lb1 result expected > nul || (
    call %unittest% fail
)
exit /b 0

:tests.expected.pattern
::  start
::  run "simple","tests.test_success"
::  outcome "simple","tests.test_success",success,
::  run "simple","tests.test_skip"
::  outcome "simple","tests.test_skip",skip,"Not ready"
::  stop
exit /b 0


:tests.test_wildcard_target
type "success.bat" > "dummy.bat" || exit /b
type "success.bat" > "dummy2.bat" || exit /b
call :tests.type expected.wildcard_target > expected || exit /b
call :unittest "dummy*.bat" > result
fc /a /lb1 result expected > nul || (
    call %unittest% fail
)
exit /b 0

:tests.expected.wildcard_target
::  start
::  run "dummy","tests.test_success_only"
::  outcome "dummy","tests.test_success_only",success,
::  run "dummy2","tests.test_success_only"
::  outcome "dummy2","tests.test_success_only",success,
::  stop
exit /b 0


:tests.test_target_args
> "dummy.bat" (
    call :tests.type template.target_args_ep || exit /b
    call :tests.type template.simple || exit /b
)
call :tests.type expected.target_args > expected || exit /b
call :unittest "dummy.bat" -a "--call" > result
fc /a /lb1 result expected > nul || (
    call %unittest% fail
)
exit /b 0

:tests.template.target_args_ep
::  if not ^"%1^" == "--call" (
::      echo mark missing_argument
::      exit /b 2
::  )
::  call :%*
::  exit /b
::
::  :--call
::  call %*
::  exit /b
::
exit /b 0

:tests.expected.target_args
::  start
::  run "dummy","tests.test_success"
::  outcome "dummy","tests.test_success",success,
::  run "dummy","tests.test_skip"
::  outcome "dummy","tests.test_skip",skip,"Not ready"
::  run "dummy","tests.test_fail"
::  outcome "dummy","tests.test_fail",fail,"1 + 1 is not 3"
::  run "dummy","tests.test_error"
::  outcome "dummy","tests.test_error",error,"Something unexpected happen"
::  stop
exit /b 0


:tests.test_setup_teardown
> "dummy.bat" (
    call :tests.type template.normal_entry_point || exit /b
    call :tests.type template.setup_teardown || exit /b
)
copy /b /y /v "dummy.bat" "dummy2.bat" > nul || exit /b
call :tests.type expected.setup_teardown > expected || exit /b
call :unittest "dummy*.bat" > result
fc /a /lb1 result expected > nul || (
    call %unittest% fail
)
exit /b 0

:tests.template.setup_teardown
::  :tests.setup
::  echo mark setup
::  set "hello=hi"
::  exit /b 0
::
::  :tests.teardown
::  echo mark teardown
::  exit /b 0
::
::  :tests.test_setup_var
::  if not "!hello!" == "hi" call %unittest% fail
::  exit /b 0
exit /b 0

:tests.expected.setup_teardown
::  start
::  mark setup
::  run "dummy","tests.test_setup_var"
::  outcome "dummy","tests.test_setup_var",success,
::  mark teardown
::  mark setup
::  run "dummy2","tests.test_setup_var"
::  outcome "dummy2","tests.test_setup_var",success,
::  mark teardown
::  stop
exit /b 0


:tests.test_pass_no_args
> "dummy.bat" (
    call :tests.type template.normal_entry_point || exit /b
    call :tests.type template.pass_no_args || exit /b
)
call :tests.type expected.pass_no_args > expected || exit /b
call :unittest "dummy.bat" > result
fc /a /lb1 result expected > nul || (
    call %unittest% fail
)
exit /b 0

:tests.template.pass_no_args
::  :tests.setup
::  :tests.teardown
::  exit /b 0
::
::  :tests.test_pass_no_args
::  if not ^"%1^" == "" echo mark fail
::  exit /b 0
exit /b 0

:tests.expected.pass_no_args
::  start
::  run "dummy","tests.test_pass_no_args"
::  outcome "dummy","tests.test_pass_no_args",success,
::  stop
exit /b 0


:tests.test_isolate
> "dummy.bat" (
    call :tests.type template.normal_entry_point || exit /b
    call :tests.type template.isolate || exit /b
)
call :tests.type expected.isolate > expected || exit /b
call :unittest "dummy.bat" > result
fc /a /lb1 result expected > nul || (
    call %unittest% fail
)
exit /b 0

:tests.template.isolate
::  call %*
::  exit /b
::
::  :tests.setup
::  set "hello="
::  exit /b 0
::
::  :tests.teardown
::  exit /b 0
::
::  :tests.test_set_var
::  set "hello=hi"
::  exit /b 0
::
::  :tests.test_no_var
::  if defined hello call %unittest% fail
::  exit /b 0
exit /b 0

:tests.expected.isolate
::  start
::  run "dummy","tests.test_set_var"
::  outcome "dummy","tests.test_set_var",success,
::  run "dummy","tests.test_no_var"
::  outcome "dummy","tests.test_no_var",success,
::  stop
exit /b 0


:tests.test_setup_skip
> "dummy.bat" (
    call :tests.type template.normal_entry_point || exit /b
    call :tests.type template.setup_skip || exit /b
)
call :tests.type expected.setup_skip > expected || exit /b
call :unittest "dummy.bat" > result
fc /a /lb1 result expected > nul || (
    call %unittest% fail
)
exit /b 0

:tests.template.setup_skip
::  :tests.setup
::  call %unittest% skip "Not ready"
::  exit /b 0
::
::  :tests.teardown
::  exit /b 0
::
::  :tests.test_success
::  echo mark success
::  exit /b 0
::
::  :tests.test_success2
::  echo mark success2
::  exit /b 0
exit /b 0

:tests.expected.setup_skip
::  start
::  run "dummy","tests.test_success"
::  outcome "dummy","tests.test_success",skip,"Not ready"
::  run "dummy","tests.test_success2"
::  outcome "dummy","tests.test_success2",skip,"Not ready"
::  stop
exit /b 0


:tests.test_setup_error
> "dummy.bat" (
    call :tests.type template.normal_entry_point || exit /b
    call :tests.type template.setup_error || exit /b
)
call :tests.type expected.setup_error > expected || exit /b
call :unittest "dummy.bat" %STDERR_REDIRECTION% > result
fc /a /lb1 result expected > nul || (
    call %unittest% fail
)
exit /b 0

:tests.template.setup_error
::  :tests.teardown
::  exit /b 0
::
::  :tests.test_success
::  echo mark success
::  exit /b 0
::
::  :tests.test_skip
::  call %unittest% skip "Not ready"
::  exit /b 0
exit /b 0

:tests.expected.setup_error
::  start
::  run "dummy","tests.test_success"
::  outcome "dummy","tests.test_success",error,"Test setup did not exit correctly [exit code 1]."
::  run "dummy","tests.test_skip"
::  outcome "dummy","tests.test_skip",error,"Test setup did not exit correctly [exit code 1]."
::  stop
exit /b 0


:tests.test_output_format
call :tests.type expected.output_format > expected || exit /b
set add_hashtag=echo "#"
call :unittest "success.bat" --output "custom:add_hashtag" > result
fc /a /lb1 result expected > nul || (
    call %unittest% fail
)
exit /b 0

:tests.expected.output_format
::  "#" start
::  "#" run "success","tests.test_success_only"
::  "#" outcome "success","tests.test_success_only",success,
::  "#" stop
exit /b 0


:tests.type <name>
call :functions_range _range "%~f0" tests.%~1 || exit /b
call :readline "%~f0" !_range! 1:-1 4
exit /b


:tests.self_run <label> [args]
echo self run
call %*
exit /b


:EOF
exit /b
