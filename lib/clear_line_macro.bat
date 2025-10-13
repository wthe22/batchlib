:entry_point
call %*
exit /b


:metadata [return_prefix]
set "%~1dependencies=capchar get_os"
set "%~1dev_dependencies=get_con_size"
set "%~1categories=cli"
exit /b 0


:clear_line_macro <return_var> <width>
setlocal EnableDelayedExpansion
set "_return_var=%~1"
set "_width=%~2"
if not defined _width set "_width=80"
call :capchar CR BACK
call :get_os _os
for /f "tokens=1 delims=. " %%a in ("!_os!") do set "_os=%%a"
set "_result="
if !_os! GEQ 10 (
    for /l %%n in (1,1,%_width%) do set "_result=!_result! "
    set "_result=_!CR!!_result!!CR!"
) else for /l %%n in (1,1,%_width%) do set "_result=!_result!!BACK!"
for /f "tokens=1-2 delims=:" %%q in ("Q:!_result!:Q") do (
    endlocal
    set "%_return_var%=%%r"
)
exit /b 0


:doc.man
::  NAME
::      clear_line_macro - create a macro to clear current line
::
::  SYNOPSIS
::      clear_line_macro <return_var> [width]
::      echo !CL![text]
::      < nul set /p "=!CL![text]"
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the macro. There is no default, but the suggested
::          name is 'CL'.
::
::      width
::          The width of the console. By default, it is 80.
::
::  NOTES
::      - The macro will fail if the text/cursor reached the end of the line.
::      - In Windows 10, the recommended way to clear a line is by using
::        ANSI escape sequence: '\u001b[2K\r'
exit /b 0


:doc.demo
rem Satisfy dependencies
call :capchar CR BACK
call :get_con_size console_width console_height

call :clear_line_macro CL !console_width!
echo=
echo First test: end of the line not reached
< nul set /p "=Press any key to clear this line"
for /l %%n in (34,1,!console_width!) do < nul set /p "=."
pause > nul
< nul set /p "=!CL!Line cleared"
echo=
echo=
echo Second test: end of the line reached, failure expected
< nul set /p "=Press any key to clear this line"
for /l %%n in (33,1,!console_width!) do < nul set /p "=."
pause > nul
< nul set /p "=!CL!Did it fail?"
exit /b 0


:EOF
exit /b
