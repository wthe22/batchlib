:entry_point > nul 2> nul
call %*
exit /b


:unittest [-f] [-p pattern] [-a target_args] [-s self_args] [-o output_macro] [target]
setlocal EnableDelayedExpansion EnableExtensions
for %%v in (target fail_fast pattern argument output_macro) do set "unittest.%%v="
set "unittest.target=%~f0"
set "unittest.pattern=test*.test*"
set "unittest.target_args=-c"
set "unittest.self_args=-c"
set "unittest.default_output_macro=echo"
set "unittest.output_macro=unittest.default_output_macro"
call :argparse ^
    ^ "[]1:store                :unittest.target" ^
    ^ "f/failfast:store_const   :unittest.fail_fast=true" ^
    ^ "p/pattern:store          :unittest.pattern" ^
    ^ "a/target-args:store      :unittest.target_args" ^
    ^ "s/self-args:store        :unittest.self_args" ^
    ^ "o/output:store           :unittest.output_macro" ^
    ^ -- %* || exit /b 3
call :unittest._setup || (
    1>&2 echo%0: failed to setup tmp dir
    exit /b 4
)
call :unittest._load_tests || (
    1>&2 echo%0: failed to load tests
    exit /b 4
)
%unittest.output% start
call :unittest._run
%unittest.output% stop
call :unittest._cleanup
if defined unittest._failed exit /b 2
exit /b 0
#+++

:unittest._setup
set "unittest.start_dir=!cd!"
cd /d "!tmp_dir!" 2> nul || cd /d "!tmp!"
for %%f in ("unittest") do set "unittest.tmp_dir=%%~ff"
md "!unittest.tmp_dir!"
cd /d "!unittest.tmp_dir!" || exit /b 1
set "tmp_dir=!unittest.tmp_dir!"
for %%v in ("!unittest.output_macro!") do set "unittest.output=!%%~v!"
exit /b 0
#+++

