:entry_point  # Beginning of file
call %*
exit /b


:normalize_spaces <input_var [...]> [--not-null]
for %%l in (%~1) do (
    set "%%l= !%%l! "
    for %%s in (
        "                     "
        "      "
        "   "
        "  "
        "  "
    ) do set "%%l=!%%l:%%~s= !"
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
::      normalize_spaces - normalize spaces in a variable to its compact form
::
::  SYNOPSIS
::      normalize_spaces <input_var [...]> [--not-null]
::
::  DESCRIPTION
::      Adds a single space to the beginning and the end of the string
::      and replace multiple spaces with a single space. Maximum number
::      of consecutive space that can be replaced to a single space is
::      459 spaces. By default, if the resulting variable only contains
::      one space, the variable is set to undefined/null.
::
::  POSITIONAL ARGUMENTS
::      input_var
::          The input variable name.
::
::  OPTIONS
::      --not-null
::          Do not set variable to null even if the result only contains
::          a single space. This must be placed as the second argument.
exit /b 0


:doc.demo
call :Input.string multi_space_text || (
    set "multi_space_text= hello     world,  how     are    you  ?"
)
set "result=!multi_space_text!"
call :normalize_spaces "result"
echo=
echo Original list:
echo "!multi_space_text!"
echo=
echo Normalized list:
echo "!result!"
exit /b 0


:tests.setup
:tests.teardown
exit /b 0


:tests.test_all
set "spaces="
set "start=1"
set "end=125"
for %%t in (front back) do (
    set "%%t="
    set "%%t.expected= "
)
for /l %%n in (1,1,!start!) do set "spaces=!spaces! "
for /l %%n in (!start!,1,!end!) do (
    set "front=!front!%%n!spaces!"
    set "front.expected=!front.expected!%%n "
    set "back=!spaces!%%n!back!"
    set "back.expected= %%n!back.expected!"
    set "spaces=!spaces! "
)
call :normalize_spaces "front back"
for %%t in (front back) do (
    if not "!%%t!" == "!%%t.expected!" (
        call %unittest% fail "Given '%%t', expected '!%%t.expected!', got '!%%t!'"
    )
)

set "spaces.input=        "
set "spaces.output="
set "undefined.input="
set "undefined.output="
set "spaces_not_null.input=        "
set "spaces_not_null.output= "
set "undefined_not_null.input="
set "undefined_not_null.output= "
for %%a in (
    "spaces"
    "undefined"
    "spaces_not_null: --not-null"
    "undefined_not_null: --not-null"
) do for /f "tokens=1* delims=:" %%b in (%%a) do (
    set "result=!%%b.input!"
    call :normalize_spaces "result" %%c
    set "expected=!%%b.output!"
    if not "!result!" == "!expected!" (
        call %unittest% fail "Given '%%~a', expected '!expected!', got '!result!'"
    )
)
exit /b 0


:EOF  # End of File
exit /b
