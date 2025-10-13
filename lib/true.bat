:entry_point
call %*
exit /b


:metadata [return_prefix]
set "%~1install_requires= "
set "%~1category=algorithms"
exit /b 0


:true
exit /b 0


:doc.man
::  NAME
::      true - set exit status / errorlevel to 0
::
::  SYNOPSIS
::      true
::
::  NOTES
::      - Shortest way to set errorlevel:
::          - 0: ( call )
::          - 1: call
exit /b 0


:doc.demo
call :true && (
    echo Success
) || echo Fail
exit /b 0


:EOF
exit /b
