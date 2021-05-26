:entry_point > nul 2> nul
call %*
exit /b


:unzip <zip_file> <destination_dir>
setlocal EnableDelayedExpansion
set "_zip_file=%~f1"
set "_dest_path=%~f2"
cd /d "!tmp!" & ( cd /d "!tmp_dir!" 2> nul )
if not exist "!_dest_path!" md "!_dest_path!" || ( 1>&2 echo error: create folder failed & exit /b 2 )
> "unzip.vbs" (
    echo zip_file = WScript.Arguments(0^)
    echo dest_path = WScript.Arguments(1^)
    echo=
    echo set ShellApp = CreateObject("Shell.Application"^)
    echo set content = ShellApp.NameSpace(zip_file^).items
    echo ShellApp.NameSpace(dest_path^).CopyHere(content^)
)
set "success="
cscript //nologo "unzip.vbs" "!_zip_file!" "!_dest_path!" && set "success=true"
del /f /q "unzip.vbs"
if not defined success exit /b 3
exit /b 0


:lib.build_system [return_prefix]
set "%~1install_requires=ext.vbscript"
set "%~1extra_requires=Input.path"
set "%~1category=file"
exit /b 0


:doc.man
::  NAME
::      unzip - extract files from a zip file
::
::  SYNOPSIS
::      unzip <zip_file> <destination_dir>
::
::  POSITIONAL ARGUMENTS
::      zip_file
::          Path of the zip file to extract.
::
::      destination_dir
::          The folder path to extract to.
::
::  ENVIRONMENT
::      cd
::          Affects the base path of input_file and output_file
::          if relative path is given.
::
::      tmp_dir
::          Path to store the temporary VBScript file.
::
::      temp
::          Fallback path for tmp_dir if tmp_dir does not exist
::
::  EXIT STATUS
::      0:  - The path satisfy the requirements.
::      2:  - Create folder failed.
::      3:  - Unzip failed.
::
::  NOTES
::      - VBScript is used to extract the zip file.
::      - Variables in path will not be expanded (e.g.: %%appdata%%).
exit /b 0


:doc.demo
call :Input.path --exist --file zip_file --optional || exit /b 0
call :Input.path --directory destination_folder --optional || exit /b 0
echo=
call :unzip "!zip_file!" "!destination_folder!" && (
    echo Unzip successful
) || (
    echo Unzip failed
)
exit /b 0


:tests.setup
:tests.teardown
exit /b 0


:tests.test_unzip
> "sample.zip.b64" (
    echo UEsDBAoAAAAAAICwuVIAAAAAAAAAAAAAAAALAAAAc3VjY2Vzcy50eHRQSwECPwAK
    echo AAAAAACAsLlSAAAAAAAAAAAAAAAACwAkAAAAAAAAACAAAAAAAAAAc3VjY2Vzcy50
    echo eHQKACAAAAAAAAEAGAAhNtIwd1HXASE20jB3UdcBITbSMHdR1wFQSwUGAAAAAAEA
    echo AQBdAAAAKQAAAAAA
)
certutil -decode "sample.zip.b64" "sample.zip" > nul || (
    call %unittest% error "fail to create zip file"
    exit /b 0
)
if exist "success.txt" del /f /q "success.txt"
call :unzip "sample.zip" "." || (
    call %unittest% fail
    exit /b 0
)
if not exist "success.txt" (
    call %unittest% fail
    exit /b 0
)
exit /b 0


:EOF  # End of File
exit /b
