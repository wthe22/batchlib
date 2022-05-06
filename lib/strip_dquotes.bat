:entry_point
call %*
exit /b


:strip_dquotes <input_var>
if "!%~1:~0,1!!%~1:~-1,1!" == ^"^"^"^" set "%~1=!%~1:~1,-1!"
exit /b 0


:lib.dependencies [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=input_string"
set "%~1category=string"
exit /b 0


:doc.man
::  NAME
::      strip_dquotes - remove surrounding double quotes in a variable
::
::  SYNOPSIS
::      strip_dquotes <input_var>
::
::  POSITIONAL ARGUMENTS
::      input_var
::          The input variable name.
::
::  NOTES
::      - Double quotes are stripped only if both ends of the string is a
::        double quote character.
::      - Only one pair of double quotes are stripped.
exit /b 0


:doc.demo
call :input_string string || set string="hello"
set "stripped=!string!"
echo=
call :strip_dquotes stripped
echo String     : !string!
echo Stripped   : !stripped!
exit /b 0


:EOF
exit /b
