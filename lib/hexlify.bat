:entry_point  # Beginning of file
call %*
exit /b


:hexlify <input_file> <output_file> [--eol hex]
setlocal EnableDelayedExpansion EnableExtensions
for %%v in (_input_file _output_file) do set "%%v="
set "_eol=0d 0a"
call :argparse ^
    ^ "#1:store         :_input_file" ^
    ^ "#2:store         :_output_file" ^
    ^ "-e,--eol:store   :_eol" ^
    ^ -- %* || exit /b 2
for %%v in (_input_file _output_file) do for %%f in ("!%%v!") do set "%%v=%%~ff"
call :strlen _eol_len _eol
cd /d "!tmp!" & ( cd /d "!tmp_dir!" 2> nul )
if exist "raw_hex" del /f /q "raw_hex"
certutil -encodehex "!_input_file!" "raw_hex" > nul || (
    1>&2 echo%0: encode failed exit /b 3
)
rem Group hex according to EOL
> "!_output_file!" (
    set "_hex="
    for /f "usebackq tokens=1*" %%a in ("raw_hex") do (
        set "_input=%%b"
        set "_hex=!_hex! !_input:~0,48!"
        if not "!_hex:~7680!" == "" call :hexlify._format
    )
    call :hexlify._format
    echo=!_hex!
    set "_hex="
)
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
set "%~1install_requires=argparse strlen"
set "%~1extra_requires=Input.path"
set "%~1category=file"
exit /b 0


:doc.man
::  NAME
::      hexlify - convert a file to hex file
::
::  SYNOPSIS
::      hexlify <input_file> <output_file> [--eol hex]
::
::  POSITIONAL ARGUMENTS
::      input_file
::          Path of the input file.
::
::      output_file
::          Path of the output file.
::
::  OPTIONS
::      --eol HEX
::          The EOL of the source file. Each time hexlify encounters HEX, a new
::          line is created at the output file. By default, '0d 0a' is used.
::
::  ENVIRONMENT
::      cd
::          Affects the base path of input_file and output_file
::          if relative path is given.
::
::      tmp_dir
::          Path to store the temporary conversion result.
::
::      temp
::          Fallback path for tmp_dir if tmp_dir does not exist
::
::  EXIT STATUS
::      0:  - Input is successful.
::      2:  - Invalid argument.
::      3:  - Encode failed.
exit /b 0


:doc.demo
call :Input.path --exist --file source_file
call :Input.path --not-exist destination_file
echo=
echo Converting to hex...
call :hexlify "!source_file!" "!destination_file!"
echo Done
exit /b 0


:tests.setup
:tests.teardown
exit /b 0


:tests.test_all
call :hexlify "%~f0" "hexlify.hex"
if exist "hexlify.rebuild" del /f /q "hexlify.rebuild"
certutil -decodehex "hexlify.hex" "hexlify.rebuild" > nul
fc /a /lb1 "%~f0" "hexlify.rebuild" > nul || (
    call %unittest% fail "difference detected"
)
for %%v in (hex rebuild) do del /f /q "hexlify.%%v"
exit /b 0


:EOF  # End of File
exit /b
