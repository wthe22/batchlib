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
for %%a in (get set pop) do (
    if "!_action!" == "%%a" (
        set "_action_valid=true"
    )
)
if not defined _action_valid (
    1>&2 echo%0: Invalid action '!_action!'
    exit /b 2
)
if not defined _target_key (
    1>&2 echo%0: Key name cannot be empty
    exit /b 2
)
if not "!_action!" == "pop" if not defined _value_var (
    1>&2 echo%0: No variable name given
    exit /b 2
)
cd /d "!tmp_dir!" 2> nul || cd /d "!tmp!"
findstr /n "^^" "!_input_file!" > ".conf_edit._numbered" || (
    1>&2 echo%0: Cannot open file '!_input_file!' & exit /b 2
)
for %%v in (_found _value) do (
    if exist ".conf_edit.%%v" del /f /q ".conf_edit.%%v"
)
set _write=^> ".conf_edit._edited"
if "!_action!" == "get" (
    set "_write="
)
set "_read=true"
if "!_action!" == "set" (
    set "_read="
)
set "_section="
%_write% (
    setlocal DisableDelayedExpansion
    for /f "usebackq tokens=*" %%o in (".conf_edit._numbered") do (
        set "_line=%%o"
        setlocal EnableDelayedExpansion
        set "_line=!_line:*:=!"
        set "_line_stripped=!_line!"
        for %%n in (64 32 16 8 4 2 1) do (
            set "_tmp=!_line_stripped:~0,%%n!"
            for /f "tokens=*" %%v in ("!_tmp!_") do (
                if "%%v" == "_" set "_line_stripped=!_line_stripped:~%%n!"
            )
            set "_tmp=!_line_stripped:~-%%n,%%n!"
            for /f "tokens=*" %%v in ("!_tmp!_") do (
                if "%%v" == "_" set "_line_stripped=!_line_stripped:~0,-%%n!"
            )
        )
        set "_skip="
        for /f "tokens=* delims=#;" %%a in ("!_line_stripped:~0,1!") do (
            if "%%a" == "" set "_skip=true"
        )
        if "!_line_stripped:~0,1!!_line_stripped:~-1,1!" == "[]" (
            set "_section=!_line_stripped:~1,-1!"
            set "_skip=true"
        )
        set "_key="
        if not defined _skip (
            for /f "tokens=1* delims==" %%k in ("!_line_stripped!") do (
                if not "%%l" == "" set "_key=%%k"
            )
        )
        if defined _key (
            for %%n in (64 32 16 8 4 2 1) do (
                set "_tmp=!_key:~-%%n,%%n!"
                for /f "tokens=*" %%v in ("!_tmp!_") do (
                    if "%%v" == "_" set "_key=!_key:~0,-%%n!"
                )
            )
        )
        set "_match="
        if "!_key!" == "!_target_key!" set "_match=true"
        if defined _match (
            if defined _read (
                for /f "tokens=* delims=" %%k in ("!_target_key!") do (
                    set "_value=!_line:*%%k=!"
                )
                for %%n in (64 32 16 8 4 2 1) do (
                    set "_tmp=!_value:~0,%%n!"
                    for /f "tokens=*" %%v in ("!_tmp!_") do (
                        if "%%v" == "_" set "_value=!_value:~%%n!"
                    )
                )
                set "_value=!_value:~1!"
            )
            if "!_action!" == "get" (
                call :endlocal 3 _value:!_value_var!
                exit /b 0
            ) else if "!_action!" == "pop" (
                > ".conf_edit._value" echo(!_value!
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
) || (
    1>&2 echo%0: Error when reading from / writting to file
    exit /b 3
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
if "!_action!" == "pop" (
    if exist ".conf_edit._value" (
        set /p "_value=" < ".conf_edit._value"
        del /f /q ".conf_edit._value"
    )
    if defined _value_var (
        call :endlocal 1 _value:!_value_var!
    )
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
::      conf_edit - simple config file editor
::
::  SYNOPSIS
::      conf_edit <action> <config_file> <key> [var]
::      conf_edit get <config_file> <key> <return_var>
::      conf_edit set <config_file> <key> <value_var>
::      conf_edit pop <config_file> <key> [return_var]
::
::  DESCRIPTION
::      A simple, non-destructive config file editor. It will not remove comments
::      and unknown entries when editing files. It can handle special characters.
::      However, it does not support sections (yet?).
::
::      This is an example to show how config files are parsed:
::
::          # This is a comment
::          ; This is also a comment
::          key=value
::          quoted="quotes are preserved"
::              indents=ignored. the key name is 'indents'.
::          food    =the key name is 'food'
::          drinks=   <- value contains leading whitespaces
::          snacks=trailing whitespaces will be stripped ->
::          key=duplicate key. it will get 1st, set all, remove all
::
::          escape_chars=not supported. \n will remain as \n
::          inline_comment=not supported. # this is not a comment
::
::          [section_is_still_unsupported_so_this_will_be_ignored]
::          lines_without_equal_sign_will_be_ignored
::
::  POSITIONAL ARGUMENTS
::      action
::          Action to do. Possible values:
::              - get: Get value of a key
::              - set: Edit value of a key
::              - pop: Remove a key and get the value
::
::      config_file
::          Path to the configuration file
::
::      key
::          Key / variable to modify
::
::      var
::          Usage for each action:
::          - get: Variable to store the value
::          - set: The input variable name
::          - pop: Variable to store the value (optional)
::
::  EXIT STATUS
::      0:  - Success
::      2:  - Invalid parameters
::          - Cannot open file
::      3:  - get: Key not found
::          - set/pop: Update file failed
exit /b 0


:doc.demo
cd /d "!tmp_dir!" 2> nul || cd /d "!tmp!"
call :coderender "%~f0" tests.template.demo > "dummy.conf"
echo Original configuration file
echo=
type "dummy.conf"
echo=---------------------------------------------------------------------------------
for %%v in (food message name pi) do (
    call :conf_edit get "dummy.conf" %%v result
    echo GET %%v: "!result!"
)
set new_value=lets use "roses are red, violets are blue"
echo SET message: "!new_value!"
call :conf_edit set "dummy.conf" message new_value

set "new_value=Minecraft"
echo SET game: !new_value!
call :conf_edit set "dummy.conf" game new_value

echo POP name
call :conf_edit pop "dummy.conf" name
echo=---------------------------------------------------------------------------------
echo Edited configuration file
echo=
type "dummy.conf"
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


:tests.test_pop
copy /b /v /y "dummy.conf" "result" > nul || exit /b 3
call :conf_edit pop "result" motd result || (
    call %unittest% fail "got exit code '!errorlevel!'"
)
call :coderender "%~f0" tests.template.mcsp "pop" > "expected"
fc /a /lb1 result expected > nul || (
    call %unittest% fail "Remove key failed"
)
set "expected=Default"
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_ignore_key_spaces
call :conf_edit get "dummy.conf" allow-flight result || (
    call %unittest% fail "got exit code '!errorlevel!'"
)
set "expected=false"
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_ignore_comments
call :conf_edit get "dummy.conf" #generator-settings result && (
    call %unittest% fail
)
set "expected="
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected empty, got '!result!'"
)
exit /b 0


:tests.test_ignore_unknown
call :conf_edit get "dummy.conf" no-value result && (
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
::  ;generator-settings={}
::  level-name=world
if "!action!" == "pop" (
    rem Deleted - Nothing
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
::  no-value
::     allow-flight  =false
if "!action!" == "set_new" (
::  gamemode=survival
)
exit /b 0


:tests.template.demo
::  # This is a comment
::  ; This is also a comment
::  food=Banana
::  message=raspberries are red & blueberries are blue!
::  name=Jane
::  name=John
::  pi  = 3.14159
::  [customer1]
::  name=Bill
::  message=Food is important
::  [customer2]
::  name=Wally
exit /b 0

rem ############################################################################
rem End of File
rem ############################################################################

:EOF
@rem DO NOT WRITE ANYTHING YOU NEED TO KEEP BELOW THIS FUNCTION.
@rem ANYTHING BEYOND THIS FUNCTION WILL BE REMOVED WHEN ADDING DEPENDENCIES.
exit /b
