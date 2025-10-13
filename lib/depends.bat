:entry_point
call %*
exit /b


:metadata [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=input_string"
set "%~1category=algorithms"
exit /b 0


:depends <return_var> <items> <get_cmd_var>
setlocal EnableDelayedExpansion
set "_return_var=%~1"
set "_items=%~2"
set "_get_cmd_var=%~3"
set "_get_cmd=!%_get_cmd_var%!"
if not defined _get_cmd (
    1>&2 echo%0: get_cmd_var '!_get_cmd_var!' does not contain any commands
    exit /b 2
)
set "_result= "
set "_stack="
set "_errorlevel=0"
call :depends._visit "!_items!"
for /f "tokens=1* delims=:" %%q in ("Q:!_result!") do (
    endlocal
    set "%_return_var%=%%r"
    if "%%r" == " " set "%_return_var%="
    exit /b %_errorlevel%
)
exit /b 1
#+++

:depends._visit <items>
set "_reversed_items="
for %%i in (%~1) do set "_reversed_items=%%i !_reversed_items!"
for %%i in (!_reversed_items!) do (
    set "_stack=%%i !_stack!"
    set "_visit=true"
    if not "!_stack: %%i =!" == "!_stack!" (
        1>&2 echo%0: Cyclic dependency detected in stack: !_stack!
        set /a "_errorlevel|=0x4"
        set "_visit="
    )
    if not "!_result: %%i =!" == "!_result!" set "_visit="
    if defined _visit for %%r in (_dependencies) do (
        set "%%r="
        ( %_get_cmd% ) && (
            call :depends._visit "!%%r!"
        ) || (
            1>&2 echo%0: Failed to resolve dependency in stack: !_stack!
            set /a "_errorlevel|=0x2"
        )
    )
    if "!_result: %%i =!" == "!_result!" set "_result= %%i!_result!"
    for /f "tokens=1*" %%a in ("!_stack!") do set "_stack=%%b"
)
exit /b 0


rem ############################################################################
rem Documentation
rem ############################################################################

:doc.man
::  NAME
::      depends - dependency solver
::
::  SYNOPSIS
::      depends <return_var> <items> <get_cmd_var>
::
::  DESCRIPTION
::      List all dependencies of an item. The items are ordered in a way that
::      its dependencies are always on its right side, never on its left side.
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the result.
::
::      items
::          Items to resolve, each separated by a space.
::
::      get_cmd_var
::          Variable that contains commands to get the direct dependencies of an
::          item. The dependencies must be saved to variable %%r. The name of the
::          item the function is currently checking can be accessed through %%i.
::          Example of the command:
::
::              set get_cmd_var=set ^"%%r=^^!Item_%%i.dependencies^^!^"
::
::  EXIT STATUS
::      0:  - Success
::      1:  - An unexpected error occured
::      2:  - Failed to resolve dependency
::      4:  - Cyclic dependency detected
::      6:  - Status 2 + 4
exit /b 0


:doc.demo
call :tests.mc
for %%i in (!Item.all!) do (
    if "!Item_%%i.dependencies!" == " " (
        echo %%i -- ^(Raw^)
    ) else echo %%i ^<- !Item_%%i.dependencies: = + !
)
echo=
echo Enter items that you want to dependency resolve:
call :input_string --optional items || (
    set "items=pickaxe torch bed"
)
echo=
echo Items: !items!
set resolve_in_var=(for %%v in (Item_%%i.dependencies) do ( ^
    ^ if defined %%v ( set ^"%%r=^^!%%v^^!^" ) else ( set /a 2^> nul ) ^
))
call :depends result "!items!" resolve_in_var

echo Dependencies: !result!
exit /b 0


rem ############################################################################
rem Tests
rem ############################################################################

:tests.setup
set resolve_in_var=for %%v in (Item_%%i.dependencies) do ( ^
    ^ if defined %%v ( set ^"%%r=^^!%%v^^!^" ) else ( set /a 2^> nul ) ^
)
call :tests.mc
exit /b 0


:tests.teardown
exit /b 0


:tests.test_depends
set "given=pickaxe torch bed"
set "expected= pickaxe torch coal stick bed plank wool string "
call :depends result "!given!" resolve_in_var
if not "!result!" == "!expected!" (
    call %unittest% fail "Given '!given!', expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_depends_cyclic
set "Item.all=chichen egg"
set "Item_chicken.dependencies=egg"
set "Item_egg.dependencies=chicken"
set "given=chicken egg"
call :depends result "!given!" resolve_in_var 2> nul && (
    call %unittest% fail "Given '!given!', expected failure, got '!result!'"
)
exit /b 0


:tests.test_depends_unresolvable
set "Item.all=magic"
set "Item_magic.dependencies="
set "given=magic"
call :depends result "!given!" resolve_in_var 2> nul && (
    call %unittest% fail "Given '!given!', expected failure, got '!result!'"
)
exit /b 0


:tests.mc
set "Item.all=pickaxe torch bed plank stick coal wool string"
set "Item_pickaxe.dependencies=plank stick"
set "Item_torch.dependencies=coal stick"
set "Item_bed.dependencies=plank wool"
set "Item_plank.dependencies= "
set "Item_stick.dependencies= "
set "Item_coal.dependencies= "
set "Item_wool.dependencies=string"
set "Item_string.dependencies= "
exit /b 0

rem ############################################################################
rem End of File
rem ############################################################################

:EOF
@rem DO NOT WRITE ANYTHING YOU NEED TO KEEP BELOW THIS FUNCTION.
@rem ANYTHING BEYOND THIS FUNCTION WILL BE REMOVED WHEN ADDING DEPENDENCIES.
@exit /b
