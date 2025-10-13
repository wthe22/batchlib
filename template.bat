:entry_point
@rem Required by batchlib
@goto main


rem ############################################################################
rem Documentation
rem ############################################################################

:doc.help
rem Optional
rem A good documentation to help users how to use this script
echo usage:
echo    %~nx0 [-h^|--help]
echo=
echo    -h^|--help
echo        Show this help message
exit /b 0

rem ############################################################################
rem Metadata
rem ############################################################################

:metadata [return_prefix]
rem Required by updater
set "%~1name=template"
set "%~1version=0"
set "%~1authors="
set "%~1license="
set "%~1description=New Script Template"
set "%~1release_date=01/07/2024"   :: mm/dd/YYYY
set "%~1url="
set "%~1download_url="

rem Required by batchlib
rem List libraries you use in this file here:
set "%~1install_requires="
exit /b 0


rem Add dependencies to this file by running:
:: cmd /c batchlib.bat build Script-Name-Here.bat

rem ############################################################################
rem Configurations
rem ############################################################################

:config
rem Optional
call :config.default
call :config.preference
exit /b 0


:config.default
rem Default/common configurations
:: set "tmp_dir=!tmp!\!SOFTWARE.name!"
exit /b 0


:config.preference
rem Configurations to change/override
exit /b 0

rem ############################################################################
rem Main
rem ############################################################################

:main
@setlocal EnableDelayedExpansion EnableExtensions
@echo off
if ^"%1^" == "-h" goto doc.help
if ^"%1^" == "--help" goto doc.help
call :metadata SOFTWARE.
call :config
call :main_script
set "exit_code=!errorlevel!"
@exit /b !exit_code!


:main_script
rem TODO: start scripting...
@exit /b

rem ############################################################################
rem Tests
rem ############################################################################

:tests.setup
rem Required by unittest/quicktest
rem Called before running any tests here
rem A fail/error/skip here will abort unittest for this file
exit /b 0


:tests.teardown
rem Called after unittest for this file is done. Useful for cleanups.
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
@rem Required by batchlib
@rem DO NOT WRITE ANYTHING YOU NEED TO KEEP BELOW THIS FUNCTION.
@rem ANYTHING BEYOND THIS FUNCTION WILL BE REMOVED WHEN ADDING DEPENDENCIES.
@exit /b
