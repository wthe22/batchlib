:entry_point
call %*
exit /b


:metadata [return_prefix]
set "%~1dependencies= "
set "%~1dev_dependencies="
set "%~1categories=external"
exit /b 0


:ext_powershell
powershell -Command "$PSVersionTable.PSVersion.ToString()"
exit /b


:doc.man
::  NAME
::      ext_powershell - an external program called PowerShell
::
::  NOTES
::      - This is just a helper to find functions that depends on it
::      - This function is not intended for use
exit /b 0


:EOF
exit /b
