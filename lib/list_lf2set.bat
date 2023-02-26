:entry_point
call %*
exit /b


:list_lf2set <return_var> <input_var>
setlocal EnableDelayedExpansion
set "_return_var=%~1"
set "_input_var=%~2"
call :capchar LF
set "_result="
for /f "tokens=* delims=" %%a in ("!%_input_var%!") do (
    set "_is_listed="
    for /f "tokens=* delims=" %%b in ("!_result!") do (
        if not defined _is_listed (
            if "%%a" == "%%b" set "_is_listed=true"
        )
    )
    if not defined _is_listed set "_result=!_result!%%a!LF!"
)
if defined _result (
    set "%_return_var%="
    for /f "tokens=* delims=" %%r in ("!_result!") do (
        if not defined %_return_var% (
            endlocal
            set "%_return_var%="
        )
        set "%_return_var%=!%_return_var%!%%r!LF!"
    )
) else (
    endlocal
    set "%_return_var%="
)
exit /b 0


:lib.dependencies [return_prefix]
set "%~1install_requires=capchar"
set "%~1extra_requires=input_string"
set "%~1category=string"
exit /b 0


:doc.man
::  NAME
::      list_lf2set - remove duplicate items in a list, seperated by LF
::
::  SYNOPSIS
::      list2set <return_var> <input_var>
::
::  POSITIONAL ARGUMENTS
::      input_var
::          The input variable name.
exit /b 0


:doc.demo
call :capchar LF NL
call :input_string list_with_duplicates || (
    set list_with_duplicates= sushi;noodle;salad;sushi;sushi;milk;SALAD
)
set list_with_duplicates=!list_with_duplicates:;=%NL%!
call :list_lf2set result list_with_duplicates
echo=
echo Original list:
echo !list_with_duplicates!
echo=
echo Converted set:
echo !result!
exit /b 0


:tests.setup
call :capchar LF
exit /b 0


:tests.teardown
exit /b 0


:tests.test_empty
set "input="
set "result=FAIL"
call :list_lf2set result input
set "expected="
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_basic
set "input=a!LF!a!LF!b!LF!c!LF!b!LF!cc!LF!ddd!LF!dd!LF!e"
call :list_lf2set result input
set "expected=a!LF!b!LF!c!LF!cc!LF!ddd!LF!dd!LF!e!LF!"
if not "!result!" == "!expected!" (
    call %unittest% fail
    echo Expected "!expected!", got "!result!"
)
exit /b 0


:tests.test_blank_line
set "input=a!LF!!LF!a!LF!b!LF!!LF!!LF!c!LF!b"
call :list_lf2set result input
set "expected=a!LF!b!LF!c!LF!"
if not "!result!" == "!expected!" (
    call %unittest% fail
    echo Expected "!expected!", got "!result!"
)
exit /b 0


:EOF
exit /b
