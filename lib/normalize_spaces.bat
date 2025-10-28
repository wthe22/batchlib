:entry_point
call %*
exit /b


:metadata [return_prefix]
set "%~1dependencies= "
set "%~1dev_dependencies=input_string"
set "%~1categories=string"
exit /b 0


:normalize_spaces <input_var ...> [--trim]
for %%l in (%~1) do (
    set "%%l=Q!%%l!"
    for %%s in (
        "                     "
        "      "
        "   "
        "  "
        "  "
    ) do set "%%l=!%%l:%%~s= !"
    set "%%l=!%%l:~1!"
    if "%2" == "--trim" (
		if "!%%l:~0,1!" == " " set "%%l=!%%l:~1!"
		if "!%%l:~-1,1!" == " " set "%%l=!%%l:~0,-1!"
	)
)
exit /b 0


:doc.man
::  NAME
::      normalize_spaces - normalize spaces in string
::
::  SYNOPSIS
::      normalize_spaces <input_var ...>
::
::  DESCRIPTION
::      Maximum number of consecutive space that can be replaced to a single space
::      is 459 spaces.
::
::  POSITIONAL ARGUMENTS
::      input_var
::          The input variable name.
::
::  OPTIONS
::      --trim
::          Trim leading and trailing spaces.
::
::	NOTES
::		- Only supports spaces (0x20), tabs (0x09) are not supported
exit /b 0


:doc.demo
call :input_string --optional multi_space_text || (
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
set "between="
set "between.expected="
for /l %%n in (0,1,125) do (
	set "between=!between!!spaces!%%n"
	set "between.expected=!between.expected!%%n "
    set "spaces=!spaces! "
)
set "between=!between!"
set "between.expected=!between.expected:~0,-1!"
set "trailing=x!spaces!"
set "trailing.expected=x "
set "leading=!spaces!x"
set "leading.expected= x"
call :normalize_spaces "leading between trailing"
for %%t in (trailing between leading) do (
    if not "!%%t!" == "!%%t.expected!" (
        call %unittest% fail "Given '%%t', expected '!%%t.expected!', got '!%%t!'"
    )
)

set "full=abc"
set "null="
set "spaces=        "
set "single_space= "
for %%s in (
    "full:full"
    "single_space:spaces"
    "single_space:single_space"
    "undefined:undefined"
    "undefined:spaces: --trim"
    "undefined:single_space: --trim"
    "undefined:undefined: --trim"
) do for /f "tokens=1-2* delims=:" %%a in (%%s) do (
    set "given=!%%b!"
    set "result=!%%b!"
    call :normalize_spaces "result" %%c
    set "expected=!%%a!"
    if not "!result!" == "!expected!" (
        call %unittest% fail "Given '!given!' %%c, expected '!expected!', got '!result!'"
    )
)
exit /b 0


:EOF
exit /b
