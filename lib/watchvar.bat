:entry_point
call %*
exit /b


:watchvar [-i] [-n]
setlocal EnableDelayedExpansion EnableExtensions
cd /d "!tmp_dir!" 2> nul || cd /d "!tmp!"
for %%d in (".watchvar") do (
    if not exist "%%~d" md "%%~d"
    cd /d "%%~d"
)
for %%x in (txt hex) do (
    if exist "old.%%x" del /f /q "old.%%x"
    if exist "latest.%%x" ren "latest.%%x" "old.%%x"
)
(
    endlocal
    set > "%cd%\latest.txt"
    setlocal EnableDelayedExpansion EnableExtensions
    cd /d "%cd%"
)
for %%v in (_init_only _list_names) do set "%%v="
call :argparse --name %0 ^
    ^ "[-i,--initialize]:   set _init_only=true" ^
    ^ "[-n,--name]:         set _list_names=true" ^
    ^ -- %* || exit /b 2
rem Convert to hex and format
call :hexlify "latest.txt" > "latest.hex.tmp"
> "latest.hex" (
    for /f "usebackq tokens=*" %%o in ("latest.hex.tmp") do (
        set "_hex=%%o"
        set "_hex=!_hex:3d=#_!"
        set "_hex=!_hex: =!"
        for /f "tokens=1* delims=#" %%a in ("!_hex!") do (
            set "_hex=%%a 3d %%b"
            set "_hex=!_hex:#=3d!"
            set "_hex=!_hex:_=!"
        )
        echo=!_hex!
    )
)

rem Count variable
set "_var_count=0"
for /f "usebackq tokens=*" %%o in ("latest.hex") do set /a "_var_count+=1"

if defined _init_only (
    echo Initial variables: !_var_count!
    exit /b 0
)

set "_new_sym=+"
set "_deleted_sym=-"
set "_changed_sym=~"
set "_new_hex_=6E6577"
set "_deleted_hex=64656C65746564"
set "_changed_hex=6368616E676564"
set "_states=new deleted changed"

rem Compare variables
for %%s in (!_states!) do set "_%%s_count=0"
> "changes.hex" (
    for /f "usebackq tokens=1-3 delims= " %%a in ("latest.hex") do (
        set "_old_value="
        for /f "usebackq tokens=1-3 delims= " %%x in ("old.hex") do if "%%a" == "%%x" set "_old_value=%%z"
        if defined _old_value (
            if not "%%c" == "!_old_value!" (
                set /a "_changed_count+=1"
                echo !_changed_hex!20 %%a 0D0A
            )
        ) else (
            echo !_new_hex_!20 %%a 0D0A
            set /a "_new_count+=1"
        )
    )
    for /f "usebackq tokens=1 delims= " %%a in ("old.hex") do (
        set "_value_found="
        for /f "usebackq tokens=1 delims= " %%x in ("latest.hex") do if "%%a" == "%%x" set "_value_found=true"
        if not defined _value_found (
            echo !_deleted_hex!20 %%a 0D0A
            set /a "_deleted_count+=1"
        )
    )
)
if exist "changes.txt" del /f /q "changes.txt"
certutil -decodehex "changes.hex" "changes.txt" > nul

if defined _list_names (
    echo Variables: !_var_count!
    for %%s in (!_states!) do if not "!_%%s_count!" == "0" (
         < nul set /p "=[!_%%s_sym!!_%%s_count!] "
        for /f "usebackq tokens=1* delims= " %%a in ("changes.txt") do (
            if "%%a" == "%%s" < nul set /p "=%%b "
        )
        echo=
    )
) else echo Variables: !_var_count! [+!_new_count!/~!_changed_count!/-!_deleted_count!]
exit /b 0


:lib.dependencies [return_prefix]
set "%~1install_requires=argparse hexlify"
set "%~1extra_requires=strlen"
set "%~1category=debug"
exit /b 0


