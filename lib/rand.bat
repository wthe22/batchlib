:entry_point
call %*
exit /b


:metadata [return_prefix]
set "%~1dependencies= "
set "%~1dev_dependencies=input_number"
set "%~1categories=number"
exit /b 0


:rand <return_var> <minimum> <maximum>
set /a "%~1=((!random!<<16) + (!random!<<1) + (!random!>>14)) %% ((%~3)-(%~2)+1) + (%~2)"
exit /b 0


:doc.man
::  NAME
::      rand - generate random number within a range
::
::  SYNOPSIS
::      rand <return_var> <minimum> <maximum>
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the result.
::
::      minimum
::          Minimum value (inclusive) of the random number.
::
::      maximum
::          Maximum value (inclusive) of the random number.
::
::  LIMITATIONS
::      - Does not generate uniform random numbers (modulo bias)
::      - Incapable of generating high quality random numbers
exit /b 0


:doc.demo
call :input_number minimum --range "0~2147483647" --optional || set "minimum=-9"
call :input_number maximum --range "0~2147483647" --optional || set "maximum=99"
echo=
echo Random number from !minimum! to !maximum!:
for /l %%n in (1,1,5) do (
    call :rand random_int !minimum! !maximum!
    echo %%n: !random_int!
)
exit /b 0


rem ======================== notes ========================

rem Generate random number from -2^31 to 2^31-1:
set /a "%~1=(!random!<<17 + !random!<<2 + !random!>>13) %% ((%~3)-(%~2)+1) + (%~2)"


:EOF
exit /b
