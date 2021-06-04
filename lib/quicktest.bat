:entry_point > nul 2> nul
call %*
exit /b


:quicktest <label [...]>
@setlocal EnableDelayedExpansion
@echo off
cd /d "!tmp_dir!" 2> nul || cd /d "!tmp!"
set "unittest=:quicktest.outcome "
if ^"%1^" == "" (
    set "unittest.test_cases= "
    for /f "delims= " %%t in ('robocopy /l . . /njh /njs') do set "TAB=%%t"
    for /f "usebackq tokens=1 delims=: " %%a in (
        `findstr /r /c:"^^[!TAB! @]*:test.*\.test.*" "%~f0"`
    ) do set "unittest.test_cases=!unittest.test_cases!%%a "
) else set "unittest.test_cases=%~1"
set "unittest._outcome="
call :tests.setup
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

:quicktest.outcome
set "unittest._outcome=%~1"
goto 2> nul & (
    1>&2 call echo%%0: %~1: %~2
    ( call )
)
exit /b 1


:lib.build_system [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=coderender functions.range readline functions.match"
set "%~1category=devtools"
exit /b 0


:doc.man
::  NAME
::      quicktest - tiny unittest framework
::
::  SYNOPSIS
::      quicktest <label [...]>
::      call %unittest% <outcome> [message]
::
::  DESCRIPTION
::      A tiny unittest framework made from the urgent need of testing. No fancy
::      features, at least it gets the job done. It is compatible with unittest().
::      It has no dependencies and is much smaller than unittest().
::
::  POSITIONAL ARGUMENTS
::      label
::          List of labels to be tested. If the label is not specified,
::          any label that matches 'test*.test*' is used.
::
::  UNITTEST USAGE
::      Test File
::          Each test file should contain tests.setup(), tests.teardown(), and at
::          least 1 test case to run unittest.
::
::      tests.setup()
::          A function called before tests in a file is run. A skip/fail/error
::          signal will abort unittest.
::
::      tests.teardown()
::          A function called after tests in a file is run. This is called even
::          if all tests or tests.setup() fails.
::
::      Failure/Error/Skip
::              call %unittest% (fail|error|skip) <message>
::
::          Signals a test as failure/error/skip. Use case for each outcome:
::          - Fail: Function did not give the expected result.
::          - Error: Test case fails to run or unexpected error occur.
::          - Skip: Functionality cannot be tested yet (WIP), so we skip first.
exit /b 0


:doc.demo
cd /d "!tmp_dir!" 2> nul || cd /d "!tmp!"
call :coderender "%~f0" "tests.template.simple" > "simple.bat"
cmd /c "simple.bat"
exit /b 0


:tests.setup
set "STDERR_REDIRECTION=2> nul"
set "quicktest_debug="
if "!unittest!" == ":quicktest.outcome " set "quicktest_debug=true"
if defined quicktest_debug (
    set "unittest=echo test outcome:"
)
exit /b 0


:tests.teardown
exit /b 0


:tests.test_detect_label
call :tests.type template.detect_label > "dummy.bat" || exit /b
call 2> outcome
call :functions.match expected "dummy.bat" "test*.test*"
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
call :tests.type template.setup_skip > "dummy.bat" || exit /b
call 2> outcome
call "dummy.bat" %STDERR_REDIRECTION% > nul
for /f "usebackq tokens=*" %%o in ("outcome") do (
    call %unittest% %%o
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


:tests.template.simple
::  @setlocal EnableDelayedExpansion EnableExtensions
::  @echo off
::  call :quicktest
::  exit /b
::
::
call :functions.range _range "%~f0" "quicktest" || exit /b 2
call :readline "%~f0" !_range!
::
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
call :functions.range _range "%~f0" quicktest || exit /b
call :readline "%~f0" !_range!
echo=
echo=
call :functions.range _range "%~f0" tests.%~1 || exit /b
call :readline "%~f0" !_range! 1:-1 4
exit /b


:EOF  # End of File
exit /b
