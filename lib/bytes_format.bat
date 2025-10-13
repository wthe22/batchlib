:entry_point
call %*
exit /b


:metadata [return_prefix]
set "%~1dependencies= "
set "%~1dev_dependencies=input_number"
set "%~1categories=number"
exit /b 0


:bytes_format <return_var> <bytes>
setlocal EnableDelayedExpansion
set "_return_var=%~1"
set "_bytes=%~2"
set "_result="
set "_remainder=0"
for %%a in (
    "30:GB"
    "20:MB"
    "10:KB"
    "0:bytes"
) do for /f "tokens=1* delims=:" %%b in (%%a) do ( rem
) & if not defined _result (
    set /a "_digits=(!_bytes!) / (1<<%%b)"
    if not "!_digits!" == "0" (
        set "_result=!_digits!"
        if not "%%b" == "0" (
            set /a "_remainder=(!_bytes!) / (1<<(%%b - 10)) %% 1024 * 100 / 1024"
            set "_remainder=00!_remainder!"
            set "_remainder=!_remainder:~-2,2!"
            set "_result=!_result!.!_remainder!"
            set "_result=!_result:~0,4!"
        )
        set "_result=!_result! %%c"
    )
)
if not defined _result set "_result=0 bytes"
set "_result=!_result: .= !"
set "_result=!_result:. = !"
for /f "tokens=1* delims=:" %%q in ("Q:!_result!") do (
    endlocal
    set "%_return_var%=%%r"
)
exit /b 0


:doc.man
::  NAME
::      bytes_format - convert bytes to human readable size
::
::  SYNOPSIS
::      bytes_format <return_var> <bytes>
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the result
::
::      bytes
::          The size in terms of bytes
::
::  NOTES
::      - Only 3 significant figures will be shown
exit /b 0


:doc.demo
call :input_number int_bytes --optional || set "int_bytes=2560"
call :bytes_format readable_size "!int_bytes!"
echo=
echo Int bytes  : !int_bytes!
echo The human readable form is !readable_size!
exit /b 0


:tests.setup
:tests.teardown
exit /b 0


:tests.test_gb
call :tests.try_value ^
    ^ "1073741824: 1.00 GB"
exit /b 0


:tests.test_mb
call :tests.try_value ^
    ^ "1048576: 1.00 MB" ^
    ^ "80740352: 77.0 MB" ^
    ^ "220200960: 210 MB" ^
    ^ "1045430272: 997 MB"
exit /b 0


:tests.test_kb
call :tests.try_value ^
    ^ "1024: 1.00 KB" ^
    ^ "78848: 77.0 KB" ^
    ^ "215040: 210 KB" ^
    ^ "1020928: 997 KB"
exit /b 0


:tests.test_bytes
call :tests.try_value ^
    ^ "0: 0 bytes" ^
    ^ "1: 1 bytes" ^
    ^ "77: 77 bytes" ^
    ^ "210: 210 bytes" ^
    ^ "997: 997 bytes" ^
    ^ "1021: 1021 bytes"
exit /b 0


:tests.test_float_kb_2f
call :tests.try_value ^
    ^ "1025: 1.00 KB" ^
    ^ "1034: 1.00 KB" ^
    ^ "1035: 1.01 KB" ^
    ^ "2037: 1.98 KB" ^
    ^ "2038: 1.99 KB" ^
    ^ "2047: 1.99 KB" ^
    ^ "2048: 2.00 KB"
exit /b 0


:tests.test_float_kb_1f
call :tests.try_value ^
    ^ "10241: 10.0 KB" ^
    ^ "10342: 10.0 KB" ^
    ^ "10343: 10.1 KB" ^
    ^ "11161: 10.8 KB" ^
    ^ "11162: 10.9 KB" ^
    ^ "11263: 10.9 KB" ^
    ^ "11264: 11.0 KB"
exit /b 0


:tests.try_value
for %%a in (%*) do for /f "tokens=1* delims=: " %%b in (%%a) do (
    set "given=%%b"
    set "expected=%%c"
    call :bytes_format result "!given!"
    if not "!result!" == "!expected!" (
        call %unittest% fail "Given '!given!', expected '!expected!', got '!result!'"
    )
)
exit /b 0


:EOF
exit /b
