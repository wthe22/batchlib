:entry_point
call %*
exit /b


:strip <input_var> [characters]
if not defined ._shared.TAB (
    for /f "delims= " %%t in ('robocopy /l . . /njh /njs') do set "._shared.TAB=%%t"
)
setlocal EnableDelayedExpansion
set _args=$args
if "!_args!" == "$!!args" (
    set "_var=%~1"
    set "_chars=%~2"
) else (
    for /f "tokens=1*" %%a in ("!_args!") do (
        set "_var=%%a"
        set "_chars=%%b"
    )
)
set "TAB=!._shared.TAB!"
if not defined _chars set "_chars= !TAB!"
for /f "delims=" %%v in ("!_var!") do set "_value=_!%%v!"
for /f "delims=" %%a in ("!_chars:~0,1!") do (
    for /l %%n in (1,1,3) do (
    for /f "delims=" %%b in ("!_chars:~%%n,1!") do (
        set "_value=!_value:%%b=%%a!"
    ))
)
set "_value=!_value:~1!"
set "_ltrim=0"
set "_rtrim=0"
set "_to_trim=!_chars:~0,1!"
for /l %%n in (1,1,12) do set "_to_trim=!_to_trim!!_to_trim!"
for %%n in (4096 2048 1024 512 256 128 64 32 16 8 4 2 1) do (
    if "!_value:~0,%%n!" == "!_to_trim:~0,%%n!" (
        set /a "_ltrim+=%%n"
        set "_value=!_value:~%%n!"
    )
    if "!_value:~-%%n,%%n!" == "!_to_trim:~-%%n,%%n!" (
        set /a "_rtrim+=%%n"
        set "_value=!_value:~0,-%%n!"
    )
)
for /f "delims=" %%v in ("!_var!") do (
for /f "tokens=1-2" %%a in ("!_ltrim! !_rtrim!") do (
    endlocal
    if not "%%b" == "0" set "%%v=!%%v:~0,-%%b!"
    if not "%%a" == "0" set "%%v=!%%v:~%%a!"
))
exit /b 0


:_strip_trailing_whitespaces
rem A small snippet to strip up to 127 trailing spaces and tabs
rem But cannot handle special characters (caret, exclamation mark)
for %%n in (64 32 16 8 4 2 1) do (
    set "_tmp=!_var:~-%%n,%%n!"
    for /f "tokens=*" %%v in ("!_tmp!_") do (
        if "%%v" == "_" set "_var=!_var:~0,-%%n!"
    )
)
exit /b 0


:lib.dependencies [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=capchar input_string macroify"
set "%~1category=string"
exit /b 0


:doc.man
::  NAME
::      strip - remove character from beginning and end of string
::
::  SYNOPSIS
::      strip <input_var> [characters]
::      ( %strip:$args=<input_var> [characters]% )
::
::  POSITIONAL ARGUMENTS
::      input_var
::          The input variable name.
::
::      characters
::          Characters to strip at the same time. Max 4 characters.
::          Cannot strip multiple characters at the same time if it
::          contains special characters (askterisk '*' and equal sign '=')
::          By default, it is space (0x20) and tab (0x09)
::
::  ENVIRONMENT
::      This function uses:
::      - Shared global variables (TAB)
::
::  NOTES
::      - Function can be converted to macro using macroify()
exit /b 0


:doc.demo
call :capchar TAB

call :input_string string || set "string=  hello world.   "
call :input_string character || set "character= "
set "stripped=!string!"
echo=
call :strip stripped "!character!"
echo String     : '!string!'
echo Character  : '!character!'
echo Stripped   : '!stripped!'
exit /b 0


:tests.setup
call :capchar TAB
exit /b 0


:tests.teardown
exit /b 0


:tests.test_default
for %%a in (
    "first:   first   "
    "second:   second"
    "third:third   "
    ":"
    ":        "
) do for /f "tokens=1* delims=:" %%b in (".%%~a") do (
    set "given=%%c"
    set "result=%%c"
    call :strip result
    set "expected=%%b"
    set "expected=!expected:~1!"
    if not "!result!" == "!expected!" (
        call %unittest% fail "Given '!given!', expected '!expected!', got '!result!'"
    )
)
exit /b 0


:tests.test_single_character
set "space=    space     "
set "askterisk=****askterisk*"
set "equal==equal============"
set "colon=:::colon::::"
for %%v in (space askterisk equal colon) do (
    set "char=!%%v:~0,1!"
    set "expected=%%v"
    set "result=!%%v!"
    call :strip result "!char!"
    if not "!result!" == "!expected!" (
        call %unittest% fail "Fail at character '%%v'"
    )
)
exit /b 0


:tests.test_multiple_characters
set "whitespaces=!TAB!!TAB! whitespaces   "
set "title1=#####  title1  #####"
set "title2=-~-~ title2 ~-~-"
set "section=[section]"
set "variable=${variable}"
for %%a in (
    "whitespaces:"
    "title1:# "
    "title2:~- "
    "section:[]"
    "variable:${}"
) do for /f "tokens=1* delims=:" %%b in (%%a) do (
    set "chars=%%c"
    set "given=!%%b!"
    set "expected=%%b"
    set "result=!given!"
    call :strip result "!chars!"
    if not "!result!" == "!expected!" (
        call %unittest% fail "Given '!given!' and '!char!', expected '!expected!', got '!result!'"
    )
)
exit /b 0


:tests.test_expanded_characters
set result==^^^^ ^^^^^^^^ %%0 %%%%^^a ^^!e^^! "^^ ^^^^ %%0 %%%%^a ^!e^!"
set "expected=!result!"
call :strip result
if not "!result!" == "!expected!" (
    call %unittest% fail "Expanded characters are not preserved"
)
set "result=   ^^                                 ^!e^!   "
set "expected=!result:~3,-3!"
call :strip result
if not "!result!" == "!expected!" (
    call %unittest% fail "Failed when characters to strip are in the middle"
)
exit /b 0


:tests.test_macro
for %%a in (
    "first:   first   "
    "second:   second"
    "third:third   "
    ":"
    ":        "
) do for /f "tokens=1* delims=:" %%b in (".%%~a") do (
    set "given=%%c"
    set "result=%%c"
    ( %strip:$args=result% )
    set "expected=%%b"
    set "expected=!expected:~1!"
    if not "!result!" == "!expected!" (
        call %unittest% fail "Given '!given!', expected '!expected!', got '!result!'"
    )
)
exit /b 0


:EOF
exit /b
