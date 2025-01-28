:entry_point
call %*
exit /b


:input_string [-m message] [-f] <return_var>
setlocal EnableDelayedExpansion EnableExtensions
for %%v in (_return_var _message _require_filled) do set "%%v="
call :argparse2 --name %0 ^
    ^ "return_var:              set _return_var" ^
    ^ "[-m,--message MESSAGE]:  set _message" ^
    ^ "[-f,--filled]:           set _require_filled=true" ^
    ^ -- %* || exit /b 2
if not defined _message set "_message=Input !_return_var!: "
call :input_string._loop || exit /b 4
if not defined user_input (
    endlocal
    set "%_return_var%="
    exit /b 3
)
call :endlocal 0 1 user_input:!_return_var!
exit /b 0
#+++

:input_string._loop
for /l %%# in (1,1,10) do for /l %%# in (1,1,10) do (
    set "user_input="
    set /p "user_input=!_message!"
    if defined user_input (
        exit /b 0
    ) else if not defined _require_filled exit /b 0
)
echo%0: Too many invalid inputs
exit /b 1


:lib.dependencies [return_prefix]
set "%~1install_requires=argparse2 endlocal"
set "%~1category=ui"
exit /b 0


:doc.man
::  NAME
::      input_string - read a string from standard input
::
::  SYNOPSIS
::      input_string [-m message] [-f] <return_var>
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the result.
::
::  OPTIONS
::      -f, --filled
::          The string must not be an empty string.
::
::      -m MESSAGE, --message MESSAGE
::          Use MESSAGE as the prompt message.
::          By default, the message is generated automatically.
::
::  EXIT STATUS
::      0:  - Input is not empty.
::      2:  - Invalid argument.
::      3:  - Input is an empty string.
::      4:  - Too many invalid inputs (100 attempts).
exit /b 0


:doc.demo
call :input_string your_text --message "Enter anything: "
echo Your input: "!your_text!"
call :input_string your_text --filled --message "Enter something: "
echo Your input: "!your_text!"
exit /b 0


:tests.setup
set "text_empty="
set "text_hello=hello"
set "text_semicolon=; semicolon"
set "text_fail=fail"
exit /b 0


:tests.teardown
exit /b 0


:tests.test_input
for %%a in (
    "hello: hello fail"
    "semicolon: semicolon fail"
    "empty: empty fail"
    "hello: empty hello fail: --filled"
) do for /f "tokens=1-2* delims=:" %%b in (%%a) do (
    > "input" (
        for %%i in (%%c) do echo=!text_%%i!
    )
    call :input_string result %%d < "input" > nul
    set "expected=!text_%%b!"
    if not "!result!" == "!expected!" (
        call %unittest% fail "Given '%%c' and '%%d', expected '!expected!', got '!result!'"
    )
)
exit /b 0


:tests.test_errorlevel
for %%a in (
    "0: hello fail"
    "0: semicolon fail"
    "3: empty fail"
    "0: empty hello fail: --filled"
    "4: empty: --filled"
) do for /f "tokens=1-2* delims=:" %%b in (%%a) do (
    > "input" (
        for %%i in (%%c) do echo=!text_%%i!
    )
    call :input_string result %%d < "input" > nul
    set "result=!errorlevel!"
    set "expected=%%b"
    if not "!result!" == "!expected!" (
        call %unittest% fail "Given '%%c' and '%%d', expected '!expected!', got '!result!'"
    )
)
exit /b 0


:EOF
exit /b
