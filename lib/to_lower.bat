:entry_point  # Beginning of file
call %*
exit /b


:to_lower <input_var>
set "%1= !%1!"
for %%a in (
    a b c d e f g h i j k l m
    n o p q r s t u v w x y z
) do set "%1=!%1:%%a=%%a!"
set "%1=!%1:~1!"
exit /b 0


:lib.build_system [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=Input.string"
set "%~1category=string"
exit /b 0


:doc.man
::  NAME
::      to_lower - convert string to lowercase
::
::  SYNOPSIS
::      to_lower <input_var>
::
::  POSITIONAL ARGUMENTS
::      input_var
::          The input variable name.
exit /b 0


:doc.demo
call :Input.string string || set "string=once UPON a TiMe"
set "result=!string!"
echo=
call :to_lower result
echo String         : !string!
echo Lower case     : !result!
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
    set "given=%%b"
    set "result=!given!"
    call :to_lower result || (
        call %unittest% fail "Given '!given!', got failure"
    )
    set "expected=%%c"
    if not "!result!" == "!expected!" (
        call %unittest% fail "Given '!given!', expected '!expected!', got '!result!'"
    )
)
exit /b 0


:EOF  # End of File
exit /b
