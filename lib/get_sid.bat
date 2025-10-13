:entry_point
call %*
exit /b


:metadata [return_prefix]
set "%~1dependencies= "
set "%~1dev_dependencies="
set "%~1categories=os"
exit /b 0


:get_sid <return_var>
set "%~1="
for /f "tokens=2" %%s in ('whoami /user /fo table /nh') do set "%~1=%%s"
exit /b 0


:doc.man
::  NAME
::      get_sid - get currect user's SID
::
::  SYNOPSIS
::      get_sid <return_var>
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the result.
exit /b 0


:doc.demo
call :get_sid result
echo=
echo User SID : !result!
exit /b 0


:EOF
exit /b
