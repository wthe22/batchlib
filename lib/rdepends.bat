:entry_point
call %*
exit /b


:metadata [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=input_string input_yesno"
set "%~1category=algorithms"
exit /b 0


:rdepends <return_var> <items> <get_cmd_var> <search> [--propagate]
setlocal EnableDelayedExpansion
set "_return_var=%~1"
set "_items=%~2"
set "_get_cmd_var=%~3"
set "_search_items=%~4"
if "%~5" == "--propagate" (
    set "_propagate=true"
) else set "_propagate="
set "_get_cmd=!%_get_cmd_var%!"
if not defined _get_cmd (
    1>&2 echo%0: get_cmd_var '!_get_cmd_var!' does not contain any commands
    exit /b 2
)
set "_result= "
set "_stack="
set "_visited= "
set "_errorlevel=0"
call :rdepends._visit "!_search_items!"
for /f "tokens=1* delims=:" %%q in ("Q:!_result!") do (
    endlocal
    set "%_return_var%=%%r"
    if "%%r" == " " set "%_return_var%="
)
exit /b 0
#+++

:rdepends._visit <items>
for %%i in (%~1) do (
    set "_visit=true"
    if not "!_visited: %%d =!" == "!_visited!" set "_visit="
    if defined _visit (
        set "_found="
        for %%s in (!_items!) do (
            if "%%i" == "%%s" set "_found=true"
        )
        if defined _found (
            for %%s in (!_stack!) do (
                if "!_result: %%s =!" == "!_result!" set "_result= %%s!_result!"
            )
            set "_visit="
        )
    )
    if defined _visit for %%r in (_dependencies) do (
        set "_visited= %%i!_visited!"
        set "%%r="
        ( %_get_cmd% ) && (
            set "_explore="
            if defined _propagate (
                set "_explore=true"
            ) else if not defined _stack set "_explore=true"
            if defined _explore (
                set "_stack=%%i !_stack!"
                call :rdepends._visit "!%%r!"
                for /f "tokens=1*" %%a in ("!_stack!") do set "_stack=%%b"
            )
        ) || (
            1>&2 echo%0: Failed to resolve dependency of '%%i'
            set /a "_errorlevel|=0x2"
            exit /b 2
        )
    )
)
exit /b 0


rem ############################################################################
rem Documentation
rem ############################################################################

:doc.man
::  NAME
::      depsolve - dependency solver
::
::  SYNOPSIS
::      rdepends <return_var> <items> <get_cmd_var> <search> [--propagate]
::
::  DESCRIPTION
::      Check which items depends on an item.
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the result.
::
::      items
::          Items to find in the search, each separated by a space.
::
::      get_cmd_var
::          Variable that contains commands to get the direct dependencies of an
::          item. The dependencies must be saved to variable %%r. The name of the
::          item the function is currently checking can be accessed through %%i.
::          Example of the command:
::
::              call :get_depends %%r %%i
::              
::              :get_depends <return_var> <item>
::              set "%~1=!Item_%~2.dependencies!"
::              exit /b 0
::
::      search
::          List of items to search at, each separated by a space.
::
::  EXIT STATUS
::      0:  - Success
::      1:  - An unexpected error occured
::      2:  - Failed to resolve dependency
exit /b 0


:doc.demo
call :tests.mc
for %%i in (!Item.all!) do (
    if "!Item_%%i.dependencies!" == " " (
        echo %%i -- ^(Raw^)
    ) else echo %%i ^<- !Item_%%i.dependencies: = + !
)
echo=
echo Enter items to find in other item's dependencies:
call :input_string --optional items || (
    set "items=stick"
)
set "params="
call :input_yesno --default y --message "Include indirect dependencies? [Y/n] " && (
    set "params=--propagate"
)
echo=
echo Items: !items!
echo Options: !params!
set resolve_in_var=(for %%v in (Item_%%i.dependencies) do ( ^
    ^ if defined %%v ( set ^"%%r=^^!%%v^^!^" ) else ( set /a 2^> nul ) ^
))
call :rdepends result "!items!" resolve_in_var "!Item.all!" !params!

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
set "given=stick"
set "expected= torch pickaxe "
call :rdepends result "!given!" resolve_in_var "!Item.all!"
if not "!result!" == "!expected!" (
    call %unittest% fail "Given '!given!', expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_depends_propagate
set "given=string"
set "expected= wool "
call :rdepends result "!given!" resolve_in_var "!Item.all!" 2> nul
if not "!result!" == "!expected!" (
    call %unittest% fail "Given '!given!', expected '!expected!', got '!result!'"
)
set "expected= bed wool "
call :rdepends result "!given!" resolve_in_var "!Item.all!" --propagate
if not "!result!" == "!expected!" (
    call %unittest% fail "Given '!given!', expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_depends_unresolvable
set "Item.all=magic"
set "Item_magic.dependencies="
set "given=nonexistent"
call :rdepends result "!given!" resolve_in_var "!Item.all!" 2> nul && (
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
