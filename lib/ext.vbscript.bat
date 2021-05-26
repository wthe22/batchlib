:entry_point > nul 2> nul
call %*
exit /b


:ext.vbscript
cscript > nul
exit /b


:lib.build_system
set "%~1install_requires= "
set "%~1category=external"
exit /b 0


:EOF  # End of File
exit /b
