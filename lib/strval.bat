:entry_point
call %*
exit /b


:strval <return_var> <input_var>
set /a "%~1=0x80000000"
for /l %%i in (31,-1,0) do (
    set /a "%~1+=0x1<<%%i"
    if !%~2! LSS !%~1! set /a "%~1-=0x1<<%%i"
)
exit /b 0


:lib.dependencies [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=Input.string"
set "%~1category=string"
exit /b 0


:doc.man
::  NAME
::      strval - determine the integer value of a string
::
::  SYNOPSIS
::      strval <return_var> <input_var>
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the result.
::
::      input_var
::          The input variable name.
::
exit /b 0


:doc.demo
call :Input.string string || (
    set "string="
    for %%c in (# A - ) do if !random! LSS 8000 (
        set "string=!string!%%c"
    )
    set "string=!string!!random!"
)
echo=
call :strval result string
echo String         : '!string!'
echo Integer value  : !result!
exit /b 0


:EOF
exit /b
