:entry_point
call %*
exit /b


:ini_parse <action> <var> <config_file> [section] [key]
setlocal EnableDelayedExpansion
set "_action=%~1"
set "_return_var=%~2"
set "_input_file=%~f3"
set "_target_section=%~4"
set "_target_key=%~5"
cd /d "!tmp_dir!" 2> nul || cd /d "!tmp!"
if "!_action!" == "sections" (
    set "_include=section"
) else if "!_action!" == "keys" (
    set "_include=section key"
) else if "!_action!" == "get" (
    set "_include=section matching_key"
) else if "!_action!" == "set" (
    set "_include=section key"
    set "_value_var=!_return_var!"
    set "_write=true"
) else if "!_action!" == "pop" (
    set "_include=section matching_key"
    set "_write=true"
) else (
    1>&2 echo%0: Invalid action '!_action!'
    exit /b 2
)
if not defined _return_var (
    if not "!_action!" == "pop" (
        1>&2 echo%0: Return / value variable is missing & exit /b 2
    )
)
if not exist "!_input_file!" (
    1>&2 echo%0: File not found: "!_input_file!" & exit /b 2
)
for /f "delims= " %%t in ('robocopy /l . . /njh /njs') do set "TAB=%%t"
call :ini_parse._filter_file !_include! || (
    1>&2 echo%0: Fail to save parsing preparation to file & exit /b 3
)
call :ini_parse._parse > ".ini_parse._data" || (
    1>&2 echo%0: Fail to save parse data to file & exit /b 3
)
if not defined _write (
    call :ini_parse._return_value
    exit /b
)
call :ini_parse._edit_file > ".ini_parse._result" || (
    1>&2 echo%0: Fail to save result to file & exit /b 3
)
move /y ".ini_parse._result" "!_input_file!" > nul || exit /b 5
if "!_action!" == "pop" (
    call :ini_parse._return_value
)
exit /b 0
#+++

:ini_parse._filter_file [components] ...
setlocal EnableDelayedExpansion
set _include=%*
set "_components=comment section key matching_key"
for %%v in (!_components!) do (
    set "_include_%%v="
)
for %%v in (!_include!) do (
    set "_include_%%v=true"
)
set "_search="
if defined _include_comment (
    set _search=!_search! /c:"^^[!TAB! ]*[#;]"
)
if defined _include_section (
    set _search=!_search! /c:"^^[!TAB! ]*\[.*\][!TAB! ]*$"
)
if defined _include_key (
    set _search=!_search! /c:"^^[!TAB! ]*[^^#;\[]]*.*="
)
if defined _include_matching_key (
    set "_escaped_key=!_target_key!"
    for %%c in (\ . $ ^^ [ ]) do (
        set "_escaped_key=!_escaped_key:%%c=\%%c!"
    )
    set _search=!_search! /c:"^^[!TAB! ]*!_escaped_key![!TAB! ]*="
)
findstr /n /r !_search! "!_input_file!" > ".ini_parse._tokens"
exit /b 0
#+++

