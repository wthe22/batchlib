:entry_point
call %*
exit /b


:color_print <color> <text>
2> nul (
    pushd "!tmp_dir!" || exit /b 1
     < nul set /p "=!BACK!!BACK!" > "%~2_"
    findstr /l /v /a:%~1 "." "%~2_" nul
    del /f /q "%~2_" > nul
    popd
)
exit /b 0


:lib.dependencies [return_prefix]
set "%~1install_requires=capchar"
set "%~1extra_requires=input_string"
set "%~1category=cli"
exit /b 0


:doc.man
::  NAME
::      color_print - print text with color
::
::  SYNOPSIS
::      color_print <color> <text>
::
::  POSITIONAL ARGUMENTS
::      color
::          The hexadecimal representation of the color.
::          The format of the color is '<background><foreground>'.
::
::      text
::          The text to display in colors.
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
::  ENVIRONMENT
::      This function uses:
::      - Temporary files
::
::      Global variables that affects this function:
::      - tmp_dir: Path to store the temporary files
::      - tmp: Fallback path of tmp_dir
::
::  NOTES
::      - Printing special characters (the invalid path characters: '"<>|?*:\/')
::        are not supported.
exit /b 0


:doc.demo
rem Satisfy dependencies
call :capchar LF BACK

call :input_string text || set "text=Hello World"
call :input_string hexadecimal_color || set "hexadecimal_color=02"
echo=
call :color_print "!hexadecimal_color!" "!text!" && (
    echo !LF!Print Success
) || echo !LF!Print Failed. Characters not supported, or external error occured
exit /b 0


:EOF
exit /b
