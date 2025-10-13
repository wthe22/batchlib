:entry_point
call %*
exit /b


:metadata [return_prefix]
set "%~1dependencies=argparse check_ipv4"
set "%~1dev_dependencies="
set "%~1categories=cli"
exit /b 0


:input_ipv4 [-m message] [-w] [-o] <return_var>
setlocal EnableDelayedExpansion EnableExtensions
for %%v in (_return_var _message _allow_wildcard _check_options) do set "%%v="
call :argparse --name %0 ^
    ^ "return_var:              set _return_var" ^
    ^ "[-m,--message MESSAGE]:  set _message" ^
    ^ "[-o,--optional]:         set _optional=true" ^
    ^ "[-w,--allow-wildcard]:   set _allow_wildcard=true" ^
    ^ -- %* || exit /b 2
if defined _allow_wildcard set "_check_options= --wildcard"
if not defined _message (
    if defined _allow_wildcard set "_message=!_message!wildcard allowed, "
    if defined _optional set "_message=!_message!optional, "
    if defined _message (
        set "_message=Input !_return_var! (!_message:~0,-2!): "
    ) else set "_message=Input !_return_var!: "
)
call :input_ipv4._loop || exit /b 4
for /f "tokens=1* delims=:" %%q in ("Q:!user_input!") do (
    endlocal
    set "%_return_var%=%%r"
    if not defined %_return_var% exit /b 3
)
exit /b 0
#+++

:input_ipv4._loop
for /l %%# in (1,1,7) do for /l %%# in (1,1,7) do (
    set "user_input="
    set /p "user_input=!_message!"
    if defined user_input (
        call :check_ipv4 "!user_input!" !_check_options! && exit /b 0
    ) else if defined _optional exit /b 0
)
echo%0: Too many invalid inputs
exit /b 1


:doc.man
::  NAME
::      input_ipv4 - read an IPv4 from standard input
::
::  SYNOPSIS
::      input_ipv4 [-m message] [-w] [-o] <return_var>
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the result.
::
::  OPTIONS
::      -w, --allow-wildcard
::          Allow wildcards in the IPv4 address.
::
::      -m MESSAGE, --message MESSAGE
::          By default, the message is generated automatically.
::
::      -o, --optional
::          Input is optional and could be skipped by entering nothing.
::
::  EXIT STATUS
::      0:  - Input is successful.
::      2:  - Invalid argument.
::      3:  - User skips the input.
::      4:  - Too many invalid inputs (100 attempts).
exit /b 0


:doc.demo
call :input_ipv4 -w --optional ipv4_address
echo Your input: '!ipv4_address!'
exit /b 0


:tests.setup
set "text_empty="
set "text_localhost=127.0.0.1"
set "text_all=0.0.0.0"
set "text_wildcard1234=*.*.*.*"
set "text_zero=0"
set "text_abcd=a.b.c.d"
set "text_fail=1.2.3.4"
exit /b 0


:tests.teardown
exit /b 0


:tests.test_input
for %%a in (
    "localhost: localhost fail"
    "all: all fail"
    "localhost: empty localhost fail"
    "localhost: zero localhost fail"
    "localhost: abcd localhost fail"
    "wildcard1234: wildcard1234 fail: --allow-wildcard"
) do for /f "tokens=1-2* delims=:" %%b in (%%a) do (
    > "input" (
        for %%i in (%%c) do echo=!text_%%i!
    )
    call :input_ipv4 result %%d < "input" > nul
    if not "!result!" == "!text_%%b!" (
        call %unittest% fail %%a
    )
)
exit /b 0


:tests.test_limit
for %%a in (
    "0: localhost"
    "0: empty localhost"
    "4: wildcard1234"
    "0: wildcard1234: --allow-wildcard"
) do for /f "tokens=1-2* delims=:" %%b in (%%a) do (
    > "input" (
        for %%i in (%%c) do echo=!text_%%i!
    )
    call :input_ipv4 result %%d < "input" > nul
    if not "!errorlevel!" == "%%b" (
        call %unittest% fail %%a
    )
)
exit /b 0


:EOF
exit /b
