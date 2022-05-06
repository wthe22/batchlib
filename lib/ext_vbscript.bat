:entry_point
call %*
exit /b


:ext_vbscript
cscript > nul
exit /b


:lib.dependencies [return_prefix]
set "%~1install_requires= "
set "%~1category=external"
exit /b 0


:doc.man
::  NAME
::      ext_vbscript - an external program called VBScript
::
::  NOTES
::      - This is just a helper to find functions that depends on it
::      - This function is not intended for use
exit /b 0


:EOF
exit /b
