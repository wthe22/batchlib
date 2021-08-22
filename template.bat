:entry_point  # Beginning of file
@goto main


rem ############################################################################
rem Metadata
rem ############################################################################

:metadata [return_prefix]
set "%~1name=template"
set "%~1version=0"
set "%~1author="
set "%~1license="
set "%~1description=New Script Template"
set "%~1release_date=08/22/2021"   :: mm/dd/YYYY
set "%~1url="
set "%~1download_url="
exit /b 0


rem ############################################################################
rem Configurations
rem ############################################################################

:config
call :config.default
call :config.preference
exit /b 0


:config.default
rem Default/common configurations
exit /b 0


:config.preference
rem Configurations to change/override
exit /b 0


rem ############################################################################
rem Main
rem ############################################################################

:main
@if ^"%1^" == "-c" @goto subcommand.call
@if ^"%1^" == "-h" @goto doc.help
@if ^"%1^" == "--help" @goto doc.help
@goto main_script


:main_script
@setlocal EnableDelayedExpansion EnableExtensions
@echo off
rem TODO: start scripting...
@exit /b


:subcommand.call -c <label> [arguments]
@(
    setlocal DisableDelayedExpansion
    call set command=%%*
    setlocal EnableDelayedExpansion
    for /f "tokens=1* delims== " %%a in ("!command!") do @(
        endlocal
        endlocal
        call %%b
    )
)
@exit /b


rem ############################################################################
rem Documentation
rem ############################################################################

:doc.help
@setlocal EnableDelayedExpansion EnableExtensions
@echo off

echo usage:
echo    Script Name Here.bat
echo        A good documentation to help users how to use this script
exit /b 0


rem ############################################################################
rem Library
rem ############################################################################

:lib.dependencies
rem List libraries you use in this file here:
set "%~1install_requires="

rem Add dependencies to this file by running:
:: cmd /c batchlib.bat build script_name.bat
exit /b 0


rem ############################################################################
rem Tests: Tests codes and data
rem ############################################################################

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
rem DO NOT WRITE ANYTHING YOU NEED TO KEEP BELOW THIS FUNCTION.
rem ANYTHING BEYOND THIS FUNCTION WILL BE REMOVED WHEN ADDING DEPENDENCIES.
exit /b


