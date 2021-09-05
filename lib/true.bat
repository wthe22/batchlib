:entry_point
call %*
exit /b


:true
exit /b 0


:lib.dependencies [return_prefix]
set "%~1install_requires= "
set "%~1category=devtools"
exit /b 0


:doc.man
::  NAME
::      true - sets exit status to 0
::
::  SYNOPSIS
::      true
exit /b 0


:doc.demo
call :true && (
    echo Success
) || echo Fail
exit /b 0


:EOF
exit /b
