:entry_point
call %*
exit /b


:get_pid_by_title <return_var> <window_title>
setlocal EnableDelayedExpansion
set "_return_var=%~1"
set "_window_title=%~2"
set "_result="
for /f "usebackq tokens=2 skip=3" %%f in (
    `tasklist /fi "windowtitle eq !_window_title!"`
) do set "_result=!_result! %%f"
set "_count=0"
for %%p in (!_result!) do set /a "_count+=1"
for /f "tokens=1*" %%q in ("Q !_result!") do (
    endlocal
    set "%_return_var%=%%r"
    if not "%_count%" == "1" exit /b 2
)
exit /b 0


:lib.dependencies [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=Input.string"
set "%~1category=time"
exit /b 0


:doc.man
::  NAME
::      get_pid_by_title - get PID of a process by its window title
::
::  SYNOPSIS
::      get_pid_by_title <return_var> <window_title>
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the result, each seperated by space if multiple
::          processes is found.
::
::      window_title
::          The window title of the process.
::
::  EXIT STATUS
::      0:  - Exactly 1 process is found.
::      2:  - Process is not found or multiple processes found.
exit /b 0


:doc.demo
set "window_name=get_pid_by_title - Demo Window"
start "!window_name!" cmd /c pause
call :get_pid_by_title pid "!window_name!"

echo Window name    : !window_name!
echo Window PID     : !pid!
exit /b 0


:EOF
exit /b
