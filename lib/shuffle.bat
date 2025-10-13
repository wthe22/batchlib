:entry_point
call %*
exit /b


:metadata [return_prefix]
set "%~1dependencies=strlen"
set "%~1dev_dependencies=input_string"
set "%~1categories=algorithms"
exit /b 0


:shuffle <input_var>
if defined %~1 (
    setlocal EnableDelayedExpansion
    set "_result=!%~1!"
    call :strlen _length _result
    for /l %%s in (0,1,!_length!) do (
        set /a "_rand=((!random!<<0x10) + (!random!<<0x1) + (!random!>>0xE)) %% (!_length! - %%s + 1)"
        set /a "_index=!_rand!+%%s"
        for %%r in (!_rand!) do for %%i in (!_index!) do (
            set "_result=!_result:~0,%%s!!_result:~%%i!!_result:~%%s,%%r!"
        )
    )
    for /f "tokens=* delims=" %%a in ("!_result!") do (
        endlocal
        set "%~1=%%a"
    )
)
exit /b 0


:doc.man
::  NAME
::      shuffle - shuffle characters in a string
::
::  SYNOPSIS
::      shuffle <input_var>
::
::  POSITIONAL ARGUMENTS
::      input_var
::          The input variable name.
exit /b 0


:doc.demo
call :input_string --optional text
echo=
call :shuffle text
echo Shuffled string:
echo=!text!
exit /b 0


:EOF
exit /b