:ini_parse._parse
setlocal EnableDelayedExpansion
if "!_target_section!" == "" (
    set "_match_section=true"
) else set "_match_section="
set "_insert_line_no="
setlocal DisableDelayedExpansion
for /f "usebackq tokens=*" %%o in (".ini_parse._tokens") do (
    set "_line=%%o"
    setlocal EnableDelayedExpansion
    for /f "tokens=1 delims=:" %%n in ("%%o") do (
        set "_line_no=%%n"
    )
    set "_line=!_line:*:=!"
    set "_line_stripped=!_line!"
    call :strip _line_stripped

    set "_struct="
    set "_key="

    if not defined _line_stripped (
        set "_struct=blank_line"
    ) else if "!_line_stripped:~0,1!" == "#" (
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
        if "!_section!" == "!_target_section!" (
            set "_match_section=true"
        ) else set "_match_section="
    )
    if "!_struct!,!_match_section!" == "key-value,true" (
        for /f "tokens=1 delims==" %%k in ("!_line_stripped!") do (
            set "_key=%%k"
            call :strip _key
            set "_value=!_line:*%%k=!"
            set "_value=!_value:~1!"
        )
        if "!_key!" == "!_target_key!" (
            set "_match_key=true"
        ) else set "_match_key="
    )

    if "!_action!,!_struct!" == "sections,section" (
        echo(!_section!
    )
    if "!_action!,!_match_section!,!_struct!" == "keys,true,key-value" (
        echo(!_key!
    )
    if "!_action!,!_match_section!,!_match_key!" == "get,true,true" (
        echo(!_value!
    )
    if "!_action!,!_match_section!" == "set,true" (
        if "!_struct!" == "key-value" (
            set "_insert_line_no=!_line_no!"
        )
        if "!_match_key!" == "true" (
            echo(!_line_no!
        )
    )
    if "!_action!,!_match_section!,!_match_key!" == "pop,true,true" (
        echo(!_line_no!:!_value!
    )
    set "_serialize="
    for %%v in (_match_section _insert_line_no) do (
        set _serialize=!_serialize! "%%v=!%%v!"
    )
    for /f "tokens=* delims=" %%a in ("!_serialize!") do (
        endlocal
        for %%v in (%%a) do set %%v
    )
)
setlocal EnableDelayedExpansion
if "!_action!" == "set" (
    echo end:!_insert_line_no!
)
exit /b 0
#+++

:ini_parse._return_value
rem TODO: Handle special characters
for %%r in ("!_return_var!") do (
    goto 2> nul
    endlocal
    for %%f in (".ini_parse._data") do (
        if "%%~zf" == "0" (
            if "%_action%" == "get" (
                exit /b 4
            )
            if "%_action%" == "pop" (
                exit /b 4
            )
        )
    )
    set "%%~r="
    for /f "usebackq tokens=* delims=" %%o in (".ini_parse._data") do (
        if "%_action%" == "sections" (
            set "%%~r=!%%~r!%%o!LF!"
        )
        if "%_action%" == "keys" (
            set "%%~r=!%%~r!%%o!LF!"
        )
        if "%_action%" == "get" (
            set "%%~r=%%o"
        )
        if "%_action%" == "pop" (
            set "%%~r=%%o"
            set "%%~r=!%%~r:*:=!"
        )
    )
)
exit /b 0
#+++

:ini_parse._edit_file
findstr /n "^^" "!_input_file!" > ".ini_parse._numbered" || (
    1>&2 echo%0: Fail to save editing preparations to file & exit /b 3
)
set "_target_line="
set "_append="
for /f "usebackq tokens=1* delims=:" %%a in (".ini_parse._data") do (
    if "%%a" == "end" (
        if not defined _target_line (
            set "_append=true"
            set "_target_line=%%b"
        )
    ) else set "_target_line=%%a"
)
if not defined _target_line (
    type "!_input_file!"
    if defined _target_section (
        echo=
        echo([!_target_section!]
    )
    echo(!_target_key!=!%_value_var%!
    exit /b 0
)
setlocal DisableDelayedExpansion
for /f "usebackq tokens=*" %%o in (".ini_parse._numbered") do (
    set "_line=%%o"
    setlocal EnableDelayedExpansion
    for /f "tokens=1 delims=:" %%n in ("%%o") do (
        set "_line_no=%%n"
    )
    set "_line=!_line:*:=!"
    if "!_line_no!" == "!_target_line!" (
        if defined _append (
            echo(!_line!
        )
        if "!_action!" == "set" (
            echo(!_target_key!=!%_value_var%!
        )
    ) else (
        echo(!_line!
    )
    endlocal
)
exit /b 0


:lib.dependencies [return_prefix]
set "%~1install_requires=capchar strip endlocal"
set "%~1extra_requires=coderender list_lf2set"
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
::      and unknown entries when editing files. It cannot handle special
::      characters yet.
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
::          duplicate_key = get last,
::          duplicate_key = set last, pop last
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
call :capchar TAB LF
call :coderender "%~f0" tests.template.demo > "demo.ini"
echo Original configuration file
echo=
type "demo.ini"
echo =================================================================================
echo =================================================================================
call :ini_parse sections section_names "demo.ini"
call :list_lf2set section_names section_names
for /f "tokens=* delims=" %%s in ("""!LF!!section_names!") do (
    echo SECTION: "%%~s"
    call :ini_parse keys key_names "demo.ini" "%%~s"
    call :list_lf2set key_names key_names
    for /f "tokens=* delims=" %%k in ("!key_names!") do (
        call :ini_parse get result "demo.ini" "%%~s" %%k
        echo     GET %%k: "!result!"
    )
)
echo =================================================================================
echo =================================================================================
set new_value="^^^^^^ raspberries are red ^& blueberries are blue^!"
echo SET message: "!new_value!"
call :ini_parse set new_value "demo.ini" "" message

set new_value=Darwin
echo SET name: "!new_value!"
call :ini_parse set new_value "demo.ini" "" name

set "new_value=Minecraft"
echo SET dad games: !new_value!
call :ini_parse set new_value "demo.ini" dad games
echo ---------------------------------------------------------------------------------
echo Edited configuration file
echo=
type "demo.ini"
echo=
echo =================================================================================
echo =================================================================================
echo POP name
call :ini_parse pop _ "demo.ini" "" name
echo POP gpa
call :ini_parse pop _ "demo.ini" "" gpa
echo ---------------------------------------------------------------------------------
echo Edited configuration file
echo=
type "demo.ini"
exit /b 0


rem ############################################################################
rem Tests
rem ############################################################################

:tests.setup
call :capchar TAB LF
call :coderender "%~f0" tests.template.demo --compile-only > "demo-render.bat" || exit /b 3
call "demo-render.bat" > "demo.ini" || exit /b 3
set "result="
exit /b 0


:tests.teardown
exit /b 0


:tests.test_sections
call :ini_parse sections result "demo.ini" || (
    call %unittest% fail "got exit code '!errorlevel!'"
)
set "expected=dad!LF!mom!LF!"
if not "!result!" == "!expected!" (
    call %unittest% fail
)
exit /b 0


:tests.test_keys
call :ini_parse keys result "demo.ini" "" || (
    call %unittest% fail "got exit code '!errorlevel!'"
)
set "expected=name!LF!name!LF!message!LF!GPA!LF!gpa!LF!email!LF!"
set "expected=!expected!whitespace_value!LF!whitespace key!LF!tricky!LF!"
if not "!result!" == "!expected!" (
    call %unittest% fail "Fail to get keys without section"
)
call :ini_parse keys result "demo.ini" "dad" || (
    call %unittest% fail "got exit code '!errorlevel!'"
)
set "expected=name!LF!message!LF!"
if not "!result!" == "!expected!" (
    call %unittest% fail "Fail to get keys with section"
)
exit /b 0


:tests.test_get
call :ini_parse get result "demo.ini" "" email || (
    call %unittest% fail "got exit code '!errorlevel!'"
)
set "expected=dummy@somewhere.com"
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_get_case_sensitive
call :ini_parse get result "demo.ini" "" GPA || (
    call %unittest% fail "got exit code '!errorlevel!'"
)
set "expected=3.14159"
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
call :ini_parse get result "demo.ini" "" gpa || (
    call %unittest% fail "got exit code '!errorlevel!'"
)
set "expected=1.618"
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_get_dupe
call :ini_parse get result "demo.ini" "" name || (
    call %unittest% fail "got exit code '!errorlevel!'"
)
set "expected=Charlie"
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_get_nonexisting
set "expected=!random!"
set "result=!expected!"
call :ini_parse get result "demo.ini" "" nonexisting && (
    call %unittest% fail "unexpected success"
)
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected unmodified '!expected!', got '!result!'"
)
exit /b 0


:tests.test_get_special_chars
call :ini_parse get result "demo.ini" "" tricky || (
    call %unittest% fail "got exit code '!errorlevel!'"
)
set expected==^^^^ ^^^^^^^^ %%0 %%%%^^a ^^!e^^! "^^ ^^^^ %%0 %%%%^a ^!e^!"
if not "!result!" == "!expected!" (
    call %unittest% fail
    echo E:!expected!
    echo R:!result!
)
exit /b 0


:tests.test_get_whitespace
call :ini_parse get result "demo.ini" "" whitespace_value || (
    call %unittest% fail "got exit code '!errorlevel!'"
)
set "expected=!TAB!TAB+Space "
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)

call :ini_parse get result "demo.ini" "" "whitespace key" || (
    call %unittest% fail "got exit code '!errorlevel!'"
)
set "expected=yes"
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_ignore_comments
set "expected=!random!"
set "result=!expected!"
call :ini_parse get result "demo.ini" "" "# address" && (
    call %unittest% fail "Unexpected success"
)
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected unmodified '!expected!', got '!result!'"
)
set "expected=!random!"
set "result=!expected!"
call :ini_parse get result "demo.ini" "" "nothing-here" && (
    call %unittest% fail "Unexpected success"
)
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected unmodified '!expected!', got '!result!'"
)
exit /b 0


:tests.test_ignore_unknown
set "expected=!random!"
set "result=!expected!"
call :ini_parse get result "demo.ini" "" nothing-here && (
    call %unittest% fail "Unexpected success"
)
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected unmodified '!expected!', got '!result!'"
)
exit /b 0


:tests.test_set_existing
copy /b /v /y "demo.ini" "result" > nul || exit /b 3
set my_message="^^^^^^ raspberries are red ^& blueberries are blue^!"
call :ini_parse set my_message "result" "" message || (
    call %unittest% fail "got exit code '!errorlevel!'"
)
call "demo-render.bat" change_msg > "expected" || exit /b 3
fc /a /lb1 result expected > nul || (
    call %unittest% fail
)
exit /b 0


:tests.test_set_nonexisting
copy /b /v /y "demo.ini" "result" > nul || exit /b 3
set "my_number=1223334444"
call :ini_parse set my_number "result" "" phone || (
    call %unittest% fail "got exit code '!errorlevel!'"
)
call "demo-render.bat" add_phone > "expected" || exit /b 3
fc /a /lb1 result expected > nul || (
    call %unittest% fail
)
exit /b 0


:tests.test_pop
copy /b /v /y "demo.ini" "result" > nul || exit /b 3
call :ini_parse pop result "result" "" email || (
    call %unittest% fail "got exit code '!errorlevel!'"
)
call "demo-render.bat" delete_email > "expected" || exit /b 3
set "expected=dummy@somewhere.com"
fc /a /lb1 result expected > nul || (
    call %unittest% fail "Remove key failed"
)
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_section_get
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


:tests.test_section_set_existing
copy /b /v /y "demo.ini" "result" > nul || exit /b 3
set "my_message=Testing..."
call :ini_parse set my_message "result" dad message || (
    call %unittest% fail "got exit code '!errorlevel!'"
)
call "demo-render.bat" change_dad_msg > "expected" || exit /b 3
fc /a /lb1 result expected > nul || (
    call %unittest% fail
)
exit /b 0


:tests.test_section_set_nonexisting
copy /b /v /y "demo.ini" "result" > nul || exit /b 3
set "dad_phone=133355555"
call :ini_parse set dad_phone "result" dad phone || (
    call %unittest% fail "got exit code '!errorlevel!'"
)
call "demo-render.bat" add_dad_phone > "expected" || exit /b 3
fc /a /lb1 result expected > nul || (
    call %unittest% fail
)
exit /b 0


:tests.test_section_set_nonexisting_section
copy /b /v /y "demo.ini" "result" > nul || exit /b 3
set "cast_name=Eve"
call :ini_parse set cast_name "result" eavesdropper name || (
    call %unittest% fail "got exit code '!errorlevel!'"
)
call "demo-render.bat" add_eve > "expected" || exit /b 3
fc /a /lb1 result expected > nul || (
    call %unittest% fail
)
exit /b 0


:tests.template.demo
setlocal EnableDelayedExpansion
set "action=%~1"
::  name=Carol
::  name=Charlie
if "!action!" == "change_msg" (
::  message="^^^ raspberries are red & blueberries are blue!"
) else (
::  message="roses are red, violets are blue"
)
::  GPA=3.14159
::  gpa=1.618
if "!action!" == "delete_email" (
    rem No-op
) else (
::  email=dummy@somewhere.com
)
echo whitespace_value=!TAB!TAB+Space %=REQUIRED=%
echo !TAB!  whitespace key!TAB!!TAB! =yes
::  tricky==^ ^^ %0 %%a !e! "^ ^^ %0 %%a !e!"
if "!action!" == "add_phone" (
::  phone=1223334444
)
::  # address=North Pole
::  ; birthday=2025-02-29
::  nothing-here
::
::  [dad]
::  name=Bob
if "!action!" == "change_dad_msg" (
::  message=Testing...
) else (
::  message=Security is important
)
if "!action!" == "add_dad_phone" (
::  phone=133355555
)
::
::  [mom]
::  name=Alice
if "!action!" == "add_eve" (
::
::  [eavesdropper]
::  name=Eve
)
exit /b 0


:tests.template.dangerous
::  [section1] # comment
::  [section2] # comment []
::  ["section=yes"]
::  ["section#yes"]
::  ["section] #yes"]
::  ["section=yes#ofc"]
::  [key=value]
::  [key="value"  # comment []
::  [key="value"  # comment] # comment []
::  [key="value\"  # comment [] " # comment []

::  [key# comment [] " # comment []
exit /b 0

rem ############################################################################
rem End of File
rem ############################################################################

:EOF
@rem DO NOT WRITE ANYTHING YOU NEED TO KEEP BELOW THIS FUNCTION.
@rem ANYTHING BEYOND THIS FUNCTION WILL BE REMOVED WHEN ADDING DEPENDENCIES.
exit /b
