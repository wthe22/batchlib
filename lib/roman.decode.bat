:entry_point
call %*
exit /b


:roman.decode <return_var> <roman_numeral>
set "%~1=%~2"
for %%r in (
    IV.4 XL.40 CD.400
    IX.9 XC.90 CM.900
    I.1 V.5 X.10 L.50 C.100 D.500 M.1000
) do set "%~1=!%~1:%%~nr=+%%~xr!"
set /a "%~1=!%~1:.=!"
exit /b 0


:lib.dependencies [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=Input.string"
set "%~1category=number"
exit /b 0


:doc.man
::  NAME
::      roman - convert roman numeral to number
::
::  SYNOPSIS
::      roman.decode <return_var> <roman_numeral>
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the result.
::
::      roman_numeral
::          The string that contains roman numeral. Case-insensitive.
exit /b 0


:doc.demo
call :Input.string roman_numeral || set "roman_numeral=MCMLXIX"
echo=
call :roman.decode result !roman_numeral!
echo The decimal value of '!roman_numeral!' is !result!
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
    set "given=%%c"
    set "expected=%%b"
    call :roman.decode result "!given!"
    if not "!result!" == "!expected!" (
        call %unittest% fail "Given '!given!', expected '!expected!', got '!result!'"
    )
)
exit /b 0


:EOF
exit /b
