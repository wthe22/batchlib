:entry_point
call %*
exit /b


:hex2str <var> ...
setlocal EnableDelayedExpansion
cd /d "!tmp_dir!" 2> nul || cd /d "!tmp!"
set "_var_count=0"
for %%v in (%*) do (
    set /a "_var_count+=1"
    set "_hex2str_!_var_count!=%%v"
)
> ".hex2str._unfilled" (
    for %%v in (%*) do echo set "%%v="
)
call :hexlify ".hex2str._unfilled" > ".hex2str._unfilled.hex"
> ".hex2str.bat.hex" (
    set "_var_count=0"
    for /f "usebackq tokens=* delims=" %%a in (".hex2str._unfilled.hex") do (
        set /a "_var_count+=1"
        for %%i in (!_var_count!) do for %%v in (!_hex2str_%%i!) do (
            set "_hex=%%a"
            echo !_hex:~0,-8!!%%v!!_hex:~-8,8!
        )
    )
)
if exist ".hex2str.bat" del /f /q ".hex2str.bat"
certutil -decodehex ".hex2str.bat.hex" ".hex2str.bat" > nul 2> nul
for %%f in (".hex2str.bat") do (
    endlocal
    call "%%~ff"
)
exit /b 0


:lib.dependencies [return_prefix]
set "%~1install_requires=hexlify"
set "%~1extra_requires="
set "%~1category=string"
exit /b 0


:doc.man
::  NAME
::      hex2str - convert hex to string
::
::  SYNOPSIS
::      hex2str <input_var>
::
::  POSITIONAL ARGUMENTS
::      input_var
::          The input variable name that contains hexadecimal string. Hexadecimal
::          must not start with '0x' and can contain spaces as seperator.
exit /b 0


:doc.demo
set "arrow=2D2D3E"
set "curly=7b 7d"

echo arrow=!arrow!
echo curly=!curly!
echo=
call :hex2str arrow curly
echo arrow=!arrow!
echo curly=!curly!
exit /b 0


:tests.setup
exit /b 0


:tests.teardown
exit /b 0


:tests.test_convert_basic
set "hello=68 65 6c 6c 6f"
set "y2k=79 32 6b"
set "im_ok=69 6d 5f 6f 6b"
set "o.k=6f 2e 6b"
set "var_names=hello y2k im_ok o.k"
call :hex2str !var_names!
for %%v in (!var_names!) do (
    set "expected=%%v"
    set "result=!%%v!"
    if not "!result!" == "!expected!" (
        call %unittest% fail "Expected '!expected!', got '!result!'"
    )
)
exit /b 0


:EOF
@rem DO NOT WRITE ANYTHING YOU NEED TO KEEP BELOW THIS FUNCTION.
@rem ANYTHING BEYOND THIS FUNCTION WILL BE REMOVED WHEN ADDING DEPENDENCIES.
exit /b
