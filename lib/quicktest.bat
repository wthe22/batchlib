:entry_point > nul 2> nul
call %*
exit /b


:quicktest <label [...]>
@setlocal EnableDelayedExpansion
@echo off
cd /d "!tmp_dir!" 2> nul || cd /d "!tmp!"
set "unittest=:quicktest.outcome "
if ^"%1^" == "" (
    for /f "usebackq tokens=1 delims=: " %%a in (
        `findstr /r /c:"^[ ]*:tests\.test_[^: ]" "%~f0"`
    ) do set "quicktest.test_cases=!quicktest.test_cases! %%a"
) else set "quicktest.test_cases=%~1"
call :tests.setup
set "quicktest.test_count=0"
for %%t in (%quicktest.test_cases%) do (
    set /a "quicktest.test_count+=1"
    echo !time! [!quicktest.test_count!] %%t
    setlocal
    call :%%t
    endlocal
)
call :tests.teardown
echo=
echo ----------------------------------------------------------------------
echo Ran !quicktest.test_count! tests
exit /b 0
#+++

:quicktest.outcome
goto 2> nul & (
    1>&2 call echo%%0: %~1: %~2
    ( call )
)
exit /b 1


:lib.build_system [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=coderender functions.range readline"
set "%~1category=devtools"
exit /b 0


:doc.man
::  NAME
::      quicktest - tiny unittest framework
::
::  SYNOPSIS
::      quicktest <label [...]>
::
::  DESCRIPTION
::      A tiny unittest framework made in 10 minutes.
::      To be continued...
exit /b 0


:doc.demo
cd /d "!tmp_dir!" 2> nul || cd /d "!tmp!"
call :coderender "%~f0" "tests.template.simple" > "simple.bat"
cmd /c "simple.bat"
exit /b 0


:tests.setup
:tests.teardown
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
call :functions.range _range "%~f0" tests.%~1 || exit /b
call :readline "%~f0" !_range! 1:-1 4
exit /b


:EOF  # End of File
exit /b
