:entry_point
call %*
exit /b


:strip <input_var> [character]
setlocal EnableDelayedExpansion
set "_var=%~1"
set "_char=%~2"
if not defined _char set "_char= "
endlocal & (
    for /f "tokens=* delims=%_char%" %%a in ("!%_var%!_") do set "%_var%=%%a"
    set "%_var%=_!%_var%:~0,-1!"
    for /l %%n in (1,1,8192) do if "!%_var%:~-1,1!" == "%_char%" (
        if not "!%_var%:~-%%n,1!" == "%_char%" (
            set "%_var%=!%_var%:~0,-%%n!!%_var%:~-%%n,1!"
        )
    )
    set "%_var%=!%_var%:~1!"
)
exit /b 0


:_strip_trailing_whitespaces
rem A small snippet to strip up to 127 trailing spaces and tabs
for %%n in (64 32 16 8 4 2 1) do (
    set "_tmp=!_var:~-%%n,%%n!"
    for /f "tokens=*" %%v in ("!_tmp!_") do (
        if "%%v" == "_" set "_var=!_var:~0,-%%n!"
    )
)
exit /b 0


:lib.dependencies [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=input_string"
set "%~1category=string"
exit /b 0


:doc.man
::  NAME
::      strip - remove character from beginning and end of string
::
::  SYNOPSIS
::      strip <input_var> [character]
::
::  POSITIONAL ARGUMENTS
::      input_var
::          The input variable name.
::
::      character
::          The character to strip. Double quotes are not supported.
exit /b 0


:doc.demo
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


:tests.test_character
for %%a in (
    " equal :=:=== equal ========"
    " hastag :#:### hastag ###"
    " ### spaced :#: ### spaced ###"
) do for /f "tokens=1-2* delims=:" %%b in (".%%~a") do (
    set "given=%%d"
    set "result=!given!"
    call :strip result "%%c"
    set "expected=%%b"
    set "expected=!expected:~1!"
    if not "!result!" == "!expected!" (
        call %unittest% fail "Given '!given!' and '%%c', expected '!expected!', got '!result!'"
    )
)
exit /b 0


:EOF
exit /b
