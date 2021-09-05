:entry_point
call %*
exit /b


:is_admin
( net session || openfiles || exit /b 2 ) > nul 2> nul
exit /b 0


:lib.dependencies [return_prefix]
set "%~1install_requires= "
set "%~1category=env"
exit /b 0


:doc.man
::  NAME
::      is_admin - check for administrator privilege
::
::  SYNOPSIS
::      is_admin
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the result.
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
