:entry_point  # Beginning of file
call %*
exit /b


:int.to_oct <return_var> <positive_integer>
setlocal EnableDelayedExpansion
set "_result="
for /l %%i in (0,3,31) do (
    set /a "_bits=(%~2>>%%i) & 0x7"
    set "_result=!_bits!!_result!"
)
for /f "tokens=1* delims=0" %%a in ("Q0!_result!") do (
    endlocal
    if "%%b" == "" (
        set "%~1=0"
    ) else set "%~1=%%b"
)
exit /b 0


:lib.build_system [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=Input.number"
set "%~1category=number"
exit /b 0


:doc.man
::  NAME
::      int.to_oct - convert decimal to octal
::
::  SYNOPSIS
::      int.to_oct <return_var> <positive_integer>
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
call :int.to_oct result !decimal!
echo=
echo The octal value of '!decimal!' is 0!result!
exit /b 0


:EOF  # End of File
exit /b
