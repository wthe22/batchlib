:entry_point
call %*
exit /b


:ini_parse <action> <config_file> <key> [var]
setlocal EnableDelayedExpansion
call :argparse2 --name "ini_parse" ^
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
findstr /n "^^" "!_input_file!" > ".ini_parse._numbered" || (
    1>&2 echo%0: Cannot open file '!_input_file!' & exit /b 2
)
for %%v in (_found _value) do (
    if exist ".ini_parse.%%v" del /f /q ".ini_parse.%%v"
)
set _write=^> ".ini_parse._edited"
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
    for /f "usebackq tokens=*" %%o in (".ini_parse._numbered") do (
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
                > ".ini_parse._value" echo(!_value!
            ) else if "!_action!" == "set" (
                echo !_target_key!=!%_value_var%!
                echo true > ".ini_parse._found"
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
    if exist ".ini_parse._found" (
        del /f /q ".ini_parse._found"
    ) else (
        echo !_target_key!=!%_value_var%!
    ) >%_write%
)
if defined _write (
    move /y ".ini_parse._edited" "!_input_file!" > nul || exit /b 3
)
if "!_action!" == "pop" (
    if exist ".ini_parse._value" (
        set /p "_value=" < ".ini_parse._value"
        del /f /q ".ini_parse._value"
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
::      ini_parse - INI configuration file parser and editor
::
::  SYNOPSIS
::      ini_parse <action> ...
::      ini_parse sections <return_var_prefix> <config_file>
::      ini_parse keys <return_var> <config_file> <section>
::      ini_parse get <return_var> <config_file> <section> <key>
::      ini_parse set <value_var> <config_file> <section> <key>
::      ini_parse pop <return_var> <config_file> <section> <key>
::
::  DESCRIPTION
::      A non-destructive INI-style config file editor. It will not remove comments
::      and unknown entries when editing files. It can handle values with special
::      characters, but cannot handle keys and sections with special characters.
::      Multiline values are not supported.
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
::          escape_chars   = NOT EXPANDED. \n will remain as \n
::          inline_comment = NOT SUPPORTED. # THIS IS NOT A COMMENT
::          "quoted=keys"  = NOT SUPPORTED. Function will think that
::          #                the key name is '"quoted', not 'quoted=keys'
::
::          duplicate_key = Behavior: currently it will get 1st,
::          duplicate_key = set all, remove all
::
::          [section is supported]
::
::          lines_without_equal_sign_will_be_ignored
::
::      Assumptions:
::      - Only section can starts with '['
::      - Keys that starts with '[' must be quoted
::        so it starts with '"' or "'" instead
::
::  POSITIONAL ARGUMENTS
::      action
::          Action to do. Possible values:
::              - sections: Get section names
::              - keys: Get keys in a section
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
::      1:  - Unexpected error
::      2:  - Invalid parameters
::          - File not found
::      3:  - Fail to save intermediate parsing data
::      4:  - get/pop: Key not found
::      5:  - set/pop: Fail to apply changes to file
::
::  NOTES
::      - Currently function cannot add a new key to a specific section, it will
::        always add a new key to the last line of the file.
exit /b 0


:doc.demo
cd /d "!tmp_dir!" 2> nul || cd /d "!tmp!"
call :coderender "%~f0" tests.template.demo > "demo.ini"
echo Original configuration file
echo=
type "demo.ini"
echo=---------------------------------------------------------------------------------
for %%v in (food message pi tricky) do (
    call :ini_parse get "demo.ini" %%v result
    echo GET %%v: "!result!"
)
for %%s in ("" "mom" "dad") do (
    call :ini_parse get result "demo.ini" %%s name
    echo GET %%s name: "!result!"
)

set new_value="raspberries are red ^& blueberries are blue^!"
echo SET message: "!new_value!"
call :ini_parse set "demo.ini" message new_value

set "new_value=Minecraft"
echo SET game: !new_value!
call :ini_parse set new_value "demo.ini" dad game

echo POP name
call :ini_parse pop _ "demo.ini" "" name
echo=---------------------------------------------------------------------------------
echo Edited configuration file
echo=
type "demo.ini"
exit /b 0


rem ############################################################################
rem Tests
rem ############################################################################

:tests.setup
call :capchar TAB
call :coderender "%~f0" tests.template.mcsp --compile-only > "mcsp-render.bat" || exit /b 3
call "mcsp-render.bat" > "mcsp.ini" || exit /b 3
call :coderender "%~f0" tests.template.demo > "demo.ini" || exit /b 3
set "result="
exit /b 0


:tests.teardown
exit /b 0


:tests.test_sections
call :ini_parse sections result "demo.ini" || (
    call %unittest% fail "got exit code '!errorlevel!'"
)
set "expected= dad mom"
if not "!result!" == "!expected!" (
    call %unittest% fail
)
exit /b 0


:tests.test_keys
call :ini_parse keys result "demo.ini" "" || (
    call %unittest% fail "got exit code '!errorlevel!'"
)
set "expected= name name message food pi"
if not "!result!" == "!expected!" (
    call %unittest% fail "Fail to get keys without section"
)
call :ini_parse keys result "demo.ini" "dad" || (
    call %unittest% fail "got exit code '!errorlevel!'"
)
set "expected= name message"
if not "!result!" == "!expected!" (
    call %unittest% fail "Fail to get keys with section"
)
exit /b 0


:tests.test_get
call :ini_parse get result "demo.ini" "" food || (
    call %unittest% fail "got exit code '!errorlevel!'"
)
set "expected=Banana"
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_get_none
set "result=asd"
call :ini_parse get result "demo.ini" "" nonexisting && (
    call %unittest% fail "unexpected success"
)
set "expected="
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_get_expanded_chars
call :ini_parse get result "demo.ini" "" tricky || (
    call %unittest% fail "got exit code '!errorlevel!'"
)
set expected==^^^^ ^^^^^^^^ %%0 %%%%^^a ^^!e^^! "^^ ^^^^ %%0 %%%%^a ^!e^!"
if not "!result!" == "!expected!" (
    call %unittest% fail
)
exit /b 0


:tests.test_get_whitespace
call "mcsp-render.bat" motd_whitespace > "mcsp.ini" || exit /b 3
call :ini_parse get result "mcsp.ini" "" motd || (
    call %unittest% fail "got exit code '!errorlevel!'"
)
set "expected=!TAB!Default "
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_set
copy /b /v /y "mcsp.ini" "result" > nul || exit /b 3
set "new_message=Hello"
call :ini_parse set new_message "result" "" motd || (
    call %unittest% fail "got exit code '!errorlevel!'"
)
call "mcsp-render.bat" motd_hello > "expected"
fc /a /lb1 result expected > nul || (
    call %unittest% fail
)
exit /b 0


:tests.test_set_new
copy /b /v /y "mcsp.ini" "result" > nul || exit /b 3
set "new_gamemode=survival"
call :ini_parse set new_gamemode "result" "" gamemode || (
    call %unittest% fail "got exit code '!errorlevel!'"
)
call "mcsp-render.bat" gamemode_survival > "expected" || exit /b 3
fc /a /lb1 result expected > nul || (
    call %unittest% fail
)
exit /b 0


:tests.test_pop
copy /b /v /y "mcsp.ini" "result" > nul || exit /b 3
call :ini_parse pop result "result" "" motd || (
    call %unittest% fail "got exit code '!errorlevel!'"
)
call "mcsp-render.bat" > "motd_removed" || exit /b 3
fc /a /lb1 result expected > nul || (
    call %unittest% fail "Remove key failed"
)
set "expected=Default"
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_ignore_key_spaces
call :ini_parse get result "mcsp.ini" "" allow-flight || (
    call %unittest% fail "got exit code '!errorlevel!'"
)
set "expected=false"
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_ignore_comments
call :ini_parse get result "mcsp.ini" "" "level-name" && (
    call %unittest% fail
)
set "expected="
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected empty, got '!result!'"
)
exit /b 0


:tests.test_ignore_unknown
call :ini_parse get result "mcsp.ini" "" no-value && (
    call %unittest% fail
)
set "expected="
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected empty, got '!result!'"
)
exit /b 0


:tests.test_section
call :ini_parse get result "demo.ini" mom name || (
    call %unittest% fail "got exit code '!errorlevel!'"
)
set "expected=Alice"
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)

