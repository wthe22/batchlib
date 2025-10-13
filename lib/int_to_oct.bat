:entry_point
call %*
exit /b


:metadata [return_prefix]
set "%~1dependencies= "
set "%~1dev_dependencies=input_number"
set "%~1categories=number"
exit /b 0


:int_to_oct <return_var> <positive_integer>
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


:doc.man
::  NAME
::      int_to_oct - convert decimal to octal
::
::  SYNOPSIS
::      int_to_oct <return_var> <positive_integer>
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the result.
::
::      positive_integer
::          The positive integer to convert.
exit /b 0


:doc.demo
call :input_number decimal --range "0~2147483647" --optional || (
    set "decimal=!random!"
)
call :int_to_oct result !decimal!
echo=
echo The octal value of '!decimal!' is 0!result!
exit /b 0


:EOF
exit /b
