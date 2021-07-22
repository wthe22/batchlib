:entry_point  # Beginning of file
call %*
exit /b


:library_name_here [--options] <args>
rem Library name should start with an alphablet. Library name should only
rem contain the characters A-Z, a-z, 0-9, dot '.', and/or dash '-'.
rem The file name should be "<library_name_here>.bat"

rem Use this to run command only in debug mode:
rem %debug% echo Debug mode is ON

rem Library ends with an 'exit' or 'goto' statement, followed by an empty line.
exit /b 0


:lib.build_system [return_prefix]
rem If your libaray have dependencies, write it here. If there isn't any
rem dependencies, just put a space inside.
set "%~1install_requires= "

rem Libraries needed to run demo, tests, etc. If there isn't any, just empty it.
set "%~1extra_requires="

rem Category of the library. Choose ones that fit.
rem Multiple values are supported (each seperated by space)
set "%~1category="
exit /b 0


:doc.man
::  NAME
::      library_name_here - a sample library
::
::  SYNOPSIS
::      library_name_here [--options] <args>
::
::  DESCRIPTION
::      A good library should have a good documentation too!
::
::  EXIT STATUS
::      What the exit code of your function means. Some examples are:
::      0:  - Success
::      1:  - An unexpected error occured
::      2:  - Invalid argument
::      3:  - Other failures/errors/signals
::          - Another possibility...
exit /b 0


:doc.demo
echo A demo to help users understand how to use it
call :library_name_here && (
    echo Success
) || echo Failed...
exit /b 0


:test
rem Run these commands to unittest your function:
:: cmd /c batchlib.bat test <library_name_here>

rem Or use quicktest():
:: cmd /c batchlib.bat debug <library_name_here> :quicktest
rem Run specific unittests
:: cmd /c batchlib.bat debug <library_name_here> :quicktest <label> ...
exit /b 0


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


:EOF  # End of File
rem DO NOT WRITE ANYTHING YOU NEED TO KEEP BELOW THIS FUNCTION.
rem ANYTHING BEYOND THIS FUNCTION WILL BE REMOVED WHEN ADDING DEPENDENCIES.
exit /b


