:entry_point
call %*
exit /b


:metadata [return_prefix]
set "%~1dependencies= "
set "%~1dev_dependencies="
set "%~1categories=extension"
exit /b 0


:unset_all [variable_prefix] ...
for %%p in (%*) do (
    for /f "usebackq tokens=1 delims==" %%v in (`set "%%~p" 2^> nul`) do (
        set "%%v="
    )
)
exit /b 0


:doc.man
::  NAME
::      unset_all - unset all variable that starts with the prefix
::
::  SYNOPSIS
::      unset_all [variable_prefix] ...
::
::  POSITIONAL ARGUMENTS
::      variable_prefix
::          The prefix of the variables to unset.
exit /b 0


:doc.demo
set "var_hello=x"
set "var_hi=x"
set "var_hey=x"

echo BEFORE
echo ======
set "var_"
echo=
echo Unset variable that starts with "var_he"
call :unset_all "var_he"
echo=
echo AFTER
echo =====
set "var_"
exit /b 0


:tests.setup
rem Called before running any tests here
exit /b 0


:tests.teardown
rem Called after running all tests here. Useful for cleanups.
exit /b 0


:tests.test_unset
set "var_hello=x"
set "var_hi=x"
set "var_hey=x"
call :unset_all "var_he"
for %%v in (hello hey) do (
    if defined var_%%v (
        call %unittest% fail "Variable still defined: %%v"
    )
)
for %%v in (hi) do (
    if not defined var_%%v (
        call %unittest% fail "Incorrect variable unset: %%v"
    )
)
exit /b 0


:EOF
@rem DO NOT WRITE ANYTHING YOU NEED TO KEEP BELOW THIS FUNCTION.
@rem ANYTHING BEYOND THIS FUNCTION WILL BE REMOVED WHEN ADDING DEPENDENCIES.
exit /b