call :ini_parse get result "demo.ini" dad name || (
    call %unittest% fail "got exit code '!errorlevel!'"
)
set "expected=Bob"
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:tests.template.mcsp <action>
setlocal EnableDelayedExpansion
set "action=%~1"
::  # Minecraft Server Settings
::  ;level-name=world
::  #pvp=true
if "!action!" == "motd_removed" (
    rem Deleted - Nothing
) else if "!action!" == "motd_hello" (
::  motd=Hello
) else if "!action!" == "motd_whitespace" (
    echo motd=!TAB!Default %=REQUIRED=%
) else (
::  motd=Default
)
::  max-players=10
::  no-value
echo !TAB!  allow-flight!TAB!!TAB! =false
if "!action!" == "gamemode_survival" (
::  gamemode=survival
)
exit /b 0


:tests.template.demo
::  # This is a comment
::  ; This is also a comment
::  name=Charlie
::  name=Carol
::  message="roses are red, violets are blue"
::  food=Banana
::    pi   = 3.14159
::  tricky==^ ^^ %0 %%a !e! "^ ^^ %0 %%a !e!"
::
::  [dad]
::  name=Bob
::  message=Security is important
::
::  [mom]
::  name=Alice
exit /b 0
exit /b 0

rem ############################################################################
rem End of File
rem ############################################################################

:EOF
@rem DO NOT WRITE ANYTHING YOU NEED TO KEEP BELOW THIS FUNCTION.
@rem ANYTHING BEYOND THIS FUNCTION WILL BE REMOVED WHEN ADDING DEPENDENCIES.
exit /b
