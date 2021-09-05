:entry_point
call %*
exit /b


:color2seq <return_var> <color>
set "%~1=%~2"
set "%~1=[!%~1:~0,1!;!%~1:~1,1!m"
for %%t in (
    0--40-30  1--44-34  2--42-32  3--46-36
    4--41-31  5--45-35  6--43-33  7--47-37
    8-100-90  9-104-94  A-102-92  B-106-96
    C-101-91  D-105-95  E-103-93  F-107-97
) do for /f "tokens=1-3 delims=-" %%a in ("%%t") do (
    set "%~1=!%~1:[%%a;=[%%b;!"
    set "%~1=!%~1:;%%am=;%%cm!"
)
exit /b 0


:lib.dependencies [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=capchar Input.string"
set "%~1category=console"
exit /b 0


:doc.man
::  NAME
::      color2seq - convert hexadecimal color to ANSI escape sequence
::
::  SYNOPSIS
::      color2seq <return_var> <color>
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the result.
::
::      color
::          The hexadecimal representation of the color.
::          The format of the color is '<background><foreground>'.
::
::  COLORS
::      0 = Black       8 = Gray
::      1 = Blue        9 = Light Blue
::      2 = Green       A = Light Green
::      3 = Aqua        B = Light Aqua
::      4 = Red         C = Light Red
::      5 = Purple      D = Light Purple
::      6 = Yellow      E = Light Yellow
::      7 = White       F = Bright White
::
::  NOTES
::      - Used for color print in windows 10 or any other console that supports
::        ANSI escape sequence.
exit /b 0


:doc.demo
call :capchar ESC
call :Input.string hexadecimal_color || set "hexadecimal_color=02"
call :color2seq color_code "!hexadecimal_color!"
echo=
echo Hex Color  : !hexadecimal_color!
echo Sequence   : !color_code!
echo Color print: !ESC!!color_code!Hello World!ESC![0m
exit /b 0


:EOF
exit /b
