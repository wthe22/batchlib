:entry_point > nul 2> nul
call %*
exit /b


:roman.encode <return_var> <integer>
setlocal EnableDelayedExpansion
set "_return_var=%~1"
set /a "_remainder=%~2"
set "_result="
for %%r in (
    1000.M 900.CM 500.D 400.CD
     100.C  90.XC  50.L  40.XL
      10.X   9.IX   5.V   4.IV   1.I
) do (
    for /l %%m in (%%~nr,%%~nr,!_remainder!) do set "_result=!_result!%%~xr"
    set /a "_remainder%%=%%~nr"
)
set "_result=!_result:.=!"
for /f "tokens=1* delims=:" %%q in ("Q:!_result!") do (
    endlocal
    set "%_return_var%=%%r"
)
exit /b 0


:lib.build_system [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=Input.number"
set "%~1category=number"
exit /b 0


:doc.man
::  NAME
::      roman - convert number to roman numeral
::
::  SYNOPSIS
::      roman.encode <return_var> <integer>
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the result.
::
::      integer
::          The integer to convert. The valid range is from 1 to 3999.
exit /b 0


:doc.demo
call :Input.number number --range "1~3999" --optional || set /a "number=!random!/9"
echo=
call :roman.encode result !number!
echo The roman numeral value of '!number!' is !result!
exit /b 0


:tests.setup
:tests.teardown
exit /b 0


:tests.test_all
for %%a in (
    "1111:  MCXI"
    "2222:  MMCCXXII"
    "3333:  MMMCCCXXXIII"
    "444:   CDXLIV"
    "555:   DLV"
    "666:   DCLXVI"
    "777:   DCCLXXVII"
    "888:   DCCCLXXXVIII"
    "999:   CMXCIX"
) do for /f "tokens=1* delims=: " %%b in (%%a) do (
    set "given=%%b"
    set "expected=%%c"
    call :roman.encode result "!given!"
    if not "!result!" == "!expected!" (
        call %unittest% fail "given '!given!', expected '!expected!', got '!result!'"
    )
)
exit /b 0


:EOF  # End of File
exit /b
