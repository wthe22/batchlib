:entry_point
call %*
exit /b


:metadata [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires="
set "%~1category=net env"
exit /b 0


:get_net_iface <return_var>
setlocal EnableDelayedExpansion
set "_return_var=%~1"
set LF=^
%=REQUIRED=%
%=REQUIRED=%
set "_result=endlocal!LF!"
for %%v in (_name _desc _mac _ipv4 _type _dhcp_server) do set "%%v=?"
for /f "tokens=* usebackq" %%o in (`ipconfig /all`) do (
    set "_line=%%o"
    if "!_line:~-1,1!" == ":" (
        if not "!_name!" == "?" (
            set "_result=!_result!!_type!|!_name!|!_desc!|!_mac!|!_ipv4!|!_dhcp_server!!LF!"
        )
        for %%v in (_name _desc _mac _ipv4 _type _dhcp_server) do set "%%v=?"
    )
    if "!_line:~-1,1!" == ":" (
        set "_name=!_line:*adapter =!"
        set "_name=!_name:~0,-1!"
        for /f "tokens=1* delims=|" %%a in ("!_line: adapter =|!") do (
            set "_type=%%a"
        )
    )
    if "!_line:~0,11!" == "Description" set "_desc=!_line:~36!"
    if "!_line:~0,16!" == "Physical Address" set "_mac=!_line:~36!"
    if "!_line:~0,12!" == "IPv4 Address" (
        for /f "tokens=1 delims=( " %%a in ("!_line:~36!") do (
            set "_ipv4=%%a"
        )
    )
    if "!_line:~0,30!" == "Autoconfiguration IPv4 Address" set "_ipv4=!_line:~36!"
    if "!_line:~0,11!" == "DHCP Server" set "_dhcp_server=!_line:~36!"
)
if not "!_name!" == "?" (
    set "_result=!_result!!_type!|!_name!|!_desc!|!_mac!|!_ipv4!|!_dhcp_server!!LF!"
)
for /f "tokens=* delims=" %%v in ("!_result!") do ^
if "%%v" == "endlocal" (
    endlocal
) else (
    set %_return_var%=!%_return_var%!%%v^
%=REQUIRED=%
%=REQUIRED=%
)
exit /b 0


rem ############################################################################
rem Documentation
rem ############################################################################

:doc.man
::  NAME
::      get_net_iface - get network interface data (experimental)
::
::  SYNOPSIS
::      get_net_iface <return_var>
::
::  DESCRIPTION
::      The output is arranged in the following format:
::
::          type|name|desc|mac|ipv4!|dhcp_server
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the result.
::
::  EXIT STATUS
::      0:  - Success
exit /b 0


:doc.demo
call :get_net_iface interface_list
for /f "tokens=1-6 delims=|" %%a in ("!interface_list!") do (
    echo [%%b] %%c
    echo MAC            : %%d
    echo IPv4           : %%e
    echo DHCP Server    : %%f
    echo=
)
exit /b 0


rem ############################################################################
rem Tests
rem ############################################################################

:tests.setup
exit /b 0


:tests.teardown
exit /b 0


rem ############################################################################
rem End of File
rem ############################################################################

:EOF
@rem DO NOT WRITE ANYTHING YOU NEED TO KEEP BELOW THIS FUNCTION.
@rem ANYTHING BEYOND THIS FUNCTION WILL BE REMOVED WHEN ADDING DEPENDENCIES.
exit /b
