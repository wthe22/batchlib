:entry_point > nul 2> nul
call %*
exit /b


:sprintrow <buffer_var> <seperator> <cell_sizes> <text> [...]
setlocal EnableDelayedExpansion
set "_result="
set "_spaces= "
for /l %%n in (1,1,8) do set "_spaces=!_spaces!!_spaces!"
set "_seperator="
for %%l in (%~3) do (
    call set "_value=%%~4"
    if %%l GTR 0 (
        set "_value=!_value!!_spaces!"
        set "_value=!_value:~0,%%l!"
    ) else if %%l LSS 0 (
        set "_value=!_spaces!!_value!"
        set "_value=!_value:~%%l!"
    )
    set "_result=!_result!!_seperator!!_value!"
    if not defined _seperator set "_seperator=%~2"
    shift /4
)
for /f "tokens=* delims=" %%a in ("!%~1!!_result!") do (
    endlocal
    set "%~1=%%a"
)
exit /b 0


:lib.build_system [return_prefix]
set "%~1install_requires= "
set "%~1category=string"
exit /b 0


:doc.man
::  NAME
::      sprintrow - write formatted row data to variable
::
::  SYNOPSIS
::      sprintrow <buffer_var> <seperator> <cell_sizes> <text> [...]
::
::  POSITIONAL ARGUMENTS
::      buffer_var
::          The variable name to append the results.
::
::      seperator
::          The string to seperate each cell
::
::      cell_sizes
::          Size of each cells. The maximum size is 256.
::          - Positive    : Left justify
::          - Negative    : Right justify
::          - Zero        : No justify and padding
::
::      text
::          Text for each cells
exit /b 0


:doc.demo
set "seperator= | "
set "column_sizes="
set "item_1.name=Big Mac"
set "item_1.price=$3.99"
set "item_1.stock=999"
set "item_2.name=French Fries (L)"
set "item_2.price=$1.98"
set "item_2.stock=50"

echo ==================== Table View ====================
set "display="
call :sprintrow display ^
    ^ " | " "-3 20 7 6" ^
    ^ "#" "Item Name" "Price" "Stock" ^
    ^ %=END=%
echo !display!
for /l %%n in (1,1,2) do (
    set "display="
    call :sprintrow display ^
        ^ " | " "-3 20 -7 -6" ^
        ^ "%%n" ^
        ^ "!item_%%n.name!" ^
        ^ "!item_%%n.price!" ^
        ^ "!item_%%n.stock!" ^
        ^ %=END=%
    echo !display!
)
echo=

echo ==================== Split Column View ====================
set "column_sizes=12 2 12 12 2 12"
for /l %%n in (1,1,2) do (
    set "display="
    call :sprintrow display ^
        ^ "" "12 2 20 12 2 -7" ^
        ^ "Item No." ": " "%%n" ^
        ^ "Price" ": " "!item_%%n.price!" ^
        ^ %=END=%
    echo !display!
    set "display="
    call :sprintrow display ^
        ^ "" "12 2 20 12 2 -7" ^
        ^ "Item name" ": " "!item_%%n.name!" ^
        ^ "Stock" ": " "!item_%%n.stock!" ^
        ^ %=END=%
    echo !display!
    echo=
)
echo=
exit /b 0


:tests.setup
:tests.teardown
exit /b 0


:tests.test_basic
set "result="
call :sprintrow result "#" ^
    ^ "3 -3 5 -5" ^
    ^ "a" "b" " c c " "dddddd"
if not "!result!" == "a  #  b# c c #ddddd" (
    call %unittest% fail
)
exit /b 0


:EOF  # End of File
exit /b
