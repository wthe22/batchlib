:entry_point
call %*
exit /b


:list2set <input_var [...]> [--not-null]
for %%v in (%~1) do (
    setlocal EnableDelayedExpansion
    call :list2set._convert !%%v!
    for /f "tokens=* delims=" %%r in ("!_result!") do (
        endlocal
        set "%%v=%%r"
        if not "%2" == "--not-null" if "!%%v!" == " " set "%%v="
    )
)
exit /b 0
#+++

:list2set._convert
set "_result= "
for /l %%# in (1,1,64) do for /l %%# in (1,1,64) do (
    call set _item=%%1
    if not defined _item exit /b 0
    for /f "tokens=* delims=" %%i in ("!_item!") do (
        if "!_result: %%i = !" == "!_result!" (
            call set _result=!_result!%%1 %=END=%
        )
    )
    shift /1
)
exit /b 0


:lib.dependencies [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=input_string"
set "%~1category=string"
exit /b 0


:doc.man
::  NAME
::      list2set - remove duplicate items in a list
::
::  SYNOPSIS
::      list2set <input_var [...]> [--not-null]
::
::  POSITIONAL ARGUMENTS
::      input_var
::          The input variable name.
::
::  OPTIONS
::      --not-null
::          Do not set variable to null even if the list is empty.
::          This must be placed as the second argument.
::
::  NOTES
::      - Percent sign (%) and exclamation mark (!) might get stripped.
::      - Equal sign (=) and caret (^) might cause incorrect results.
::      - Quoted and unquoted are seen as different
exit /b 0


:doc.demo
call :input_string list_with_duplicates || (
    set list_with_duplicates= hello? hi =hello= *howdy* "hi" hello? *howdy*
)
set "result=!list_with_duplicates!"
call :list2set "result"
echo=
echo Original list:
echo !list_with_duplicates!
echo=
echo Converted set:
echo !result!
exit /b 0


:tests.setup
:tests.teardown
exit /b 0


:tests.test_all
set "basic.input=a a b c b cc ddd dd e "
set "basic.output= a b c cc ddd dd e "
set quoted.input=a "a" "b" " b " " b " c "c" c:"c"
set quoted.output= a "a" "b" " b " c "c" c:"c" %=END=%
set "spaces.input=        "
set "spaces.output="
set "undefined.input="
set "undefined.output="
set "spaces_not_null.input=        "
set "spaces_not_null.output= "
set "undefined_not_null.input="
set "undefined_not_null.output= "
for %%a in (
    "basic"
    "quoted"
    "spaces"
    "undefined"
    "spaces_not_null: --not-null"
    "undefined_not_null: --not-null"
) do for /f "tokens=1* delims=:" %%b in (%%a) do (
    set "result=!%%b.input!"
    call :list2set "result" %%c
    set "expected=!%%b.output!"
    if not "!result!" == "!expected!" (
        call %unittest% fail "Given '%%~a', expected '!expected!', got '!result!'"
    )
)
exit /b 0


:EOF
exit /b
