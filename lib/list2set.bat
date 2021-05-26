:entry_point > nul 2> nul
call %*
exit /b


:list2set <input_var [...]> [--not-null]
for %%l in (%~1) do (
    for /f "tokens=1* delims=?" %%b in ("Q?!%%l!") do (
        set "%%l= "
        for %%i in (%%c) do (
            set "%%l= %%i!%%l!"
        )
    )
    for /f "tokens=1* delims=?" %%b in ("Q?!%%l!") do (
        set "%%l= "
        for %%i in (%%c) do (
            set "%%l= %%i!%%l: %%i = !"
        )
    )
    if not "%2" == "--not-null" if "!%%l!" == " " set "%%l="
)
exit /b 0


:lib.build_system [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=Input.string"
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
::      - Special characters are not supported. Using it might result in
::        unexpected behaviors.
exit /b 0


:doc.demo
call :Input.string list_with_duplicates || (
    set list_with_duplicates= "hello" hello world? how are you *.bat
)
set "result=!list_with_duplicates!"
call :list2set "result"
echo=
echo Original list:
echo "!list_with_duplicates!"
echo=
echo Converted set:
echo "!result!"
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
        call %unittest% fail "given '%%~a', expected '!expected!', got '!result!'"
    )
)
exit /b 0


:EOF  # End of File
exit /b
