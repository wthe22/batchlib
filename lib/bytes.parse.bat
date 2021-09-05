:entry_point
call %*
exit /b


:bytes.parse <return_var> <readable_bytes>
setlocal EnableDelayedExpansion
set "_return_var=%~1"
set "_result=%~2"
for %%b in (bytes byte b) do set "_result=!_result:%%b=!"
for %%c in (
    K.10 M.20 G.30
) do set "_result=!_result:%%~nc=*(1<<%%~xc)!"
set /a "_result=!_result:.=!"
for /f "tokens=1* delims=:" %%q in ("Q:!_result!") do (
    endlocal
    set "%_return_var%=%%r"
)
exit /b 0


:lib.dependencies [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=Input.string"
set "%~1category=number"
exit /b 0


:doc.man
::  NAME
::      bytes - convert human readable size to bytes
::
::  SYNOPSIS
::      bytes decode <return_var> <readable_bytes>
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the result.
::
::      readable_bytes
::          The human readable size. Units and number can be seperated by space.
::          The 'B' is optional (only using 'K' to represent kilobytes is accepted).
::          Decimals are not supported.
exit /b 0


:doc.demo
call :Input.string readable_bytes || set "readable_bytes=2 K"
call :bytes.parse bytes "!readable_bytes!"
echo=
echo Readable bytes: !readable_bytes!
echo The size is !bytes! bytes
exit /b 0


:tests.setup
:tests.teardown
exit /b 0


:tests.test_gb
call :tests.try_value ^
    ^ "1073741824: 1 GB"
exit /b 0


:tests.test_mb
call :tests.try_value ^
    ^ "1048576: 1 MB" ^
    ^ "1045430272: 997 MB"
exit /b 0


:tests.test_kb
call :tests.try_value ^
    ^ "1024: 1 KB" ^
    ^ "1020928: 997 KB"
exit /b 0


:tests.test_bytes
call :tests.try_value ^
    ^ "0: 0 bytes" ^
    ^ "997: 997 bytes" ^
    ^ "1021: 1021 bytes"
exit /b 0


:tests.test_mix
call :tests.try_value ^
    "1076892679: 1G+3M+5K+7"
exit /b 0


:tests.try_value
for %%a in (%*) do for /f "tokens=1* delims=: " %%b in (%%a) do (
    set "given=%%c"
    set "expected=%%b"
    call :bytes.parse result "!given!"
    if not "!result!" == "!expected!" (
        call %unittest% fail "Given '!given!', expected '!expected!', got '!result!'"
    )
)
exit /b 0


:EOF
exit /b
