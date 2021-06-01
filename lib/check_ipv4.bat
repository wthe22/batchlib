:entry_point > nul 2> nul
call %*
exit /b


:check_ipv4 <input_string> [--wildcard]
setlocal EnableDelayedExpansion
set "_allow_wildcard="
if "%~2" == "--wildcard" set "_allow_wildcard=true"
set "_input= %~1"
if not "!_input:..=!" == "!_input!" exit /b 1
for /f "tokens=1,5,6 delims=." %%a in ("a.!_input!") do (
    if "%%b" == "" exit /b 1
    if not "%%c" == "" exit /b 1
)
set "_input=!_input:~1!"
set _input=!_input:.=^
%=REQUIRED=%
!
for /f "tokens=*" %%n in ("!_input!") do (
    if "%%n" == "*" (
        if not defined _allow_wildcard exit /b 1
    ) else (
        set "_evaluated="
        set /a "_evaluated=%%n" 2> nul || exit /b 1
        set /a "_num=!_evaluated!" 2> nul || exit /b 1
        if not "!_num!" == "%%n" exit /b 1
        if %%n LSS 0    exit /b 1
        if %%n GTR 255  exit /b 1
    )
)
exit /b 0


:lib.build_system [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=Input.string capchar"
set "%~1category=net"
exit /b 0


:doc.man
::  NAME
::      check_ipv4 - check if a string is an IPv4
::
::  SYNOPSIS
::      check_ipv4 <input_string> [--wildcard]
::
::  POSITIONAL ARGUMENTS
::      input_string
::          The string to be checked.
::
::  OPTIONS
::      --wildcard
::          Allow wildcard in the IPv4 address. This must be placed
::          as the second argument.
exit /b 0


:doc.demo
call :Input.string ip_address
echo=
echo Your entered: '!ip_address!'
call :check_ipv4 "!ip_address!" && (
    echo IP is valid
) || echo IP is invalid
exit /b 0


:tests.setup
call :capchar LF
set "return.true=0"
set "return.false=1"
exit /b 0


:tests.teardown
exit /b 0


:tests.test_octet_count
call :tests.check_errorlevel ^
    ^ "false: " ^
    ^ "false: 0" ^
    ^ "false: 0.0.0.0.0"
exit /b 0


:tests.test_in_range
call :tests.check_errorlevel ^
   ^ "true:  0.0.0.0" ^
   ^ "true:  255.255.255.255"
exit /b 0


:tests.test_out_of_range
call :tests.check_errorlevel ^
   ^ "false: 0.0.0.-1" ^
   ^ "false: 0.0.0.256" ^
   ^ "false: 0.0.0.2147483647" ^
   ^ "false: 0.0.0.-2147483647"
exit /b 0


:tests.test_wildcard
call :tests.check_errorlevel ^
   ^ "false: *.*.*.*" ^
   ^ "true:  *.*.*.* --wildcard"
exit /b 0


:tests.check_errorlevel
set "args="
for /l %%n in (1,1,10) do (
    call set _value=%%~1
    if defined _value (
        set "args=!args!!_value!!LF!"
        shift /1
    )
)
for /f "tokens=1* delims=:" %%a in ("!args!") do (
    call :check_ipv4 %%b
    set "exit_code=!errorlevel!"
    if not "!exit_code!" == "!return.%%a!" (
        call %unittest% fail "Expected %%a for argument '%%b'"
    )
)
exit /b 0


:EOF  # End of File
exit /b
