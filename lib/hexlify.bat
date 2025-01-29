:entry_point
call %*
exit /b


:hexlify <input_file> [--eol hex]
setlocal EnableDelayedExpansion EnableExtensions
set "_input_file="
set "_eol=0d 0a"
call :argparse2 --name %0 ^
    ^ "input_file:      set _input_file" ^
    ^ "[-e,--eol HEX]:  set _eol" ^
    ^ -- %* || exit /b 2
for %%f in ("!_input_file!") do set "_input_file=%%~ff"
call :strlen _eol_len _eol
cd /d "!tmp_dir!" 2> nul || cd /d "!tmp!"
if exist ".hexlify._raw_hex" del /f /q ".hexlify._raw_hex"
certutil -encodehex "!_input_file!" ".hexlify._raw_hex" > nul || (
    1>&2 echo%0: encode failed exit /b 3
)
rem Group hex according to EOL
set "_hex="
for /f "usebackq tokens=1*" %%a in (".hexlify._raw_hex") do (
    set "_input=%%b"
    set "_hex=!_hex! !_input:~0,48!"
    if not "!_hex:~7680!" == "" call :hexlify._format
)
call :hexlify._format
echo=!_hex!
exit /b 0
#+++

:hexlify._format
set "_hex=!_hex!$"
set "_hex=!_hex:  = !"
set _hex=!_hex:%_eol%=%_eol%^
%=REQUIRED=%
!
for /f "tokens=*" %%a in ("!_hex!") do (
    set "_hex=%%a"
    if /i "!_hex:~-%_eol_len%,%_eol_len%!" == "%_eol%" echo !_hex!
)
if not "!_hex:~7680!" == "" (
    < nul set /p "=!_hex:~0,-3!"
    set "_hex=!_hex:~-3,3!"
)
set "_hex=!_hex:~0,-1!"
exit /b


:lib.dependencies [return_prefix]
set "%~1install_requires=argparse2 strlen"
set "%~1extra_requires=input_path"
set "%~1category=file"
exit /b 0


:doc.man
::  NAME
::      hexlify - convert a file to hex
::
::  SYNOPSIS
::      hexlify <input_file> [--eol hex]
::
::  DESCRIPTION
::      Convert a file to hexadecimal. Unlike certutil, the output maintains the
::      line number and it only contains hex and whitespaces.
::
::  POSITIONAL ARGUMENTS
::      input_file
::          Path of the input file.
::
::  OPTIONS
::      --eol HEX
::          The EOL of the source file. Each time hexlify encounters HEX, a new
::          line is created at the output file. By default, '0d 0a' is used.
::
::  ENVIRONMENT
::      This function uses:
::      - Temporary files
::
::      Global variables that affects this function:
::      - cd: Base path of files if relative path is given
::      - tmp_dir: Path to store the temporary files
::      - tmp: Fallback path of tmp_dir
::
::  EXIT STATUS
::      0:  - Input is successful.
::      2:  - Invalid argument.
::      3:  - Encode failed.
exit /b 0


:doc.demo
call :input_path --exist --file --optional source_file || exit /b 0
call :input_path --not-exist destination_file || goto doc.demo
echo=
echo Converting to hex...
call :hexlify "!source_file!" > "!destination_file!"
echo Done
exit /b 0


:tests.setup
:tests.teardown
exit /b 0


:tests.test_all
call :hexlify "%~f0" > "hexlify.hex"
if exist "hexlify.rebuild" del /f /q "hexlify.rebuild"
certutil -decodehex "hexlify.hex" "hexlify.rebuild" > nul
fc /a /lb1 "%~f0" "hexlify.rebuild" > nul || (
    call %unittest% fail "difference detected"
)
exit /b 0


:EOF
exit /b
