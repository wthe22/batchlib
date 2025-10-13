:entry_point
call %*
exit /b


:metadata [return_prefix]
set "%~1dependencies=argparse is_number is_in_range"
set "%~1dev_dependencies="
set "%~1categories=cli"
exit /b 0


:input_number [-m message] [-r range] [-a] [-o] <return_var>
setlocal EnableDelayedExpansion
for %%v in (_return_var _message _range _as_is) do set "%%v="
call :argparse --name %0 ^
    ^ "return_var:              set _return_var" ^
    ^ "[-m,--message MESSAGE]:  set _message" ^
    ^ "[-o,--optional]:         set _optional=true" ^
    ^ "[-r,--range RANGE]:      set _range" ^
    ^ "[-a,--as-is]:            set _as_is=true" ^
    ^ -- %* || exit /b 2
if not defined _message (
    set "_message=Input !_return_var!"
    if defined _range set "_message=!_message! [!_range!]"
    if defined _optional set "_message=!_message! (optional)"
    set "_message=!_message!: "
)
call :input_number._loop || exit /b 4
if not defined _as_is (
    if defined user_input set /a "user_input=!user_input!"
)
for /f "tokens=1* delims=:" %%q in ("Q:!user_input!") do (
    endlocal
    set "%_return_var%=%%r"
    if not defined %_return_var% exit /b 3
)
exit /b 0
#+++

:input_number._loop
for /l %%# in (1,1,7) do for /l %%# in (1,1,7) do (
    set "user_input="
    set /p "user_input=!_message!"
    if defined user_input (
        call :is_number "!user_input!" ^
            ^ && call :is_in_range "!user_input!" "!_range!" ^
            ^ && exit /b 0
    ) else if defined _optional exit /b 0
)
exit /b 1


:doc.man
::  NAME
::      input_number - reads a number from standard input
::
::  SYNOPSIS
::      input_number [-m message] [-r range] [-a] [-o] <return_var>
::
::  DESCRIPTION
::      Reads a decimal/octal/hexadecial from standard input, then converts
::      the value to integer and save it to the return variable.
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the result.
::
::  OPTIONS
::      -r RANGE, --range RANGE
::          The set of valid values, each seperated by space and/or comma. All
::          values must be within the same quote. Use '~' to specify a range
::          (e.g -9 to 71 is written as '-9~71'). Hexadecimal and octal are also
::          supported. By default, it is '-2147483647~2147483647'.
::
::      -m MESSAGE, --message MESSAGE
::          Use MESSAGE as the prompt message.
::          By default, the message is generated automatically.
::
::      -a, --as-is
::          Do not convert the octal/hexadecial to integer. Just return as it is.
::
::      -o, --optional
::          Input is optional and could be skipped by entering nothing.
::
::  EXIT STATUS
::      0:  - Input is successful.
::      2:  - Invalid argument.
::      3:  - User skips the input.
::      4:  - Input attempt reaches the 100 attempt limit.
exit /b 0


:doc.demo
@setlocal EnableDelayedExpansion
@echo off
call :input_number your_integer --range "-9~99, 111, 777, 888" --optional
echo Your input: !your_integer!
exit /b 0


:tests.setup
> "boundaries" (
    echo=
    echo abcdef
    echo *
    echo -2147483648
    echo -2147483647
    echo 2147483647
    echo -65536
    echo 65535
    echo -100
    echo 100
    echo -1
    echo 1
    echo 0
)
exit /b 0


:tests.teardown
exit /b 0


:tests.test_input
for %%a in (
    "100:   0~200   :boundaries"
) do for /f "tokens=1-2* delims=:" %%b in (%%a) do (
    < "%%d" > nul 2>&1 (
        call :input_number result --range %%c
    )
    set "expected=%%b"
    if not "!result!" == "!expected!" (
        call %unittest% fail "expected '%%b', got '!result!'"
    )
)
exit /b 0


:EOF
exit /b
