:entry_point
call %*
exit /b


:get_ext_ip <return_var>
for %%u in (
    "http://ipecho.net/plain"
    "http://ifconfig.me/ip"
) do for /f "usebackq delims=" %%o in (
    `powershell -Command "(New-Object Net.WebClient).DownloadString('%%~u')" 2^> nul`
) do (
    set "%~1=%%o"
    exit /b 0
)
exit /b 1


:lib.dependencies [return_prefix]
set "%~1install_requires=ext_powershell"
set "%~1category=net"
exit /b 0


:doc.man
::  NAME
::      get_ext_ip - get the external IP address of this computer
::
::  SYNOPSIS
::      get_ext_ip <return_var>
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the result.
::
::  NOTES
::      - PowerShell is used to download the information file.
exit /b 0


:doc.demo
call :get_ext_ip ext_ip
echo=
echo External IP    : !ext_ip!
exit /b 0


:EOF
exit /b
