:entry_point
call %*
exit /b


:get_con_size <width_return_var> <height_return_var>
setlocal EnableDelayedExpansion
set "_index=0"
for /f "usebackq tokens=2 delims=:" %%a in (`call ^| mode con`) do (
    set /a "_index+=1"
    if "!_index!" == "1" set /a "_height=%%a"
    if "!_index!" == "2" set /a "_width=%%a"
)
set "_index="
for /f "tokens=1-2 delims=x" %%a in ("!_width!x!_height!") do (
    endlocal
    set "%~1=%%a"
    set "%~2=%%b"
)
exit /b 0


:lib.dependencies [return_prefix]
set "%~1install_requires= "
set "%~1category=cli"
exit /b 0


:doc.man
::  NAME
::      get_con_size - get console screen buffer size
::
::  SYNOPSIS
::      get_con_size <width_return_var> <height_return_var>
::
::  POSITIONAL ARGUMENTS
::      width_return_var
::          Variable to store the console width.
::
::      height_return_var
::          Variable to store the console height.
exit /b 0


:doc.demo
call :get_con_size console_width console_height
echo=
echo Screen buffer size    : !console_width!x!console_height!
exit /b 0


rem ================================ notes ================================

rem Executing 'mode con' causes input stream to be flushed.
rem This could cause tests that uses file as input stream to fail.
rem Calling it from pipe will prevent this.


:EOF
exit /b
