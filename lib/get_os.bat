:entry_point
call %*
exit /b


:get_os <return_var> [--name]
for /f "tokens=4 delims=[] " %%v in ('ver') do set "%~1=%%v"
if /i "%~2" == "--name" (
    for /f "tokens=1-2 delims=." %%a in ("!%~1!") do set "%~1=%%a.%%b"
    if "!%~1!" == "10.0" set "%~1=Windows 10"
    if "!%~1!" == "6.3" set "%~1=Windows 8.1"
    if "!%~1!" == "6.2" set "%~1=Windows 8"
    if "!%~1!" == "6.1" set "%~1=Windows 7"
    if "!%~1!" == "6.0" set "%~1=Windows Vista"
    if "!%~1!" == "5.2" set "%~1=Windows XP 64-Bit"
    if "!%~1!" == "5.1" set "%~1=Windows XP"
    if "!%~1!" == "5.0" set "%~1=Windows 2000"
)
exit /b 0


:lib.dependencies [return_prefix]
set "%~1install_requires= "
set "%~1category=env"
exit /b 0


:doc.man
::  NAME
::      get_os - get the OS version of this computer
::
::  SYNOPSIS
::      get_os <return_var> [--name]
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the result.
::
::  OPTIONS
::      --name
::          Returns the OS name instead of the OS version number.
exit /b 0


:doc.demo
call :get_os os_name --name
call :get_os os_ver
echo Your OS is !os_name!
echo Your OS version is !os_ver!
exit /b 0


:EOF
exit /b
