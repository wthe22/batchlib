:entry_point
call %*
exit /b


:is_number <input_string>
setlocal EnableDelayedExpansion
set "_input=%~1"
set "_result=#!_input!#"
if "!_result:~1,1!" == "+" (
    set "_result=!_result:~0,1!!_result:~2!"
) else if "!_result:~1,1!" == "-" (
    set "_result=!_result:~0,1!!_result:~2!"
)
if /i "!_result:~1,2!" == "0x" (
    set "_result=!_result:~0,1!!_result:~3!"
    for /f "tokens=1* delims=0123456789ABCDEFabcdef" %%a in ("!_result!") do set "_result=%%a,%%b"
) else if "!_result:~1,1!" == "0" (
    for /f "tokens=1* delims=01234567" %%a in ("!_result!") do set "_result=%%a,%%b"
) else (
    for /f "tokens=1* delims=0123456789" %%a in ("!_result!") do set "_result=%%a,%%b"
)
if not "!_result!" == "#,#" exit /b 2
set "_result="
set /a "_result=!_input!" || exit /b 2
set /a "_result=!_result!" || exit /b 2
exit /b 0


:lib.dependencies [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=input_string"
set "%~1category=number"
exit /b 0


:doc.man
::  NAME
::      is_number - check if a string is a number
::
::  SYNOPSIS
::      is_number <input_string>
::
::  DESCRIPTION
::      Check if a string only contains a number/hexadecimal/octal; no words
::      or other symbols.
::
::  POSITIONAL ARGUMENTS
::      input_string
::          The string to check.
::
::  EXIT STATUS
::      0:  - The string contains a number/hexadecimal/octal between
::            -2147483647 to 2147483647.
::      2:  - The string contains an invalid number or other symbols.
::
::  NOTES
::      - Hexadecimal must start with '0x' (case insensitive)
::      - Octal must start with '0'
exit /b 0


:doc.demo
call :input_string --optional string
call :is_number "!string!" && (
    echo It is a number
) || echo It is not a number
exit /b 0


:tests.setup
set "return.true=0"
set "return.false=2"
exit /b 0


:tests.teardown
exit /b 0


:tests.test_int
call :tests.check_errorlevel ^
    ^ "true: 1" ^
    ^ "true: 0" ^
    ^ "true: +1" ^
    ^ "true: -1" ^
    ^ "true: 2147483647" ^
    ^ "true: -2147483647" ^
    ^ %=end=%
exit /b 0


:tests.test_octal
call :tests.check_errorlevel ^
    ^ "true: 00" ^
    ^ "true: 010" ^
    ^ "true: -07" ^
    ^ %=end=%
exit /b 0


:tests.test_hexadecimal
call :tests.check_errorlevel ^
    ^ "true: 0x0" ^
    ^ "true: 0x10" ^
    ^ "true: 0xabcdef" ^
    ^ "true: 0xABCDEF" ^
    ^ %=end=%
exit /b 0


:tests.test_invalidate
call :tests.check_errorlevel ^
    ^ "false: -" ^
    ^ "false: x" ^
    ^ "false: 0x" ^
    ^ "false: x0" ^
    ^ "false: -0x" ^
    ^ "false: abcdef" ^
    ^ "false: 08" ^
    ^ "false: +" ^
    ^ %=end=%
exit /b 0


:tests.check_errorlevel <expected:args> [...]
for %%a in (
    %*
) do for /f "tokens=1* delims=: " %%b in (%%a) do (
    set "given=%%c"
    call :is_number !given!
    set "result=!errorlevel!"
    set "expected=!return.%%b!"
    if not "!result!" == "!expected!" (
        call %unittest% fail "Given '!given!', expected '!expected!', got '!result!'"
    )
)
exit /b 0


:EOF
exit /b
