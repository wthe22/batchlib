:entry_point
call %*
exit /b


:is_echo_on
@for %%f in ("%tmp%\.is_echo_on") do @(
    ( for %%n in (1) do call ) > %%f
    for %%r in (%%f) do @if "%%~zr" == "0" @exit /b 2
) > nul 2>&1
@exit /b 0


:lib.dependencies [return_prefix]
set "%~1install_requires= "
set "%~1category=console"
exit /b 0


:doc.man
::  NAME
::      is_echo_on - check if echo is on
::
::  SYNOPSIS
::      is_echo_on
::
::  ENVIRONMENT
::      tmp
::          Path to store the temporary results.
::
::  NOTES
::      - Temporary file is used in this function.
::      - This function produces no output, even if echo is on.
::
::  EXIT STATUS
::      0:  - Echo is on
::      2:  - Echo is off
exit /b 0


:doc.demo
@call :is_echo_on && @(
    set "echo_status=on"
) || @set "echo_status=off"
@echo on

echo on
call :is_echo_on && (
    echo Echo is on
) || echo Echo is off

echo off
call :is_echo_on && (
    echo Echo is on
) || echo Echo is off

@echo !echo_status!
exit /b 0


:EOF
exit /b
