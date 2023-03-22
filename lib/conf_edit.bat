:entry_point
call %*
exit /b


:conf_edit <action> <config_file> <key> [var]
setlocal EnableDelayedExpansion
set "_action=%~1"
set "_input_file=%~f2"
set "_target_key=%~3"
set "_value_var=%~4"
set "_action_valid="
for %%a in (get set delete) do (
    if "!_action!" == "%%a" (
        set "_action_valid=true"
    )
)
if not defined _action_valid (
    1>&2 echo%0: Invalid action '!_action!'
)
if not defined _target_key (
    1>&2 echo%0: Key name cannot be empty
)
cd /d "!tmp_dir!" 2> nul || cd /d "!tmp!"
findstr /n "^^" "!_input_file!" > ".conf_edit._numbered" || (
    1>&2 echo%0: Cannot open file '!_input_file!' & exit /b 2
)
if exist ".conf_edit._found" del /f /q ".conf_edit._found"
set _write=^> ".conf_edit._edited"
if "!_action!" == "get" (
    set "_write="
)
%_write% (
    setlocal DisableDelayedExpansion
    for /f "usebackq tokens=*" %%o in (".conf_edit._numbered") do (
        set "_line=%%o"
        setlocal EnableDelayedExpansion
        set "_line=!_line:*:=!"
        set "_key="
        for /f "tokens=*" %%a in ("!_line!") do (
            for /f "tokens=1* delims==" %%k in ("%%a") do set "_key=%%k"
        )
        set "_match="
        if not "!_key:~0,1!" == "#" if not "!_key:~0,1!" == ";" (
            if "!_key!" == "!_target_key!" set "_match=true"
        )
        if defined _match (
            if "!_action!" == "get" (
                for /f "tokens=* delims=" %%k in ("!_target_key!") do (
                    set "_value=!_line:*%%k=!"
                )
                set "_value=!_value:~1!"
                call :endlocal 3 _value:!_value_var!
                exit /b 0
            ) else if "!_action!" == "set" (
                echo !_target_key!=!%_value_var%!
                echo true > ".conf_edit._found"
            )
        ) else (
            if defined _write (
                echo(!_line!
            )
        )
        endlocal
    )
    endlocal
)
if "!_action!" == "get" (
    exit /b 3
)
if "!_action!" == "set" (
    if exist ".conf_edit._found" (
        del /f /q ".conf_edit._found"
    ) else (
        echo !_target_key!=!%_value_var%!
    ) >%_write%
)
if defined _write (
    move /y ".conf_edit._edited" "!_input_file!" > nul || exit /b 3
)
exit /b 0


:lib.dependencies [return_prefix]
set "%~1install_requires=endlocal"
set "%~1extra_requires=coderender"
set "%~1category=file"
exit /b 0


rem ############################################################################
rem Documentation
rem ############################################################################

:doc.man
::  NAME
::      conf_edit - simple config editor
::
::  SYNOPSIS
::      conf_edit <action> <config_file> <key> [var]
::
::  DESCRIPTION
::      A simple config file / ini file editor. Does not support section (yet?).
::      Lines that starts with '#' or ';' are treated as comments.
::
::  POSITIONAL ARGUMENTS
::      action
::          Action to do. Possible values are: get, set, delete.
::
::      config_file
::          Path to the configuration file
::
::      key
::          Key / variable to modify
::
::      var
::          Variable name used as return variable for get, input variable for set.
::
::  EXIT STATUS
::      0:  - Success
::      2:  - Cannot open file
::      3:  - get: Key not found
::          - set/delete: Update file failed
exit /b 0


:doc.demo
echo A demo to help users understand how to use it
call :conf_edit && (
    echo Success
) || echo Failed...
exit /b 0


rem ############################################################################
rem Tests
rem ############################################################################

:tests.setup
call :coderender "%~f0" tests.template.mcsp > "dummy.conf"
set "result="
exit /b 0


:tests.teardown
exit /b 0


:tests.test_get
call :conf_edit get "dummy.conf" motd result || (
    call %unittest% fail "got exit code '!errorlevel!'"
)
set "expected=Default"
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_get_expanded_chars
call :coderender "%~f0" tests.template.mcsp "get_expanded" > "special"
call :conf_edit get "special" motd result || (
    call %unittest% fail "got exit code '!errorlevel!'"
)
set expected==^^^^ ^^^^^^^^ %%0 %%%%^^a ^^!e^^! "^^ ^^^^ %%0 %%%%^a ^!e^!"
if not "!result!" == "!expected!" (
    call %unittest% fail
)
exit /b 0


:tests.test_set
copy /b /v /y "dummy.conf" "result" > nul || exit /b 3
set "new_value_var=Hello"
call :conf_edit set "result" motd new_value_var || (
    call %unittest% fail "got exit code '!errorlevel!'"
)
call :coderender "%~f0" tests.template.mcsp "set" > "expected"
fc /a /lb1 result expected > nul || (
    call %unittest% fail
)
exit /b 0


:tests.test_set_new
copy /b /v /y "dummy.conf" "result" > nul || exit /b 3
set "new_value_var=survival"
call :conf_edit set "result" gamemode new_value_var || (
    call %unittest% fail "got exit code '!errorlevel!'"
)
call :coderender "%~f0" tests.template.mcsp "set_new" > "expected"
fc /a /lb1 result expected > nul || (
    call %unittest% fail
)
exit /b 0


:tests.test_delete
copy /b /v /y "dummy.conf" "result" > nul || exit /b 3
call :conf_edit delete "result" motd result || (
    call %unittest% fail "got exit code '!errorlevel!'"
)
call :coderender "%~f0" tests.template.mcsp "delete" > "expected"
fc /a /lb1 result expected > nul || (
    call %unittest% fail
)
exit /b 0


:tests.test_ignore
call :conf_edit get "dummy.conf" #generator-settings result && (
    call %unittest% fail
)
set "expected="
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected empty, got '!result!'"
)
exit /b 0


:tests.template.mcsp <action>
setlocal EnableDelayedExpansion
set "action=%~1"
::  # Minecraft Server Settings
::  #generator-settings={}
::  level-name=world
if "!action!" == "delete" (
    rem Nothing
) else if "!action!" == "set" (
::  motd=Hello
) else if "!action!" == "get_expanded" (
::  motd==^ ^^ %0 %%a !e! "^ ^^ %0 %%a !e!"
) else (
::  motd=Default
)
::  pvp=true
::  max-players=10
::  online-mode=false
::  level-type=minecraft\:normal
if "!action!" == "set_new" (
::  gamemode=survival
)
exit /b 0


rem ############################################################################
rem End of File
rem ############################################################################

:EOF
@rem DO NOT WRITE ANYTHING YOU NEED TO KEEP BELOW THIS FUNCTION.
@rem ANYTHING BEYOND THIS FUNCTION WILL BE REMOVED WHEN ADDING DEPENDENCIES.
exit /b