:unittest._load_tests
set "unittest.top_dir="
pushd "!unittest.start_dir!"
> "!unittest.tmp_dir!\.unittest_test_cases" (
    for %%f in ("!unittest.target!") do (
        if not defined unittest.top_dir set "unittest.top_dir=%%~dpf"
        call :functions.match _labels "%%~ff" "!unittest.pattern!"
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
set unittest="%~f0" !unittest.self_args! :unittest.outcome %=REQUIRED=%
set "unittest._failed="
set "unittest._test_file="
setlocal EnableDelayedExpansion
for /f "usebackq tokens=1-2 delims=:" %%k in ("%unittest.tmp_dir%\.unittest_test_cases") do (
    if not "%%k" == "!unittest._test_file!" (
        if defined unittest._test_file (
            call "%unittest.top_dir%\!unittest._test_file!" %unittest.target_args% :tests.teardown
            endlocal
        )
        setlocal EnableDelayedExpansion
        call "%unittest.top_dir%\%%k" %unittest.target_args% :tests.setup
    )
    set "unittest._test_file=%%k"
    set "unittest._test_label=%%l"
    set "unittest._outcome="
    %unittest.output% run "!unittest._test_file!:!unittest._test_label!"
    setlocal EnableDelayedExpansion EnableExtensions
    call "%unittest.top_dir%\!unittest._test_file!" %unittest.target_args% :!unittest._test_label!
    for %%e in (!errorlevel!) do (
        if "%%e" == "0" (
            if not defined unittest._outcome call :unittest.outcome success
        ) else call :unittest.outcome error "Test function did not exit correctly [exit code %%e]."
    )
    if defined unittest.fail_fast if defined unittest._failed (
        %unittest.output% fail_fast
        exit /b 0
    )
    endlocal
)
if defined unittest._test_file (
    call "%unittest.top_dir%\!unittest._test_file!" %unittest.target_args% :tests.teardown
)
exit /b 0
#+++

:unittest.outcome <outcome> [message]
if "%~1" == "should_stop" (
    %unittest.output% should_stop
    exit /b 0
)
set "unittest._outcome=%~1"
for %%e in (fail error) do if "%~1" == "%%e" (
    set "unittest._failed=true"
)
%unittest.output% outcome "!unittest._test_file!:!unittest._test_label!",%1,%2
exit /b 0


:lib.build_system [return_prefix]
set "%~1install_requires=argparse functions.match"
set "%~1extra_requires=functions.range readline"
set "%~1category=devtools"
exit /b 0


:doc.man
::  NAME
::      unittest - unit testing framework
::
::  SYNOPSIS
::      unittest [-f] [-p pattern] [-a target_args] [-s self_args]
::               [-o output_macro] [target]
::      unittest.outcome <outcome> [message]
::      %unittest% <outcome> [message]
::
::  DESCRIPTION
::      unittest() is a unit testing framework for batch script. It search for
::      labels that match the pattern in the script and run the tests.
::
::      In unittest(), test cases that is successful is indicated by not having
::      outcome of fail/error/skip and return exit code 0.
::
::      If an important test failed and continuing is pointless, run
::      'call %unittest% should_stop' to stop the test early.
::
::      Unittests can be initialized by adding tests.setup(). It will be called
::      first before running any tests in each file. Cleanup function can also
::      be run after running all tests by implementing tests.teardown().
::
::  POSITIONAL ARGUMENTS
::      target
::          Path/pattern to the script(s) to be tested. By default, it is the
::          current script
::
::      outcome
::          Outcome of the test. Valid values are: fail, error, skip, should_stop
::
::  OPTIONS
::      -v, --verbose
::          Show more results of the tests
::
::      -f, --failfast
::          Stop on first fail or error
::
::      -p LABEL_PATTERN, --pattern LABEL_PATTERN
::          Pattern to match in tests labels ('test*.test*' default).
::
::      -a TARGET_ARGS, --target-args TARGET_ARGS
::          Arguments to add to call the test file. For example, you use
::          'target_script.bat --call :tests.test_me' to call 'tests.test_me',
::          so the TARGET_ARGS is '--call'. By default, it is '-c'.
::
::      -s SELF_ARGS, --self-args SELF_ARGS
::          Arguments to add to call the unittest functions. For example, if you
::          use 'unittest.bat --call :unittest.outcome' to report outcome in your
::          unittests, so the SELF_ARGS is '--call'. By default it is '-c'.
::
::      -o OUTPUT_MACRO, --output OUTPUT_MACRO
::          Pass output results, in the form of arguments, to COMMAND stored in
::          the OUTPUT_MACRO. The default COMMAND is 'echo'.
::
::  OUTPUTS
::      start
::          Preparation is done and unittest is about to start
::
::      run <file:label>
::          Unittest is running tests in the following file and label
::
::      outcome <file:label>,<success|fail|error|skip>,<message>
::          Report outcome of the test as either: success, fail, error, or skip,
::          with the following message/reason
::
::      fail_fast
::          Unittest is stopped due to first fail or error
::
::      should_stop
::          A test case raised signal to stop test early
::
::      stop
::          Unittest have stopped gracefully
::
::  ENVIRONMENT
::      tmp_dir
::          Path to store the temporary test results.
::
::      tmp
::          Fallback path for tmp_dir if tmp_dir does not exist
::
::  EXIT STATUS
::      0:  - Unittest passed.
::      1:  - An unexpected error occured.
::      2:  - Unittest failed
::      3:  - Invalid parameters.
::      4:  - Cannot do necessary setups
::
::  NOTES
::      - The variable name 'unittest' and variable names that starts with
::        'unittest.*' are reserved.
::      - Using reserved variables in your tests might cause unexpected behavior.
exit /b 0


:doc.demo
cd /d "!tmp_dir!" 2> nul || cd /d "!tmp!"
call :tests.type template.simple > "simple.bat"
call :unittest "simple.bat" -a "" -s ""
exit /b 0


:tests.setup
call :tests.type template.simple > "simple.bat"
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
::  call %unittest% skip "not ready"
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


:tests.test_no_opts
call :tests.type expected.no_opts > expected || exit /b
call :unittest "simple.bat" -a "" -s "" > result
fc /a /lb1 result expected > nul || (
    call %unittest% fail
)
exit /b 0

:tests.expected.no_opts
::  start
::  run "simple:tests.test_success"
::  outcome "simple:tests.test_success",success,
::  run "simple:tests.test_skip"
::  outcome "simple:tests.test_skip",skip,"not ready"
::  run "simple:tests.test_fail"
::  outcome "simple:tests.test_fail",fail,"1 + 1 is not 3"
::  run "simple:tests.test_error"
::  outcome "simple:tests.test_error",error,"Something unexpected happen"
::  stop
exit /b 0


:tests.test_failfast
call :tests.type expected.failfast > expected || exit /b
call :unittest "simple.bat" -f -a "" -s "" > result
fc /a /lb1 result expected > nul || (
    call %unittest% fail
)
exit /b 0

:tests.expected.failfast
::  start
::  run "simple:tests.test_success"
::  outcome "simple:tests.test_success",success,
::  run "simple:tests.test_skip"
::  outcome "simple:tests.test_skip",skip,"not ready"
::  run "simple:tests.test_fail"
::  outcome "simple:tests.test_fail",fail,"1 + 1 is not 3"
::  fail_fast
::  stop
exit /b 0


:tests.test_pattern
call :tests.type expected.pattern > expected || exit /b
call :unittest "simple.bat" -p "tests.test_s*" -a "" -s "" > result
fc /a /lb1 result expected > nul || (
    call %unittest% fail
)
exit /b 0

:tests.expected.pattern
::  start
::  run "simple:tests.test_success"
::  outcome "simple:tests.test_success",success,
::  run "simple:tests.test_skip"
::  outcome "simple:tests.test_skip",skip,"not ready"
::  stop
exit /b 0


:tests.test_wildcard_target
call :tests.type template.success > "dummy.bat" || exit /b
copy /b /y /v "dummy.bat" "dummy2.bat" > nul || exit /b
call :tests.type expected.wildcard_target > expected || exit /b
call :unittest "dummy*.bat" -a "" -s "" > result
fc /a /lb1 result expected > nul || (
    call %unittest% fail
)
exit /b 0

:tests.template.success
::  call :%*
::  exit /b
::
::  :tests.setup
::  :tests.teardown
::  exit /b 0
::
::  :tests.test_success_only
::  exit /b 0
exit /b 0

:tests.expected.wildcard_target
::  start
::  run "dummy:tests.test_success_only"
::  outcome "dummy:tests.test_success_only",success,
::  run "dummy2:tests.test_success_only"
::  outcome "dummy2:tests.test_success_only",success,
::  stop
exit /b 0


:tests.test_target_args
call :tests.type template.target_args > "dummy.bat" || exit /b
call :tests.type expected.target_args > expected || exit /b
call :unittest "dummy.bat" -s "" > result
fc /a /lb1 result expected > nul || (
    call %unittest% fail
)
exit /b 0

:tests.template.target_args
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
::  :tests.setup
::  :tests.teardown
::  exit /b 0
::
::  :tests.test_success
::  echo mark success
::  exit /b 0
::
::  :tests.test_skip
::  call %unittest% skip "not ready"
::  exit /b 0
exit /b 0

:tests.expected.target_args
::  start
::  run "dummy:tests.test_success"
::  mark success
::  outcome "dummy:tests.test_success",success,
::  run "dummy:tests.test_skip"
::  outcome "dummy:tests.test_skip",skip,"not ready"
::  stop
exit /b 0


:tests.test_setup_teardown
call :tests.type template.setup_teardown > "dummy.bat" || exit /b
copy /b /y /v "dummy.bat" "dummy2.bat" > nul || exit /b
call :tests.type expected.setup_teardown > expected || exit /b
call :unittest "dummy*.bat" -a "" -s "" > result
fc /a /lb1 result expected > nul || (
    call %unittest% fail
)
exit /b 0

:tests.template.setup_teardown
::  call %*
::  exit /b
::
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
::  run "dummy:tests.test_setup_var"
::  outcome "dummy:tests.test_setup_var",success,
::  mark teardown
::  mark setup
::  run "dummy2:tests.test_setup_var"
::  outcome "dummy2:tests.test_setup_var",success,
::  mark teardown
::  stop
exit /b 0


:tests.test_pass_no_args
call :tests.type template.pass_no_args > "dummy.bat" || exit /b
call :tests.type expected.pass_no_args > expected || exit /b
call :unittest "dummy.bat" -a "" -s "" > result
fc /a /lb1 result expected > nul || (
    call %unittest% fail
)
exit /b 0

:tests.template.pass_no_args
::  call %*
::  exit /b
::
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
::  run "dummy:tests.test_pass_no_args"
::  outcome "dummy:tests.test_pass_no_args",success,
::  stop
exit /b 0


:tests.test_isolate
call :tests.type template.isolate > "dummy.bat" || exit /b
call :tests.type expected.isolate > expected || exit /b
call :unittest "dummy.bat" -a "" -s "" > result
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
::  run "dummy:tests.test_set_var"
::  outcome "dummy:tests.test_set_var",success,
::  run "dummy:tests.test_no_var"
::  outcome "dummy:tests.test_no_var",success,
::  stop
exit /b 0


:tests.test_should_stop
call :tests.type template.should_stop > "dummy.bat" || exit /b
call :tests.type expected.should_stop > expected || exit /b
call :unittest "dummy.bat" -a "" -s "" > result
fc /a /lb1 result expected > nul || (
    call %unittest% fail
)
exit /b 0

:tests.template.should_stop
::  call %*
::  exit /b
::
::  :tests.setup
::  :tests.teardown
::  exit /b 0
::
::  :tests.test_should_stop
::  call %unittest% should_stop
::  exit /b 0
exit /b 0

:tests.expected.should_stop
::  start
::  run "dummy:tests.test_should_stop"
::  should_stop
::  outcome "dummy:tests.test_should_stop",success,
::  stop
exit /b 0


:tests.type <name>
call :functions.range _range "%~f0" tests.%~1 || exit /b
call :readline "%~f0" !_range! 1:-1 4
exit /b


:tests.self_run <label> [args]
echo self run
call %*
exit /b


:EOF  # End of File
exit /b