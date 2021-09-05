:entry_point
call %*
exit /b


:int.to_hex <return_var> <positive_integer>
setlocal EnableDelayedExpansion
set "_charset=0123456789ABCDEF"
set "_result="
for /l %%i in (0,4,31) do (
    set /a "_bits=(%~2>>%%i) & 0xF"
    for %%b in (!_bits!) do set "_result=!_charset:~%%b,1!!_result!"
)
for /f "tokens=1* delims=0" %%a in ("Q0!_result!") do (
    endlocal
    if "%%b" == "" (
        set "%~1=0"
    ) else set "%~1=%%b"
)
exit /b 0


:lib.dependencies [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=Input.number"
set "%~1category=number"
exit /b 0


:doc.man
::  NAME
::      int.to_hex - convert decimal to hexadecimal
::
::  SYNOPSIS
::      int.to_hex <return_var> <positive_integer>
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the result.
::
::      positive_integer
::          The positive integer to convert.
exit /b 0


:doc.demo
call :Input.number decimal --range "0~2147483647" --optional || (
    set "decimal=!random!"
)
call :int.to_hex result !decimal!
echo=
echo The hexadecimal value of '!decimal!' is 0x!result!
exit /b 0


:EOF
exit /b
