
:encode_exec [-h] <file> <key>
@setlocal EnableDelayedExpansion EnableExtensions
for %%v in (
    cli_syntax target_file
) do set "%%v="
call :argparse2 --name "%~n0" ^
    ^ "[-h,--help]:     help cli_syntax" ^
    ^ "file:            set target_file" ^
    ^ "key:             set key_text" ^
    ^ -- %* || exit /b 2
if defined cli_syntax (
    echo usage: call %0 !cli_syntax!
    exit /b 0
)
call :check_path -f -e target_file || exit /b 3
cd /d "!tmp_dir!" 2> nul || cd /d "!tmp!"
set "b64=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
for %%f in ("!target_file!") do 1>&2 echo Size: %%~zf
if not defined key_text (
    1>&2 echo%0: Key cannot be empty
    exit /b 0
)
if "!key_text:~0,13!" == "" (
    1>&2 echo%0: Key too short ^(min 14^)
    exit /b 0
)
if not "!key_text:~48!" == "" (
    1>&2 echo%0: Key too long, using only first 48 characters
)
set "key_text=!key_text:~0,48!"
> "key.txt" (
    echo=!key_text!
)
1>&2 certutil -encode -f "key.txt" "key.b64"
< "key.b64" (
    for /l %%i in (1,1,2) do set /p "key_b64="
)
del /f /q "key.txt" "key.b64"
set "key_padding="
for /l %%n in (1,1,64) do (
    set /a "index=!random! %% 64"
    for %%i in (!index!) do set "key_padding=!key_padding!!b64:~%%i,1!"
)
for /f "tokens=1* delims==" %%k in ("!key_b64!") do (
    set "key_final=!key_padding!%%k"
)
if not "!key_b64:~-1,1!" == "=" (
    set "key_final=!key_final:~1!!key_final:~0,1!"
)
set "key_final=!key_final:~-64,64!"
1>&2 echo Key Text: "!key_text!"
1>&2 echo Key Base64: !key_b64!
1>&2 echo Key Encoded: !key_final!
set "random_name=!random!!random!"
1>&2 copy /b /y /v "!target_file!" "!random_name!"
if exist "!random_name!.cab" del /f /q "!random_name!.cab"
1>&2 makecab "!random_name!" "!random_name!.cab"
del /f /q "!random_name!"
if exist "!random_name!.b64" del /f /q "!random_name!.b64"
1>&2 certutil -encode "!random_name!.cab" "!random_name!.b64"
for /f "usebackq tokens=2 delims=:" %%a in (
    `find /c /v "" "!random_name!.b64"`
) do set /a "lines=%%a"
set /a "offset=!random! %% (!lines! - 3) + 2"
1>&2 echo L: !offset!/!lines!
del /f /q "!random_name!.cab"
call :functions_range _range "%~f0" "encode_exec.by_date" || exit /b 2
call :readline "%~f0" !_range! 1:-1
echo=
set "lineno=0"
for /f "usebackq tokens=*" %%o in ("!random_name!.b64") do (
    set /a "lineno+=1"
    echo %%o
    if "!lineno!" == "!offset!" echo !key_final!
)
del /f /q "!random_name!.b64"
exit /b 0
#+++

:encode_exec.by_date
@setlocal EnableDelayedExpansion
@echo off
for %%f in ("!tmp!\!random!") do @(
    > %%f echo+!date!
    certutil -encode -f %%f "%%~f0"
    < "%%~f0" ( set /p "k=" & set /p "k=" )
    for /f "tokens=1* delims==" %%k in ("!k!") do set "k=%%k"
    ( type "%~f0" | find /v "!k!" %=+=% ) > %%f
    certutil -decode -f %%f "%%~f0" || ( call 2> %%f )
    expand "%%~f0" %%f || (( type %%f | find /v "+") > "%~f0" & call 2> %%f )
    del /f /q "%%~f0" 2> nul
) > nul 2> nul & (
    python %%f %*
    del /f /q %%f 2> nul
    exit /b
)
exit /b
exit /b 0


rem ############################################################################
rem Documentation
rem ############################################################################

:doc.man
::  NAME
::      encode_exec - obfuscate and protect executable
::
::  SYNOPSIS
::      encode_exec [-h] <file> <key>
::
::  DESCRIPTION
::      Executable can only be run on the date it is set.
::      If run on any other date, the executable will partially self destruct.
::
::  POSITIONAL ARGUMENTS
::      file
::          The executable to run.
::
::      key
::          The date to allow execution.
::
::  OPTIONS
::      -h, --help
::          Show usage syntax
::
::  EXIT STATUS
::      0:  - Success
::      1:  - An unexpected error occured
::      2:  - Invalid argument
::      3:  - Other failures/errors/signals
::          - Another possibility...
exit /b 0


:doc.demo
echo A demo to help users understand how to use it
call :lib_template && (
    echo Success
) || echo Failed...
exit /b 0


rem ############################################################################
rem Library
rem ############################################################################

:lib.dependencies [return_prefix]
rem If your libaray have dependencies, write it here. If there isn't any
rem dependencies, just put a space inside.
set "%~1install_requires=argparse2 check_path functions_range readline"

rem Libraries needed to run demo, tests, etc. If there isn't any, just empty it.
set "%~1extra_requires="

rem Category of the library. Choose ones that fit.
rem Multiple values are supported (each seperated by space)
set "%~1category="
exit /b 0


rem ############################################################################
rem Tests
rem ############################################################################

rem Run these commands to unittest your function:
:: cmd /c batchlib.bat test <library name>

rem Or use quicktest():
:: cmd /c batchlib.bat debug <library name> :quicktest
rem Run specific unittests
:: cmd /c batchlib.bat debug <library name> :quicktest <label> ...


:tests.setup
rem Called before running any tests here
exit /b 0


:tests.teardown
rem Called after running all tests here. Useful for cleanups.
exit /b 0


:tests.test_something
rem Do some tests here...
rem And if something goes wrong:
:: call %unittest% fail "Something failed"
:: call %unittest% error "The unexpected happened"
:: call %unittest% skip "No internet detected..."
exit /b 0


rem ############################################################################
rem End of File
rem ############################################################################

:EOF
@rem DO NOT WRITE ANYTHING YOU NEED TO KEEP BELOW THIS FUNCTION.
@rem ANYTHING BEYOND THIS FUNCTION WILL BE REMOVED WHEN ADDING DEPENDENCIES.
exit /b
