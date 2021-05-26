:entry_point > nul 2> nul
call %*
exit /b


:ext.powershell
powershell -Command "$PSVersionTable.PSVersion.ToString()"
exit /b


:lib.build_system
set "%~1install_requires= "
set "%~1category=external"
exit /b 0


:EOF  # End of File
exit /b