:doc.man
::  NAME
::      watchvar - monitor variable changes in the current script
::
::  SYNOPSIS
::      watchvar [-i] [-n]
::
::  OPTIONS
::      -i, --initialize
::          Initialize variable list. Use this option
::
::      -n, --name
::         Display variable names.
::
::  ENVIRONMENT
::      This function uses:
::      - Temporary files
::
::      Global variables that affects this function:
::      - tmp_dir: Path to store the temporary files
::      - tmp: Fallback path of tmp_dir
::
::  NOTES
::      - Variables that are longer than 2725 characters (variable name + content)
::        are not detectable and treated as undefined.
exit /b 0


:doc.demo
call :watchvar --initialize
for /l %%n in (1,1,5) do (
    for /l %%n in (1,1,10) do (
        set /a "_operation=!random! %% 2"
        set /a "_num=!random! %% 10"
        if "!_operation!" == "0" (
            set "var!_num!="
        ) else set "var!_num!=!random!"
    )
    set "_operation="
    set "_num="
    echo=
    call :watchvar --name
)
exit /b 0


:tests.setup
:tests.teardown
exit /b 0


:tests.test_no_change
call :tests.simulate 0 0 0
exit /b 0


:tests.test_add
call :tests.simulate 2 0 0
exit /b 0


:tests.test_change
call :tests.simulate 0 2 0
exit /b 0


:tests.test_delete
call :tests.simulate 0 0 2
exit /b 0


:tests.test_mixed
call :tests.simulate 3 2 1
exit /b 0


:tests.test_character_length_limit
set "very_long_var=."
for /l %%n in (2,1,52) do set "very_long_var=!very_long_var!%very_long_var%"
for /l %%n in (2,1,52) do set "very_long_var=!very_long_var!%very_long_var%"
for /l %%n in (1,1,8) do set "very_long_var=!very_long_var!."
set "var_spec="
for /f "usebackq" %%v in (`set "very_long_var"`) do set "var_spec=%%v"
call :strlen result_length var_spec
set "var_spec="
set /a "result_length-=1"
set "expected_length=2725"
if not "!result_length!" == "!expected_length!" (
    call %unittest% error "Expected test character length '!expected_length!', got '!result_length!'"
    exit /b 0
)
set "expected_start_count=0"
for /f "usebackq tokens=1 delims==" %%v in (`set`) do set /a "expected_start_count+=1"
call :watchvar --initialize > "initialize"
for /f "usebackq tokens=1* delims=:" %%a in ("initialize") do (
    for /f "tokens=* delims= " %%c in ("%%b") do set "start_count=%%c"
)
if not "!start_count!" == "!expected_start_count!" (
    call %unittest% fail
)
exit /b 0


:tests.simulate   added  changed  deleted
for /l %%n in (1,1,%~1) do set "simulate.added.%%n="
for /l %%n in (1,1,%~2) do set "simulate.changed.%%n=old"
for /l %%n in (1,1,%~3) do set "simulate.deleted.%%n=old"
set "expected_start_count=0"
for /f "usebackq tokens=1 delims==" %%v in (`set`) do set /a "expected_start_count+=1"
call :watchvar --initialize > "initialize"
for /l %%n in (1,1,%~1) do set "simulate.added.%%n=new"
for /l %%n in (1,1,%~2) do set "simulate.changed.%%n=changed"
for /l %%n in (1,1,%~3) do set "simulate.deleted.%%n="
call :watchvar > "changes"
for /f "usebackq tokens=1* delims=:" %%a in ("initialize") do (
    for /f "tokens=* delims= " %%c in ("%%b") do set "start_count=%%c"
)
for /f "usebackq tokens=1* delims=:" %%a in ("changes") do (
    for /f "tokens=1* delims= " %%c in ("%%b") do (
        set "end_count=%%c"
        set "result=%%d"
    )
)
if not "!start_count!" == "!expected_start_count!" (
    call %unittest% fail "Start: expected '!expected_start_count!', got '!start_count!'"
)
set /a "expected_end_count=!expected_start_count! + %~1 - %~3"
if not "!end_count!" == "!expected_end_count!" (
    call %unittest% fail "End: expected '!expected_end_count!', got '!end_count!'"
)
set "expected=[+%~1/~%~2/-%~3]"
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:EOF
exit /b
