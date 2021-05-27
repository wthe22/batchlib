:entry_point > nul 2> nul
call %*
exit /b


:is_echo_on
@(
    ( for %%n in (1) do call ) > "%temp%\result"
    for %%f in ("%temp%\result") do @if "%%~zf" == "0" @exit /b 2
) > nul 2>&1
@exit /b 0


:lib.build_system [return_prefix]
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
::  NOTES
::      - Temporary file is used in this function.
::      - This function produces no output, even if echo is on.
::
::  EXIT STATUS
::      0:  - Echo is on
::      2:  - Echo is off
exit /b 0


:doc.demo
call :is_echo_on && (
    echo Echo is on
) || echo Echo is off
exit /b 0


:EOF  # End of File
exit /b
