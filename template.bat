:entry_point
@rem Optional
@goto main


rem ############################################################################
rem Metadata
rem ############################################################################

:metadata [return_prefix]
rem Place to specify metadata for various tools.
rem This function does not need to be callable from the script,
rem because it will be extracted from the script.

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
set "%~1dependencies="
exit /b 0


rem Add dependencies to this file by running:
:: cmd /c batchlib.bat build Script-Name-Here.bat

rem ############################################################################
rem Main
rem ############################################################################

:main
@setlocal EnableDelayedExpansion EnableExtensions
@echo off
rem TODO: start scripting...
@exit /b 0


rem ############################################################################
rem Tests
rem ############################################################################

:tests.setup
rem Required by unittest/quicktest
rem Called before running any tests here
rem A fail/error/skip here will abort unittest for this file
exit /b 0


:tests.teardown
rem Required by unittest/quicktest
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
