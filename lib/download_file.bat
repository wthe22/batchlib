:entry_point
call %*
exit /b


:download_file <url> <save_path>
if exist "%~2" del /f /q "%~2"
if not exist "%~dp2" md "%~dp2"
powershell -Command "(New-Object Net.WebClient).DownloadFile('%~1', '%~2')"
if not exist "%~2" exit /b 1
exit /b 0


:lib.dependencies [return_prefix]
set "%~1install_requires=ext_powershell"
set "%~1extra_requires=input_string input_path"
set "%~1category=net"
exit /b 0


:doc.man
::  NAME
::      download_file - download file from the internet
::
::  SYNOPSIS
::      download_file <url> <save_path>
::
::  POSITIONAL ARGUMENTS
::      url
::          The download link.
::
::      save_path
::          The save location of the file.
::
::  ENVIRONMENT
::      cd
::          Affects the base path of save_path if relative path is given.
::
::  NOTES
::      - PowerShell is used to download the file.
::      - Download is buffered to disk.
::      - Follows redirects automatically.
::      - Overwrites existing file.
::      - Supports HTTP, HTTPS, FTP.
exit /b 0


:doc.demo
echo For this demo, file will be saved to "!cd!"
echo Enter nothing to download the logo of Git (1.87 KB on Sept 2021)
echo=
call :input_string --optional download_url || set "download_url=https://git-scm.com/images/logo.png"
call :input_path --file --optional save_path || set "save_path=logo.png"
echo=
echo Download url:
echo=!download_url!
echo=
echo Save path:
echo=!save_path!
echo=
echo Downloading file...
call :download_file "!download_url!" "!save_path!" && (
    echo Download success
)|| echo Download failed
exit /b 0


rem ======================== notes ========================

rem Alternative command, but blocked by windows defender
certutil -urlcache -split -f "%~2" "!_save_path!\!_filename!"


:EOF
exit /b
