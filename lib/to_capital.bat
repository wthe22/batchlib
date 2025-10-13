:entry_point
call %*
exit /b


:metadata [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=input_string"
set "%~1category=string"
exit /b 0


:to_capital <input_var>
set "%1= !%1!"
for %%a in (
    A:a B:b C:c D:d E:e F:f G:g H:h I:i J:j K:k L:l M:m
    N:n O:o P:p Q:q R:r S:s T:t U:u V:v W:w X:x Y:y Z:z
) do for /f "tokens=1,2 delims=:" %%b in ("%%a") do (
    set "%1=!%1:%%c=%%c!"
    set "%1=!%1: %%b= %%b!"
)
set "%1=!%1:~1!"
exit /b 0


:doc.man
::  NAME
::      to_capital - convert string to capital case
::
::  SYNOPSIS
::      to_capital <input_var>
::
::  POSITIONAL ARGUMENTS
::      input_var
::          The input variable name.
exit /b 0


:doc.demo
call :input_string --optional string || set "string=once UPON a TiMe"
set "result=!string!"
echo=
call :to_capital result
echo String         : !string!
echo Capital case   : !result!
exit /b 0


:tests.setup
:tests.teardown
exit /b 0


:tests.test_result
for %%a in (
    "Abc Def Ghi Jkl Mno Pqr Stuv Wxyz:abc DEF Ghi jKL MNo pQr StUv WxyZ"
    "@#$&()-_=+[]{}|\;<>/,. :@#$&()-_=+[]{}|\;<>/,. "
) do for /f "tokens=1* delims=:" %%b in (%%a) do (
    set "given=%%c"
    set "result=!given!"
    call :to_capital result || (
        call %unittest% fail "Given '!given!', got failure"
    )
    set "expected=%%b"
    if not "!result!" == "!expected!" (
        call %unittest% fail "Given '!given!', expected '!expected!', got '!result!'"
    )
)
exit /b 0


:EOF
exit /b
