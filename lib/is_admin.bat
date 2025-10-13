:entry_point
call %*
exit /b


:metadata [return_prefix]
set "%~1dependencies= "
set "%~1dev_dependencies="
set "%~1categories=os"
exit /b 0


:is_admin
( net session || openfiles || exit /b 2 ) > nul 2> nul
exit /b 0


:doc.man
::  NAME
::      is_admin - check for administrator privilege
::
::  SYNOPSIS
::      is_admin
::
::  EXIT STATUS
::      0:  - Administrator privilege is detected.
::      2:  - No administrator privilege is detected.
exit /b 0


:doc.demo
call :is_admin && (
    echo Administrator privilege detected
) || echo No administrator privilege detected
exit /b 0


:EOF
exit /b
