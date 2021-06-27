:entry_point  # Beginning of file
call %*
exit /b


:get_pid <return_var> [unique_id]
for /f "usebackq tokens=*" %%a in (
    `wmic process where "name='cmd.exe' and CommandLine like '%% get_pid %random% %~2 %%'" get ParentProcessID`
) do for %%b in (%%a) do set "%~1=%%b"
exit /b 0


:lib.build_system [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=difftime ext.powershell"
set "%~1category=env"
exit /b 0


:doc.man
::  NAME
::      get_pid - get process ID of the current script
::
::  SYNOPSIS
::      get_pid <return_var> [unique_id]
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the result.
::
::      unique_id
::          A string that is uniquely identifies the running batch script.
::          The string should only contain these characters: A-Z, a-z, 0-9,
::          underscore '_', dot '.', and hyphen '-'. By default, it uses %random%.
::
::  NOTES
::      - PowerShell can be used to generate an unique id for current batch script.
::        Use it if you have multiple batch script that starts at the same time and
::        also calls get_pid() at the same time.
exit /b 0


:doc.demo
set "start_time=!time!"
call :get_pid result
call :difftime time_taken "!time!" "!start_time!"
echo Using random number
echo PID        : !result!
echo Time taken : !time_taken!
echo=

set "start_time=!time!"
for /f %%g in ('powershell -command "$([guid]::NewGuid().ToString())"') do call :get_pid result %%g
call :difftime time_taken "!time!" "!start_time!"
echo Using PowerShell GUID
echo PID        : !result!
echo Time taken : !time_taken!
exit /b 0


:EOF  # End of File
exit /b
