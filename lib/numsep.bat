:entry_point
call %*
exit /b


:metadata [return_prefix]
set "%~1dependencies= "
set "%~1dev_dependencies=input_string"
set "%~1categories="
exit /b 0


:numsep <return_var> <number>
setlocal EnableDelayedExpansion
set "_return_var=%~1"
set "_num=%~2"
for /f "tokens=1* delims=." %%a in ("!_num!") do (
    set "_whole=%%a"
    set "_frac=%%b"
)
set "_result="
for /l %%n in (0,3,12) do (
    if defined _whole (
        set "_result=!_whole:~-3,3!,!_result!"
        set "_whole=!_whole:~0,-3!"
    )
)
set "_result=!_result:-,=-!"
set "_result=!_result:~0,-1!"
if defined _frac (
    set "_result=!_result!.!_frac!"
)
for %%r in ("!_result!") do (
    endlocal
    set "%_return_var%=%%~r"
)
exit /b 0


rem ############################################################################
rem Documentation
rem ############################################################################

:doc.man
::  NAME
::      numsep - add thousands separators to a number
::
::  SYNOPSIS
::      numsep <return_var> <number>
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the result.
::
::      number
::          The number to process. Decimals and negative numbers are supported.
::
::  EXIT STATUS
::      0:  - Success
::      1:  - An unexpected error occured
exit /b 0


:doc.demo
call :input_string --optional number || (
    set "number=!random!"
    if !random! LSS 10000 set "number=!number!!random!"
    if !random! LSS 10000 set "number=!number!.!random:~0,1!!random:~4!"
    if !random! LSS 10000 set "number=-!number!"
)
echo=
echo Number     : !number!
call :numsep result "!number!"
echo Formatted  : !result!
exit /b 0


rem ############################################################################
rem Tests
rem ############################################################################


:tests.setup
rem Called before running any tests here
exit /b 0


:tests.teardown
rem Called after running all tests here. Useful for cleanups.
exit /b 0


:tests.test_whole
call :tests.check_conversion ^
    ^ "1=1" ^
    ^ "21=21" ^
    ^ "321=321" ^
    ^ "4,321=4321" ^
    ^ "54,321=54321" ^
    ^ "654,321=654321" ^
    ^ "7,654,321=7654321" ^
    ^ "87,654,321=87654321" ^
    ^ "987,654,321=987654321" ^
    ^ "1,234,567,890=1234567890" ^
    ^ "11,234,567,890=11234567890" ^
    ^ %=end=%
exit /b 0


:tests.test_frac
call :tests.check_conversion ^
    ^ "1.0=1.0" ^
    ^ "21.9=21.9" ^
    ^ "321.00=321.00" ^
    ^ "4,321.99=4321.99" ^
    ^ %=end=%
exit /b 0


:tests.test_negative
call :tests.check_conversion ^
    ^ "-1=-1" ^
    ^ "-21=-21" ^
    ^ "-321=-321" ^
    ^ "-4,321=-4321" ^
    ^ %=end=%
exit /b 0


:tests.check_conversion <expected=args> [...]
for %%a in (
    %*
) do for /f "tokens=1* delims==" %%b in (%%a) do (
    call :numsep result "%%c" || (
        call %unittest% fail "Given '%%c', got failure"
    )
    set "expected=%%b"
    if not "!result!" == "!expected!" (
        call %unittest% fail "Given '%%c', expected '!expected!', got '!result!'"
    )
)
exit /b 0


rem ############################################################################
rem End of File
rem ############################################################################

:EOF
@rem DO NOT WRITE ANYTHING YOU NEED TO KEEP BELOW THIS FUNCTION.
@rem ANYTHING BEYOND THIS FUNCTION WILL BE REMOVED WHEN ADDING DEPENDENCIES.
@exit /b
