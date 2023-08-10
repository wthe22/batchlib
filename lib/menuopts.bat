:entry_point
call %*
exit /b


:menuopts (list|get)
exit /b 1
#+++

:menuopts.list <list_var> <text_fmt>
setlocal EnableDelayedExpansion
set "_list_var=%~1"
set "_text_fmt=%~2"
call set "_text_fmt=%%_text_fmt:{=^!%%"
call set "_text_fmt=%%_text_fmt:}=^!%%"
set "_count=0"
for %%n in (!%_list_var%!) do (
    set "_text=!_text_fmt!"
    set /a "_count+=1"
    set "_count=   !_count!"
    for %%i in ("!_count!") do set "_text=!_text:$n=%%~i!"
    set "_text=!_text:$i=%%n!"
    call :menuopts.list._display
)
exit /b 0
#+++

:menuopts.list._display
echo %_text%
exit /b 0
#+++

:menuopts.get <return_var> <list_var> <number>
setlocal EnableDelayedExpansion
set "_return_var=%~1"
set "_list_var=%~2"
set "_number=%~3"
set "_count=0"
set "_result="
for %%n in (!%_list_var%!) do if not defined _result (
    set /a "_count+=1"
    if "!_number!" == "!_count!" set "_result=%%n"
)
for /f "tokens=1* delims= " %%q in ("Q !_result!") do (
    endlocal
    set "%_return_var%=%%r"
    if not defined %_return_var% exit /b 3
)
exit /b 0



:lib.dependencies [return_prefix]
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
::      menuopts - simple menu option listing
::
::  SYNOPSIS
::      menuopts.list <list_var> <text_fmt>
::      menuopts.get <return_var> <list_var> <number>
::
::  DESCRIPTION
::      A good library should have a good documentation too!
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the selected item name.
::
::      list_var
::          Variable that contains a list of item names.
::
::      text_fmt
::          Format of text to display. Supports special formatting.
::              Var     Description
::              ----------------------------
::              $i      Item name
::              $n      Item option number (right alingned, 3 width)
::              {}      Variable to display
::
::      number
::          Item option number
exit /b 0


:doc.demo
set "Food.list=ff cb"
set "Food_ff.name=French Fries"
set "Food_cb.name=Cheese Burger"
call :menuopts.list Food.list "$n. {Food_$i.name}"
call :menuopts.get selected Food.list 1
exit /b 0


rem Run these commands to unittest your function:
:: cmd /c batchlib.bat test <library name>

rem Or use quicktest():
:: cmd /c batchlib.bat debug <library name> :quicktest
rem Run specific unittests
:: cmd /c batchlib.bat debug <library name> :quicktest <label> ...


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


:EOF
@rem DO NOT WRITE ANYTHING YOU NEED TO KEEP BELOW THIS FUNCTION.
@rem ANYTHING BEYOND THIS FUNCTION WILL BE REMOVED WHEN ADDING DEPENDENCIES.
exit /b
