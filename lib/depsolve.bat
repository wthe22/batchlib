:entry_point
call %*
exit /b


:depsolve <return_var> <node ...> <get_cmd_var>
setlocal EnableDelayedExpansion
set "_return_var=%~1"
set "_nodes=%~2"
set "_get_cmd_var=%~3"
set "_get_cmd=!%_get_cmd_var%!"
set "_result= "
set "_stack="
set "_errorlevel=0"
call :depsolve._visit "!_nodes!"
for /f "tokens=1* delims=:" %%a in ("Q:!_result!") do (
    endlocal
    set "%_return_var%=%%b"
    if "%%b" == " " set "%_return_var%="
    exit /b %_errorlevel%
)
exit /b 1
#+++

:depsolve._visit <node ...>
set "_reversed_nodes="
for %%n in (%~1) do set "_reversed_nodes=%%n !_reversed_nodes!"
for %%n in (!_reversed_nodes!) do (
    set "_stack=%%n !_stack!"
    set "_visit=true"
    if not "!_stack: %%n =!" == "!_stack!" (
        1>&2 echo%0: Cyclic dependency detected in stack: !_stack!
        set /a "_errorlevel|=0x4"
        set "_visit="
    )
    if not "!_result: %%n =!" == "!_result!" set "_visit="
    if defined _visit for %%r in (_dependencies) do (
        set "%%r="
        %_get_cmd% && (
            call :depsolve._visit "!_dependencies!"
        ) || (
            1>&2 echo%0: Failed to resolve dependency in stack: !_stack!
            set /a "_errorlevel|=0x2"
        )
    )
    if "!_result: %%n =!" == "!_result!" set "_result= %%n!_result!"
    for /f "tokens=1*" %%a in ("!_stack!") do set "_stack=%%b"
)
exit /b 0


:lib.dependencies [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=input_string"
set "%~1category=algorithms"
exit /b 0


rem ############################################################################
rem Documentation
rem ############################################################################

:doc.man
::  NAME
::      depsolve - dependency solver
::
::  SYNOPSIS
::      depsolve <return_var> <node ...> <get_cmd_var>
::
::  DESCRIPTION
::      Resolve dependencies with ordering. The nodes are ordered in a way that
::      its dependencies are always on its right side, never on its left side.
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the result.
::
::      node
::          Nodes to resolve.
::
::      get_cmd_var
::          Variable that contains commands to get the direct dependencies of a
::          node. The dependencies must be saved to variable %%r. The name of the
::          node can be accessed through %%n. For example of the command:
::
::              set get_cmd_var=set ^"%%r=^^!Item_%%n.dependencies^^!^"
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
set resolve_in_var=set ^"%%r=^^!Item_%%n.dependencies^^!^"
call :depsolve result "!items!" resolve_in_var

echo Dependencies: !result!
exit /b 0


rem ############################################################################
rem Tests
rem ############################################################################

:tests.setup
set resolve_in_var=set ^"%%r=^^!Item_%%n.dependencies^^!^"
set resolve_error=set /a 2> nul"
exit /b 0


:tests.teardown
exit /b 0


:tests.test_depends
set "given=pickaxe torch bed"
set "expected= pickaxe torch coal stick bed plank wool string "
call :depsolve result "!given!" resolve_in_var
if not "!result!" == "!expected!" (
    call %unittest% fail "Given '!given!', expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_depends_cyclic
set "Item.all=chichen egg"
set "Item_chicken.dependencies=egg"
set "Item_egg.dependencies=chicken"
set "given=chicken egg"
call :depsolve result "!given!" resolve_in_var 2> nul && (
    call %unittest% fail "Given '!given!', expected failure, got '!result!'"
)
exit /b 0


:tests.test_depends_unresolvable
set "Item.all=magic"
set "Item_magic.dependencies="
set "given=magic"
call :depsolve result "!given!" resolve_error 2> nul && (
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
