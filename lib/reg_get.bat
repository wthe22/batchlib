:entry_point
call %*
exit /b


:metadata [return_prefix]
set "%~1dependencies= "
set "%~1dev_dependencies="
set "%~1categories=env"
exit /b 0


:reg_get
setlocal EnableDelayedExpansion
set "_return_var=%~1"
set "_key_name=%~2"
set "_value_name=%~3"
for /f "tokens=* skip=2 usebackq" %%o in (`reg query "!_key_name!" /v "!_value_name!"`) do (
    for /f "tokens=1,2* delims= " %%a in ("%%o") do (
		endlocal
		set "%_return_var%=%%c"
		exit /b 0
	)
)
exit /b 2


rem ############################################################################
rem Documentation
rem ############################################################################

:doc.man
::  NAME
::      reg_get - get value of a registry key
::
::  SYNOPSIS
::      reg_get <key_name> <value_name>
::
::  POSITIONAL ARGUMENTS
::      key_name
::          in the form of ROOTKEY\SubKey name
::
::  EXIT STATUS
::      0:  - Success
::      1:  - An unexpected error occured
::      2:  - Failure
::
::  NOTES
::      - Script might not work with value name that contain spaces
exit /b 0


:doc.demo
echo reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList" /v "Default"
echo=
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList" /v "Default"
echo=
call :reg_get default_dir "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList" "Default" && (
    echo Success
) || echo Failed
echo=
echo Value: !default_dir!
exit /b 0


rem ############################################################################
rem Tests
rem ############################################################################

:tests.setup
exit /b 0


:tests.teardown
exit /b 0


rem ############################################################################
rem End of File
rem ############################################################################

:EOF
@rem DO NOT WRITE ANYTHING YOU NEED TO KEEP BELOW THIS FUNCTION.
@rem ANYTHING BEYOND THIS FUNCTION WILL BE REMOVED WHEN ADDING DEPENDENCIES.
@exit /b
