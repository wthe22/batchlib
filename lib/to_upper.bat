:entry_point
call %*
exit /b


:to_upper <input_var>
set "%1= !%1!"
for %%a in (
    A B C D E F G H I J K L M
    N O P Q R S T U V W X Y Z
) do set "%1=!%1:%%a=%%a!"
set "%1=!%1:~1!"
exit /b 0


:lib.dependencies [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=Input.string"
set "%~1category=string"
exit /b 0


:doc.man
::  NAME
::      to_upper - convert string to uppercase
::
::  SYNOPSIS
::      to_upper <input_var>
::
::  POSITIONAL ARGUMENTS
::      input_var
::          The input variable name.
exit /b 0


:doc.demo
call :Input.string string || set "string=once UPON a TiMe"
set "result=!string!"
echo=
call :to_upper result
echo String         : !string!
echo Upper case     : !result!
exit /b 0


:tests.setup
:tests.teardown
exit /b 0


:tests.test_result
for %%a in (
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ:abcdefghijklmnopqrstuvwxyz"
    "ZYXWVUTSRQPONMLKJIHGFEDCBA:zyxwvutsrqponmlkjihgfedcba"
    "@#$&()-_=+[]{}|\;<>/,. :@#$&()-_=+[]{}|\;<>/,. "
) do for /f "tokens=1* delims=:" %%b in (%%a) do (
    set "given=%%c"
    set "result=!given!"
    call :to_upper result || (
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
