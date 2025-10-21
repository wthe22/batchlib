:entry_point
call %*
exit /b


:metadata [return_prefix]
set "%~1dependencies= "
set "%~1dev_dependencies=argparse"
set "%~1categories=network os"
exit /b 0


:get_ipconfig <return_var> [-a adapter] [-f field]
setlocal EnableDelayedExpansion
for %%v in (_return_var _adapters _fields) do set "%%v="
call :argparse --name %0 ^
    ^ "return_var:              set _return_var" ^
    ^ "[-a,--adapter ADAPTER]:  list _adapters" ^
    ^ "[-f,--field FIELD]:      list _fields" ^
    ^ -- %* || exit /b 2
set "_result="
set "_current_adapter="
for /f "usebackq tokens=* delims=" %%o in (`ipconfig /all`) do (
    set "_line=%%o"

    set "_struct="
    set "_key="
    set "_value="
    if "!_line:~0,1!" == " " (
        set "_struct=field"
    ) else set "_struct=adapter"

    if "!_struct!" == "adapter" (
        if "!_line:~-1,1!" == ":" (
            set "_current_adapter=!_line:~0,-1!"
        ) else set "_current_adapter=!_line!"
    )
    if "!_struct!" == "field" (
        for /f "tokens=1* delims=:" %%a in ("!_line!") do (
            set "_key=%%a"
            set "_key=!_key:~3!"
            set "_key=!_key:. =!"
            if "!_key:~-1,1!" == " " set "_key=!_key:~0,-1!"
            if "!_key:~-1,1!" == " " set "_key=!_key:~0,-1!"
            set "_value=%%b"
            set "_value=!_value:~1!"
        )
    )
    set "_capture=true"
    if defined _adapters (
        set "_found="
        for %%a in (!_adapters!) do (
            if "!_current_adapter!" == "%%~a" set "_found=true"
        )
        if not defined _found (
            set "_capture="
        )
    )
    if defined _fields (
        set "_found="
        for %%f in (!_fields!) do (
            if "!_key!" == "%%~f" set "_found=true"
        )
        if not defined _found (
            set "_capture="
        )
    )
    if defined _capture (
        if defined _key (
            set _result=!_result! "!_current_adapter!/!_key!/!_value!"
        ) else set _result=!_result! "!_current_adapter!"
    )
)
for /f "tokens=1* delims=:" %%q in ("Q:!_result!") do (
    endlocal
    set "%_return_var%=%%r"
    if not defined %_return_var% exit /b 3
)
exit /b 0


rem ############################################################################
rem Documentation
rem ############################################################################

:doc.man
::  NAME
::      get_ipconfig - get data from ipconfig
::
::  SYNOPSIS
::      get_ipconfig <return_var> [-a|--adapter ADAPTER] [-f|--field FIELD]
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the result.
::
::      adapter
::          Only get information from the specified adapter. May be specified
::          multiple times to select multiple adapters.
::
::      field
::          Fields to get. May be specified multiple times to get multiple
::          fields at once. If not specified, all available information will
::          be retrieved. Use empty sting to get adapter names only.
::
::  EXIT STATUS
::      0:  - Success
::      1:  - Unknown error
::      2:  - Invalid argument
::      3:  - No matching data
exit /b 0


:doc.demo
call :get_ipconfig result -f ""
echo Network Adapters:
for %%r in (!result!) do (
    echo - %%~r
)
echo=
echo Adapters with Physical Address or IPv4 Addresses:
call :get_ipconfig result -f "Physical Address" -f "IPv4 Address"
for %%r in (!result!) do (
    for /f "tokens=1-2* delims=/" %%a in (%%r) do (
        echo - [%%a] %%b: %%c
    )
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
