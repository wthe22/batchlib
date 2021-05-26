:entry_point > nul 2> nul
call %*
exit /b


:strlen <return_var> <input_var>
set "%~1=0"
if defined %~2 (
    for /l %%b in (12,-1,0) do (
        set /a "%~1+=(1<<%%b)"
        for %%i in (!%~1!) do if "!%~2:~%%i,1!" == "" set /a "%~1-=(1<<%%b)"
    )
    set /a "%~1+=1"
)
exit /b 0


:lib.build_system [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=Input.string"
set "%~1category=string"
exit /b 0


:doc.man
::  NAME
::      strlen - calculate length of a string
::
::  SYNOPSIS
::      strlen <return_var> <input_var>
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the result.
::
::      input_var
::          The input variable name.
::
::  NOTES
::      - strlen uses binary search for get the string length
::        so it is significantly fast.
exit /b 0


:doc.demo
call :Input.string string || (
    set "string=1"
    for /l %%i in (1,1,10) do (
        set /a "string*=9 * (!random! %% 2) + 1"
        set /a "string+=!random! %% 10"
    )
)
echo=
call :strlen length string
echo The length of '!string!' is !length! characters
exit /b 0


:tests.setup
:tests.teardown
exit /b 0


:tests.test_result
set "current_len="
set "var= "
for /l %%i in (1,1,12) do set "var=!var!!var!"
set "var=!var!!var:~0,4000!"
for %%l in (
    8000
    4097 4096 4095
    8 7 3 2
    1 0
) do (
    set "var=!var:~0,%%l!"
    call :strlen result var
    set "expected=%%l"
    if not "!result!" == "!expected!" (
        call %unittest% fail "expected '!expected!', got '!result!'"
    )
)
exit /b 0


:EOF  # End of File
exit /b
