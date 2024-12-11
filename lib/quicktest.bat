:entry_point
call %*
exit /b


:quicktest [label ...]
@setlocal EnableDelayedExpansion
@echo off
cd /d "!tmp_dir!" 2> nul || cd /d "!tmp!"
set "unittest=:quicktest.outcome "
if "%~1" == "" (
    set "unittest.test_cases= "
    for /f "delims= " %%t in ('robocopy /l . . /njh /njs') do set "TAB=%%t"
    for /f "usebackq tokens=1 delims=: " %%a in (
        `findstr /r /c:"^^[!TAB! @]*:test.*\.test.*" "%~f0"`
    ) do set "unittest.test_cases=!unittest.test_cases!%%a "
) else set "unittest.test_cases=%~1"
set "unittest._outcome="
call :tests.setup || (
    call :quicktest.outcome error ^
        ^ "Test setup did not exit correctly [exit code !errorlevel!]."
)
set "unittest.test_count=0"
if not defined unittest._outcome call :quicktest._run
call :tests.teardown
echo=
echo ----------------------------------------------------------------------
echo Ran !unittest.test_count! tests
exit /b 0
#+++

:quicktest._run
for %%t in (%unittest.test_cases%) do (
    set /a "unittest.test_count+=1"
    echo !time! [!unittest.test_count!] %%t
    setlocal
    call :%%t
    endlocal
)
exit /b 0
#+++

:quicktest.outcome <outcome> [message]
set "unittest._outcome=%~1"
(
    goto 2> nul
    1>&2 call echo%%0: %~1: %2
    ( call )
)
exit /b 1


:lib.dependencies [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=coderender functions_range readline functions_match"
set "%~1category=devtools"
exit /b 0


:doc.man
::  NAME
::      quicktest - tiny unittest framework
::
::  SYNOPSIS
::      quicktest [label ...]
::      call %unittest% <outcome> [message]
::
::  DESCRIPTION
::      A tiny unittest framework made from the urgent need of testing. No fancy
::      features, at least it gets the job done. It is compatible with unittest().
::      It has no dependencies and is much smaller than unittest().
::
::  POSITIONAL ARGUMENTS
::      label
::          List of labels to be tested. If this is empty, any label that matches
::          'test*.test*' is used.
::
::  UNITTEST USAGE
::      tests.setup()
::          A function called before tests in a file is run. Use skip/fail/error
::          here to mark all tests at once. If function is not callable, this
::          will be considered an error.
::
::      tests.teardown()
::          A function called after tests in a file is run. This is called even
::          if all tests or tests.setup() fails.
::
::      Failure/Error/Skip
::              call %unittest% (fail|error|skip) <message>
::
::          Signals a test as failure/error/skip. Use case for each outcome:
::          - Fail: Function did not give the expected results.
::          - Error: Cannot run test due to errors or unexpected problems.
::          - Skip: Cannot run test due to missing tools.
exit /b 0


:doc.demo
cd /d "!tmp_dir!" 2> nul || cd /d "!tmp!"
call :coderender "%~f0" "tests.template.simple" > "simple.bat"
cmd /c "simple.bat"
exit /b 0


:tests.setup
set "STDERR_REDIRECTION=2> nul"
exit /b 0


:tests.teardown
exit /b 0


:tests.test_detect_label
call :tests.type_script template.detect_label > "dummy.bat" || exit /b
call 2> outcome
call :functions_match expected "dummy.bat" "test*.test*"
call "dummy.bat" > nul
for /f "usebackq tokens=*" %%o in ("outcome") do (
    call %unittest% %%o
)
exit /b 0

:tests.template.detect_label
::  :tests.setup
::  call :check_label > outcome
::  exit /b 0
::
::  :tests.teardown
::  exit /b 0
::
::  :check_label
::  set "test_cases=!unittest.test_cases!"
::  for %%l in (!expected!) do (
::      if "!test_cases: %%l = !" == "!test_cases!" (
::          echo fail "Label '%%l' not found"
::      ) else set "test_cases=!test_cases: %%l = !"
::  )
::  if not "!test_cases!" == " " (
::      echo fail "Labels should not contain: !test_cases!"
::  )
::  exit /b 0
::
::  :tests.test_simple
::  :tests.me.test_hello
::  exit /b 0
exit /b 0


:tests.test_setup_skip
call :tests.type_script template.setup_skip > "dummy.bat" || exit /b
call 2> outcome
call "dummy.bat" %STDERR_REDIRECTION% > nul
set "fail="
set /p "fail=" < "outcome"
if defined fail (
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
::  :tests.test_not_called
::  echo fail > outcome
::  exit /b 0
exit /b 0


:tests.test_output_stdout
call :tests.type_script template.simple > "dummy.bat" || exit /b
call :tests.type_content expected.output_stdout > "expected" || exit /b
call "dummy.bat" 2> nul > "result-raw"
> "result" (
    for /f "usebackq tokens=* delims=" %%a in ("result-raw") do (
        set "text=%%a"
        if "x!text:~2,1!x!text:~5,1!x!text:~8,1!x" == "x:x:x.x" (
            set "text=!text:~12!"
        )
        echo !text!
    )
)
fc /a /lb1 result expected > nul || (
    call %unittest% fail
)
exit /b 0

:tests.expected.output_stdout
::  [1] tests.test_success
::  [2] tests.test_skip
::  [3] tests.test_fail
::  [4] tests.test_error
::  ----------------------------------------------------------------------
::  Ran 4 tests
exit /b 0


:tests.test_output_stderr
call :tests.type_script template.simple > "dummy.bat" || exit /b
call :tests.type_content expected.output_stderr > "expected" || exit /b
call "dummy.bat" > nul 2> "result"
fc /a /lb1 result expected > nul || (
    call %unittest% fail
)
exit /b 0

:tests.expected.output_stderr
::  tests.test_skip: skip: "Not ready"
::  tests.test_fail: fail: "1 + 1 is not 3"
::  tests.test_error: error: "Something unexpected happen"
exit /b 0


:tests.test_setup_error
call :tests.type_script template.setup_error > "dummy.bat" || exit /b
call :tests.type_content expected.setup_error > "expected" || exit /b
call "dummy.bat" > nul 2> "result"
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
::  The system cannot find the batch label specified - tests.setup
::  quicktest: error: "Test setup did not exit correctly [exit code 1]."
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

:tests.type_script <name>
echo call :quicktest %%*
echo exit /b
echo=
call :functions_range _range "%~f0" quicktest || exit /b
call :readline "%~f0" !_range!
echo=
echo=
call :functions_range _range "%~f0" tests.%~1 || exit /b
call :readline "%~f0" !_range! 1:-1 4
exit /b


:tests.type_content <name>
call :functions_range _range "%~f0" tests.%~1 || exit /b
call :readline "%~f0" !_range! 1:-1 4
exit /b


:EOF
exit /b
