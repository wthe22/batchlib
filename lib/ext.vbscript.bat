:entry_point  # Beginning of file
call %*
exit /b


:ext.vbscript
cscript > nul
exit /b


:lib.build_system
set "%~1install_requires= "
set "%~1category=external"
exit /b 0


:doc.man
::  NAME
::      ext.vbscript - an external program called VBScript
::
::  NOTES
::      - This is just a helper to find functions that depends on it
::      - This function is not intended for use
exit /b 0


:EOF  # End of File
exit /b
