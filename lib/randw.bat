:entry_point
call %*
exit /b


:randw <return_var> <weight ...>
set "%~1="
setlocal EnableDelayedExpansion
set "_sum=0"
for %%n in (%~2) do set /a "_sum+=%%~n"
set /a "_rand=((!random!<<16) + (!random!<<1) + (!random!>>14)) %% !_sum!"
set "_sum=0"
set "_index=0"
set "_result="
for %%n in (%~2) do if not defined _result (
    set /a "_sum+=%%n"
    if !_rand! LSS !_sum! set "_result=!_index!"
    set /a "_index+=1"
)
if not defined _result set "_result=-1"
for /f "tokens=*" %%r in ("!_result!") do (
    endlocal
    set "%~1=%%r"
)
exit /b 0


:lib.dependencies [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=input_string"
set "%~1category=number"
exit /b 0


:doc.man
::  NAME
::      randw - select random option based on weights
::
::  SYNOPSIS
::      randw <return_var> <weight ...>
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the result. It returns the index number of the
::          option (i.e. the first option is 0, the second option is 1, etc.).
::
::      weight
::          The weight of the options. There should be at least 1 weight.
::
::  NOTES
::      - Based on: rand()
::
::  LIMITATIONS
::      - Does not generate uniform random numbers (modulo bias)
::      - Incapable of generating high quality random numbers
exit /b 0


:doc.demo
call :input_string weights || set "weights=1 4 9"

echo=
echo Weights    : !weights!
echo Random Number:
for /l %%n in (1,1,5) do (
    call :randw random_int "!weights!"
    echo %%n: !random_int!
)
exit /b 0


:EOF
exit /b
