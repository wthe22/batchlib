:entry_point
call %*
exit /b


:ini_edit <action> <config_file> <key> [var]
setlocal EnableDelayedExpansion
call :argparse2 --name "ini_edit" ^
    ^ "[-s,--section SECTION]:  set _target_section" ^
    ^ "action:                  set _action" ^
    ^ "config_file:             set _input_file" ^
    ^ "key:                     set _target_key" ^
    ^ "[var]:                   set _value_var" ^
    ^ -- %* || exit /b 2
for %%f in ("!_input_file!") do (
    set "_input_file=%%~ff"
)
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
findstr /n "^^" "!_input_file!" > ".ini_edit._numbered" || (
    1>&2 echo%0: Cannot open file '!_input_file!' & exit /b 2
)
for %%v in (_found _value) do (
    if exist ".ini_edit.%%v" del /f /q ".ini_edit.%%v"
)
set _write=^> ".ini_edit._edited"
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
    for /f "usebackq tokens=*" %%o in (".ini_edit._numbered") do (
        set "_line=%%o"
        setlocal EnableDelayedExpansion
        set "_line=!_line:*:=!"
        set "_line_stripped=!_line!"
        call :strip _line_stripped

        set "_struct="
        set "_key="

        if "!_line_stripped:~0,1!" == "#" (
            set "_struct=comment"
        ) else if "!_line_stripped:~0,1!" == ";" (
            set "_struct=comment"
        ) else if "!_line_stripped:~0,1!!_line_stripped:~-1,1!" == "[]" (
            set "_struct=section"
        ) else (
            for /f "tokens=1* delims==" %%a in ("!_line_stripped!_") do (
                if not "%%b" == "" set "_struct=key-value"
            )
        )
        if "!_struct!" == "section" (
            set "_section=!_line_stripped:~1,-1!"
            call :strip _section
        )
        if "!_struct!" == "key-value" (
            for /f "tokens=1 delims==" %%k in ("!_line_stripped!") do (
                set "_key=%%k"
                call :strip _key
                set "_value=!_line:*%%k=!"
                set "_value=!_value:~1!"
            )
        )

        set "_match="
        if "!_section!" == "!_target_section!" (
            if "!_key!" == "!_target_key!" (
                set "_match=true"
            )
        )
        if defined _match (
            if "!_action!" == "get" (
                call :endlocal 3 _value:!_value_var!
                exit /b 0
            ) else if "!_action!" == "pop" (
                > ".ini_edit._value" echo(!_value!
            ) else if "!_action!" == "set" (
                echo !_target_key!=!%_value_var%!
                echo true > ".ini_edit._found"
            )
        ) else (
            if defined _write (
                echo(!_line!
            )
        )
        for /f "tokens=1* delims=|" %%a in ("Q|!_section!") do (
            endlocal
            set "_section=%%b"
        )
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
    if exist ".ini_edit._found" (
        del /f /q ".ini_edit._found"
    ) else (
        echo !_target_key!=!%_value_var%!
    ) >%_write%
)
if defined _write (
    move /y ".ini_edit._edited" "!_input_file!" > nul || exit /b 3
)
if "!_action!" == "pop" (
    if exist ".ini_edit._value" (
        set /p "_value=" < ".ini_edit._value"
        del /f /q ".ini_edit._value"
    )
    if defined _value_var (
        call :endlocal 1 _value:!_value_var!
    )
)
exit /b 0


:lib.dependencies [return_prefix]
set "%~1install_requires=argparse2 strip endlocal"
set "%~1extra_requires=coderender"
set "%~1category=file"
exit /b 0


rem ############################################################################
rem Documentation
rem ############################################################################

:doc.man
::  NAME
::      ini_edit - INI file editor
::
::  SYNOPSIS
::      ini_edit <action> <config_file> [-s SECTION] <key> [var]
::      ini_edit get <config_file> [-s SECTION] <key> <return_var>
::      ini_edit set <config_file> [-s SECTION] <key> <value_var>
::      ini_edit pop <config_file> [-s SECTION] <key> [return_var]
::
::  DESCRIPTION
::      A non-destructive INI-style config file editor. It will not remove comments
::      and unknown entries when editing files. It can handle values with special
::      characters, but cannot handle keys and sections with special characters.
::
::      An explanation about how config files are parsed:
::
::          # This is a comment
::          ; This is also a comment
::          key=value
::          quoted="quotes are preserved"
::          value=  <- leading and trailing whitespaces will not be trimmed ->
::
::              indents=IGNORED.            Key name: 'indents'.
::            spaces_around_keys  =IGNORED. Key name: 'spaces_around_keys'
::
::          escape_chars   = NOT SUPPORTED. \n will remain as \n
::          inline_comment = NOT SUPPORTED. # THIS IS NOT A COMMENT
::          "quoted=keys"  = NOT SUPPORTED. Function will think that
::          #                the key name is '"quoted'
::
::          duplicate_key = Behavior: currently it will get 1st,
::          duplicate_key = set all, remove all
::
::          [section is supported]
::          [but section with "^special characters!" arent supported]
::
::          lines_without_equal_sign_will_be_ignored
::
::  OPTIONS
::      -s, --section
::          Section of the key. LIMIATIONS: See NOTES.
::
::  POSITIONAL ARGUMENTS
::      action
::          Action to do. Possible values:
::              - get: Get value of a key
::              - set: Add a new key or edit value of an existing key
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
::
::  NOTES
::      - Currently function cannot add a new key to a specific section, it will
::        always add a new key to the last line of the file.
exit /b 0


:doc.demo
cd /d "!tmp_dir!" 2> nul || cd /d "!tmp!"
call :coderender "%~f0" tests.template.demo > "dummy.conf"
echo Original configuration file
echo=
type "dummy.conf"
echo=---------------------------------------------------------------------------------
for %%v in (food message pi) do (
    call :ini_edit get "dummy.conf" %%v result
    echo GET %%v: "!result!"
)
for %%s in ("" "customer1" "customer2") do (
    call :ini_edit get "dummy.conf" --section %%s name result
    echo GET %%s name: "!result!"
)
set new_value=lets use "roses are red, violets are blue"
echo SET message: "!new_value!"
call :ini_edit set "dummy.conf" message new_value

set "new_value=Minecraft"
echo SET game: !new_value!
call :ini_edit set "dummy.conf" game new_value

echo POP name
call :ini_edit pop "dummy.conf" name
echo=---------------------------------------------------------------------------------
echo Edited configuration file
echo=
type "dummy.conf"
exit /b 0


rem ############################################################################
rem Tests
rem ############################################################################

:tests.setup
call :coderender "%~f0" tests.template.mcsp > "mcsp.conf"
call :coderender "%~f0" tests.template.demo > "demo.conf"
set "result="
exit /b 0


:tests.teardown
exit /b 0


:tests.test_get
call :ini_edit get "mcsp.conf" motd result || (
    call %unittest% fail "got exit code '!errorlevel!'"
)
set "expected=Default"
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_get_expanded_chars
call :coderender "%~f0" tests.template.mcsp "get_expanded" > "special"
call :ini_edit get "special" motd result || (
    call %unittest% fail "got exit code '!errorlevel!'"
)
set expected==^^^^ ^^^^^^^^ %%0 %%%%^^a ^^!e^^! "^^ ^^^^ %%0 %%%%^a ^!e^!"
if not "!result!" == "!expected!" (
    call %unittest% fail
)
exit /b 0


:tests.test_get_whitespace
call :coderender "%~f0" tests.template.mcsp "get_whitespace" > "special"
call :ini_edit get "special" motd result || (
    call %unittest% fail "got exit code '!errorlevel!'"
)
set "expected= Default "
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_set
copy /b /v /y "mcsp.conf" "result" > nul || exit /b 3
set "new_value_var=Hello"
call :ini_edit set "result" motd new_value_var || (
    call %unittest% fail "got exit code '!errorlevel!'"
)
call :coderender "%~f0" tests.template.mcsp "set" > "expected"
fc /a /lb1 result expected > nul || (
    call %unittest% fail
)
exit /b 0


:tests.test_set_new
copy /b /v /y "mcsp.conf" "result" > nul || exit /b 3
set "new_value_var=survival"
call :ini_edit set "result" gamemode new_value_var || (
    call %unittest% fail "got exit code '!errorlevel!'"
)
call :coderender "%~f0" tests.template.mcsp "set_new" > "expected"
fc /a /lb1 result expected > nul || (
    call %unittest% fail
)
exit /b 0


:tests.test_pop
copy /b /v /y "mcsp.conf" "result" > nul || exit /b 3
call :ini_edit pop "result" motd result || (
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
call :ini_edit get "mcsp.conf" allow-flight result || (
    call %unittest% fail "got exit code '!errorlevel!'"
)
set "expected=false"
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_ignore_comments
call :ini_edit get "mcsp.conf" #generator-settings result && (
    call %unittest% fail
)
set "expected="
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected empty, got '!result!'"
)
exit /b 0


:tests.test_ignore_unknown
call :ini_edit get "mcsp.conf" no-value result && (
    call %unittest% fail
)
set "expected="
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected empty, got '!result!'"
)
exit /b 0


:tests.test_section
call :ini_edit get "demo.conf" -s customer1 name result || (
    call %unittest% fail "got exit code '!errorlevel!'"
)
set "expected=Bill"
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)

call :ini_edit get "demo.conf" --section customer2 name result || (
    call %unittest% fail "got exit code '!errorlevel!'"
)
set "expected=Wally"
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
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
) else if "!action!" == "get_whitespace" (
    echo motd= Default %=REQUIRED=%
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
