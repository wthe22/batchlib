:entry_point
call %*
exit /b


:argparse2 [-h] [-T] [-d] [-s] [-n NAME] <spec> ... -- %*
setlocal EnableDelayedExpansion
for %%v in (
    _stop_on_extra _help_syntax _skip_test_spec _dry_run _stop_nonopt _new_name
) do set "%%v="
set "_name=%0"
set "_name=!_name:~1!"
set LF=^
%=REQUIRED=%
%=REQUIRED=%
call :argparse2._parse_opts %* || exit /b
if defined _help_syntax (
    echo usage: !_name! !_help_syntax! spec ... -- %%*
    echo=
    echo Spec syntax:
    echo     [flags] [name [...]]: ^<action^> ^<dest^>[=const]
    echo=
    echo Actions: set, list, help, end
    exit /b 0
)
call :argparse2._parse_specs %* || exit /b 3
if defined _dry_run exit /b 0
if defined _new_name set "_name=!_new_name!"
call :argparse2._parse_args %* || exit /b 4
call :argparse2._capture_args || exit /b 4
exit /b 0
#+++

:argparse2._parse_opts %*
::  -> _position + options
setlocal EnableDelayedExpansion
call :argparse2._read_opt_spec || exit /b 2
set "_position=0"
set "_stop_on_extra=true"
call :argparse2._parse_args %* || exit /b 3
set _actions=!_actions! "store_const:_position=!_position!"
call :argparse2._capture_args || exit /b 3
exit /b 0
#+++

:argparse2._parse_opt_spec
set "_position=0"
call :argparse2._parse_specs ^
    ^ "[-h,--help]:             help _help_syntax" ^
    ^ "[-T,--skip-test-spec]:   set _skip_test_spec=true" ^
    ^ "[-d,--dry-run]:          set _dry_run=true" ^
    ^ "[-s,--stop-nonopt]:      set _stop_nonopt=true" ^
    ^ "[-n,--name NAME]:        set _new_name" ^
    ^ -- || exit /b 2
exit /b 0
#+++

:argparse2._read_opt_spec [return_prefix]
set "%~1_position=6"
set "%~1_spec_names="
set "%~1_spec_flags="
set "%~1_spec_flags=!%~1_spec_flags!-1|--| | |stop-opt-parse| | | | !LF!"
set "%~1_spec_flags=!%~1_spec_flags!0|-h,--help| | |help| |true| |_help_syntax!LF!"
set "%~1_spec_flags=!%~1_spec_flags!1|-T,--skip-test-spec| | |set| |true|true|_skip_test_spec=true!LF!"
set "%~1_spec_flags=!%~1_spec_flags!2|-d,--dry-run| | |set| |true|true|_dry_run=true!LF!"
set "%~1_spec_flags=!%~1_spec_flags!3|-s,--stop-nonopt| | |set| |true|true|_stop_nonopt=true!LF!"
set "%~1_spec_flags=!%~1_spec_flags!4|-n,--name|NAME| |set| |true| |_new_name!LF!"
set "%~1_spec_required= "
set "%~1_known_flags= -- -h --help -T --skip-test-spec -d --dry-run -s --stop-nonopt -n --name "
exit /b 0
#+++

:argparse2._parse_specs %*
::  _position
::  -> _position _spec_names _spec_flags _spec_required _known_flags
set "_spec_names="
set "_spec_flags="
set "_spec_required= "
set "_known_flags= "
set "_spec_flags=!_spec_flags!-1|--| | |stop-opt-parse| | | | !LF!"
set "_known_flags=!_known_flags!-- "
call :argparse2._parse_spec_loop %* || (
    call :argparse2._error read_spec "!errorlevel!" >&2
    exit /b 3
)
exit /b 0
#+++

:argparse2._parse_spec_loop %*
for /l %%n in (1,1,!_position!) do shift /1
set _value=%%1
for /l %%# in (1,1,20) do for /l %%# in (1,1,20) do (
    call set _value=%%1
    if not defined _value exit /b 2
    if "!_value!" == "--" (
        set /a "_position+=1"
        exit /b 0
    )
    call set _value=%%~1

    set "_argument="
    set "_action="
    set "_dest="
    for /f "tokens=1* delims=:" %%a in ("!_value!") do (
        set "_argument=%%a"
        for /f "tokens=1*" %%b in ("%%b") do (
            set "_action=%%b"
            set "_dest=%%c"
        )
    )
    set "_has_const="
    for /f "tokens=2 delims==" %%e in ("!_dest!.") do set "_has_const=true"

    if "!_argument:~0,1!!_argument:~-1,1!" == "[]" (
        set "_required="
        set "_argument=!_argument:~1,-1!"
    ) else set "_required=true"

    set "_flags="
    set "_consume_required=true"
    if "!_argument:~0,1!" == "-" (
        for /f "tokens=1*" %%f in ("!_argument!") do (
            set "_flags=%%f"
            set "_argument=%%g"
        )

        if "!_argument:~0,1!!_argument:~-1,1!" == "[]" (
            set "_consume_required="
            set "_argument=!_argument:~1,-1!"
        )
    )
    for /f "tokens=*" %%a in ("!_argument!") do set "_argument=%%a"

    if "!_argument:~-4,4!" == " ..." (
        set "_consume_many=true"
        set "_argument=!_argument:~0,-4!"
    ) else set "_consume_many="

    set "_metavar=!_argument!"

    if not defined _skip_test_spec (
        call :argparse2._validate_spec || exit /b
    )

    if defined _required set "_spec_required=!_spec_required!!_position! "

    for %%v in (_flags _metavar _required _consume_many _consume_required _has_const) do (
        if not defined %%v set "%%v= "
    )

    set "_spec=!_position!|!_flags!|!_metavar!|!_required!|!_action!|!_consume_many!"
    set "_spec=!_spec!|!_consume_required!|!_has_const!|!_dest!"
    if "!_flags!" == " " (
        set "_spec_names=!_spec_names!!_spec!!LF!"
    ) else (
        set "_spec_flags=!_spec_flags!!_spec!!LF!"
    )
    set /a "_position+=1"
    shift /1
)
exit /b 1
#+++

:argparse2._validate_spec
if not defined _flags (
    if not defined _metavar exit /b 4
)
if defined _metavar (
    if "!_metavar:~0,1!" == "[" exit /b 11
    if "!_metavar:~-1,1!" == "]" exit /b 11
    if "!_metavar:~0,1!" == "-" exit /b 12
    if "!_metavar:~-3,3!" == "..." exit /b 13
)
for %%f in (!_flags!) do (
    set "_flag=%%f"
    if not "!_flag:~0,1!" == "-" exit /b 21
    if not "!_flag:~0,2!" == "--" (
        if not "!_flag:~3!" == "" exit /b 24
        for /f "tokens=1* delims=0123456789" %%a in ("!_flag!") do (
            if "%%a%%b" == "-" exit /b 22
        )
    )
    if not "!_known_flags: %%f = !" == "!_known_flags!" exit /b 23
    set "_known_flags=!_known_flags!%%f "
)

set "_valid_actions="
if defined _metavar (
    if defined _flags (
        if defined _consume_many (
            rem Pattern: "--flag METAVAR ..."
            set "_valid_actions=list"
        ) else (
            rem Pattern: "--flag METAVAR"
            set "_valid_actions=set list"
        )
    ) else (
        if defined _consume_many (
            rem Pattern: "METAVAR ..."
            set "_valid_actions=list"
            rem append + const
        ) else (
            rem Pattern: "METAVAR"
            set "_valid_actions=set"
            rem store + const
        )
    )
) else (
    rem Pattern: "--flag"
    set "_valid_actions=set list help end"
)
set "_action_valid="
for %%a in (!_valid_actions!) do (
    if "%%a" == "!_action!" set "_action_valid=true"
)
if not defined _action_valid exit /b 40

if not defined _dest exit /b 50
if defined _has_const (
    if defined _metavar if defined _consume_required exit /b 52
    if "!_action!" == "help" exit /b 52
) else (
    if not defined _metavar if not "!_action!" == "help" exit /b 52
)
exit /b 0
#+++

:argparse2._parse_args %*
::  _position _spec_names _spec_flags _spec_required _stop_on_extra
::  -> _position _actions
set "_arg_start_pos=!_position!"
set "_actions="
set "_parse_opt=true"
set "_consume_action="
set "_new_spec="
set "_surpress_validation="
call :argparse2._parse_arg_loop %* || (
    set "_exit_code=!errorlevel!"
    call :argparse2._error parse_args "!errorlevel!" >&2
    exit /b !_exit_code!
)
if defined _surpress_validation (
    exit /b 0
)
for /f "tokens=*" %%a in ("!_spec_required!") do set "_spec_required=%%a"
if defined _spec_required (
    set "_exit_code=5"
    call :argparse2._error parse_args "!_exit_code!" >&2
    exit /b !_exit_code!
)
exit /b 0
#+++

:argparse2._parse_arg_loop %*
for /l %%i in (1,1,!_position!) do shift /1
for /l %%# in (1,1,32) do for /l %%# in (1,1,32) do (
    call set _value=%%1
    if not defined _value (
        if defined _consume_action (
            if defined _consume_required exit /b 4
        )
        exit /b 0
    )
    set "_is_flag="
    if defined _parse_opt (
        if "!_value:~0,1!" == "-" (
            for /f "tokens=* delims=0123456789" %%l in ("!_value:~1!.") do if not "%%l" == "." (
                set "_is_flag=true"
            )
        )
    )
    if defined _is_flag (
        set "_new_spec="
        for /f "tokens=* delims=" %%s in ("!_spec_flags!") do if not defined _new_spec (
            for /f "tokens=2 delims=|" %%b in ("%%s") do (
                for %%f in (%%b) do (
                    if "%%f" == "!_value!" set "_new_spec=%%s"
                )
            )
        )
        if not defined _new_spec exit /b 2
    ) else (
        if not defined _consume_action (
            if defined _stop_nonopt (
                if defined _parse_opt set "_parse_opt="
            )
            for /f "tokens=* delims=" %%s in ("!_spec_names!") do if not defined _new_spec (
                set "_new_spec=%%s"
            )
            if not defined _new_spec (
                if defined _stop_on_extra exit /b 0
                exit /b 3
            )
            set _spec_names=!_spec_names:*^%LF%%LF%=!
        )
    )
    if defined _new_spec (
        if defined _consume_action (
            if defined _consume_required exit /b 4
            if defined _no_consume_action (
                set _actions=!_actions! !_no_consume_action!
            )
        )
        if defined _is_flag (
            set "_flag_used=!_value!"
        ) else set "_flag_used="

        for /f "tokens=1-8* delims=|" %%a in ("!_new_spec!") do (
            set "_spec_id=%%a"
            set "_flags=%%b"
            set "_metavar=%%c"
            set "_required=%%d"
            set "_action=%%e"
            set "_consume_many=%%f"
            set "_consume_required=%%g"
            set "_has_const=%%h"
            set "_dest=%%i"
        )
        for %%v in (_flags _metavar _required _consume_required _consume_many _has_const) do (
            if "!%%v!" == " " set "%%v="
        )
        set "_new_spec="

        set "_consume_action="
        for %%a in (set list) do if "!_action!" == "%%a" (
            if defined _metavar (
                if defined _has_const (
                    set _no_consume_action="store_const:!_dest!"
                    for /f "tokens=1 delims==" %%a in ("!_dest!") do (
                        set "_dest=%%a"
                    )
                )
                if defined _flags (
                    set _actions=!_actions! shift
                )
            )
        )
        if "!_action!" == "set" (
            if defined _metavar (
                set _consume_action="store:!_dest!" shift
            ) else (
                set _actions=!_actions! "store_const:!_dest!" shift
            )
        )
        if "!_action!" == "list" (
            if defined _metavar (
                set _consume_action="append:!_dest!" shift
            ) else (
                set _actions=!_actions! "append_const:!_dest!" shift
            )
        )
        if "!_action!" == "help" (
            call :argparse2._generate_help _syntax
            set _actions="store_const:!_dest!=!_syntax!"
            set "_surpress_validation=true"
            exit /b 0
        )
        if "!_action!" == "end" (
            set _actions="store_const:!_dest!"
            set "_surpress_validation=true"
            exit /b 0
        )
        if "!_action!" == "stop-opt-parse" (
            set _actions=!_actions! shift
            set "_parse_opt="
        )

        if defined _required (
            for %%i in (!_spec_id!) do (
                set "_spec_required=!_spec_required: %%i = !"
            )
        )
    )

    if not defined _is_flag if defined _consume_action (
        set _actions=!_actions! !_consume_action!
        if defined _consume_required set "_consume_required="
        if defined _no_consume_action set "_no_consume_action="
        if not defined _consume_many set "_consume_action="
    )
    shift /1
    set /a "_position+=1"
)
exit /b 1
#+++

:argparse2._capture_args $_actions
(
    for /l %%i in (1,1,2) do goto 2> nul
    for %%i in (%_actions%) do ( rem
    ) & for /f "tokens=1* delims=:" %%c in ("%%~i") do (
        if /i "%%c" == "append" (
            call set %%d=^!%%d^!%%1 %=END=%
            set "%%d=!%%d:^^=^!"
        )
        if /i "%%c" == "store" (
            call set "%%d=.%%~1"
            set "%%d=!%%d:^^=^!"
            set "%%d=!%%d:~1!"
        )
        if /i "%%c" == "append_const" (
            for /f "tokens=1* delims==" %%v in ("%%d") do set "%%v=!%%v!%%w "
        )
        if /i "%%c" == "store_const" set "%%d"
        if /i "%%c" == "shift" shift /1
    )
    ( call )
)
exit /b 2
#+++

:argparse2._generate_help <return_var>
setlocal EnableDelayedExpansion
set "_return_var=%~1"
set "_result="
for /f "tokens=1-6* delims=|" %%a in ("!_spec_flags!!_spec_names!") do (
    if %%a GEQ 0 (
        call :argparse2._get_spec "%%a"
        set "_result=!_result! !_full_syntax!"
    )
)
set "_result=!_result:~1!"
for /f "tokens=1* delims=:" %%q in ("Q:!_result!") do (
    endlocal
    set "%_return_var%=%%r"
)
exit /b 0
#+++

:argparse2._error   <context> <exit_code>
setlocal EnableDelayedExpansion
set "_context=%~1"
set "_exit_code=%~2"
set _e=) else if "!_exit_code!" == "$n" (
if "!_context!" == "read_spec" (
    echo !_name!: Invalid spec: "!_value!"
    if "!_exit_code!" == "0" ( rem No error
    %_e:$n=1% echo Unexpected error occurred
    %_e:$n=2% echo Missing -- seperator
    %_e:$n=3% echo No specs were provided
    %_e:$n=4% echo Missing name or flag
    %_e:$n=11% echo Incorrect use of '[]' ^(e.g. usage: '[-u]', '[-u [NAME ...]]'^)
    %_e:$n=12% echo Flags should be seperated by coma, not space ^(e.g.: -u,--user^)
    %_e:$n=13% echo Unexpected use of '...'. It should only be used after the argument name.
    %_e:$n=21%
        if "!_flag:~1!" == "" (
            echo Flag '!_flag!' must start with '-'
        ) else echo Flag '!_flag!' must start with '--'
    %_e:$n=22% echo Number short flags are not supported
    %_e:$n=23% echo Duplicate flag: '!_flag!'
    %_e:$n=24%
        echo Short flag must contain only 1 character ^(e.g.: use '!_flag:~0,2!' or '-!_flag!'^)
    %_e:$n=40% echo Expected action {!_valid_actions!}, got: '!_action!'
    %_e:$n=50% echo Missing destination variable
    %_e:$n=51% echo Missing const
    %_e:$n=52% echo Unexpected const
    ) else echo Got error code !_exit_code!
) else if "!_context!" == "parse_args" (
    set /a "_arg_pos=!_position! - !_arg_start_pos!"
    if "!_exit_code!" == "0" ( rem No error
    %_e:$n=1% echo !_name!: Unexpected error occurred at argument !_arg_pos!: !_value!
    %_e:$n=2% echo !_name!: Unknown flag: !_value!
    %_e:$n=3% echo !_name!: Unexpected positional argument: !_value!
    %_e:$n=4% echo !_name!: Flag '!_flag_used!' requires argument '!_metavar!'
    %_e:$n=5%
        set "_missing_specs="
        for %%i in (!_spec_required!) do (
            call :argparse2._get_spec %%i
            set "_missing_specs=!_missing_specs!, !_display!"
        )
        set "_missing_specs=!_missing_specs:~2!"
        echo !_name!: Missing required arguments: !_missing_specs!
    ) else echo !_name!: Error !_exit_code! at argument !_arg_pos!: !_value!
) else (
    echo !_name!: At '!_context!', got error code !_exit_code! at position !_position!: !_value!
)
exit /b 0
#+++

:argparse2._get_spec <spec_id>
set "_spec_id="
for /f "tokens=1-7* delims=|" %%a in ("!_spec_names!!_spec_flags!") do (
    if "%~1" == "%%a" (
        set "_spec_id=%%a"
        set "_flags=%%b"
        set "_metavar=%%c"
        set "_required=%%d"
        set "_action=%%e"
        set "_consume_many=%%f"
        set "_consume_required=%%g"
        set "_dest=%%h"
        for %%v in (_flags _metavar _required _consume_required _consume_many) do (
            if "!%%v!" == " " set "%%v="
        )

        set "_full_syntax="
        if defined _metavar (
            set "_full_syntax=!_metavar!"
            if defined _consume_many set "_full_syntax=!_full_syntax! ..."
        )
        if defined _flags (
            set "_flag_count=0"
            set "_flags_choice="
            for %%f in (!_flags!) do (
                set "_flags_choice=!_flags_choice!|%%f"
                set /a "_flag_count+=1"
            )
            set "_flags_choice=!_flags_choice:~1!"
            set "_need_parenthesis="
            if !_flag_count! GTR 1 (
                if defined _metavar set "_need_parenthesis=true"
                if defined _required set "_need_parenthesis=true"
            )
            set "_flags_syntax=!_flags_choice!"
            if defined _need_parenthesis (
                set "_flags_syntax=(!_flags_syntax!)"
            )
            if defined _metavar (
                if not defined _consume_required (
                    set "_full_syntax=[!_full_syntax!]"
                )
                set "_full_syntax=!_flags_syntax! !_full_syntax!"
            ) else set "_full_syntax=!_flags_syntax!"
        )
        if not defined _required set "_full_syntax=[!_full_syntax!]"

        set "_display="
        if defined _flags (
            for %%f in (!_flags!) do (
                if not defined _display set "_display=%%f"
            )
        ) else set "_display=!_metavar!"
    )
)
if not defined _spec_id exit /b 2
exit /b 0


:lib.dependencies [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=input_string unset_all"
set "%~1category=cli"
exit /b 0


:doc.man
::  NAME
::      argparse2 - parse options passed to script or function
::
::  SYNOPSIS
::      argparse2 [-h] [-T] [-d] [-s] [-n NAME] <spec> ... -- %*
::
::  OPTIONS
::      Note: They must appear before all SPECs
::
::      -h, --help
::          Show syntax of command.
::
::      -T, --skip-test-spec
::          Skip spec validation. Only use this when spec is already valid.
::          Using this with invalid specs might cause unexpected behavior.
::
::      -d, --dry-run
::          Run without parsing arguments.
::
::      -n, --name NAME
::          Command name for use in error messages. By default it is 'argparse2'.
::
::      -s, --stop-nonopt
::          Stop scanning for options as soon as the first non-option argument
::          is seen. The rest are treated positional arguments.
::
::  POSITIONAL ARGUMENTS
::      spec
::          Arguments specifications to parse. The complete syntax can
::          be found in the ARGUMENT SPECIFACTIONS section.
::
::      --
::          Mark the end of specs. This is required.
::
::      %*
::          Arguments given by the end user to parse. This MUST be '%*' or
::          else it might fail to capture arguments because it consumes the
::          caller's %1, %2, etc.
::
::  ARGUMENT SPECIFACTIONS
::
::              [flags] [metavar [...]]: <action> <dest>[=const]
::
::      FLAGS
::          The flags to capture, with each flag seperated by comma. Flags can be
::          a short flag (e.g. -s), or a long flag (e.g. --hello, --hello-world).
::          Negative number flags are not supported. No duplicate flags allowed.
::
::      METAVAR
::          The name of the argument. This indicates that it may accept value
::          from the arguments. The name itself is only used for help messages.
::          It may contain spaces.
::
::      ...
::          Indicates that spec may consume multiple arguments.
::
::      ACTION
::          The action to do (case sensitive). Valid actions:
::              set     Set the variable to a value
::              list    Gather values into a list, each seperated by a space,
::                      with quotes preserved
::              help    Generate help syntax, store it in the variable and
::                      quit parsing
::              end     Set the variable to a value and quit parsing
::
::      DEST
::          The destination variable that is used to store the value. If the action
::          is list, it will seperate each consumed arguments by a space, with
::          quotes preserved.
::
::      CONST
::          The value to store at the destination variable. Only allowed if the
::          option does not accept any value.
::
::      REQUIRED/OPTIONAL
::          Required arguments/options:
::                  metavar
::                  metavar ...
::                  --flag metavar
::
::          Optional arguments/options:
::                  [metavar]
::                  [metavar ...]
::                  [--flag]
::                  [--flag metavar]
::
::          Optional flag, required argument:
::                  [--flag metavar]
::                  [--flag metavar ...]
::
::          Optional flag, optional argument:
::                  [--flag [metavar]]
::                  [--flag [metavar ...]]
::
::  EXIT STATUS
::      0:  - Success
::      2:  - Internal error
::      3:  - Invalid specs
::      4:  - User gives an invalid arguments
::
::  NOTES
::      - The order of the positional arguments are important.
::      - Multi-character short options are not supported.
::        (e.g: you must use 'ls -a -l' instead of 'ls -al')
::      - Function SHOULD be embedded into the script.
::      - This function should not be used multiple times within the same context
::        because it consumes the caller's %1, %2, etc. argument. Otherwise, it
::        might capture incorrect values.
exit /b 0


:doc.demo
echo A DEMO function to generate text for buying and selling stuffs
echo=
call :shop --help
echo=
call :shop buy --help
echo=
call :shop sell --help
echo=
echo=
echo Example:
echo     -u "Alice" buy "1 Cactus" "2 Snacks"
echo=
call :input_string parameters
echo=
echo --------------------------------------------------------------------------------
echo Example:
echo     -u "Alice" buy "1 Cactus" "2 Snacks" --confirm
echo=
echo Input parameters:
echo=!parameters!
echo=
call :shop !parameters!
echo=
echo --------------------------------------------------------------------------------
echo Arguments:
set "shop_"
exit /b !exit_code!
echo=
echo Exit code !exit_code!
exit /b 0
#+++

:shop
call :unset_all shop_
set "shop_user=anonymous"
call :argparse2 --name "shop" --stop-nonopt ^
    ^ "[-h,--help]:             help shop_syntax" ^
    ^ "[--version]:             end shop_show_version=true" ^
    ^ "[-u,--user NAME]:        set shop_user" ^
    ^ "action:                  set shop_action" ^
    ^ "[arg ...]:               list shop_argv" ^
    ^ -- %* || exit /b 2
set "available_actions=buy, sell"
if defined shop_syntax (
    echo usage: shop !shop_syntax!
    echo=
    echo    -h, --help              Show this help
    echo    --version               Show program version
    echo    -u,--user NAME          Specify your username
    echo    action                  Action to do: {!available_actions!}
    echo    [args ...]              Arguments given for the specified action.
    exit /b 0
)
if defined shop_show_version (
    echo shop v0.1
    exit /b 0
)
set "valid_action="
for %%c in (!available_actions!) do (
    if "!shop_action!" == "%%c" set "valid_action=true"
)
if not defined valid_action (
    1>&2 echo%0: Unknown action '!shop_action!'. Use '-h' for help
    exit /b 2
)
call :shop.!shop_action! !shop_argv!
exit /b
#+++

:shop.buy
call :argparse2 --name "shop" ^
    ^ "[-h,--help]:                 help shop_syntax" ^
    ^ "item_name ...:               list shop_item_names" ^
    ^ "[--confirm]:                 set shop_confirm=true" ^
    ^ -- %* || exit /b 2
if defined shop_syntax (
    echo usage: shop [SHOP_OPTIONS] buy !shop_syntax!
    echo=
    echo    -h, --help              Show this help
    echo    --confirm               Confirm the purchase
    echo    item_name               The items to buy
    exit /b 0
)
if not defined shop_confirm (
    echo [PREVIEW - Needs confirmation]
)
echo !shop_user! wants to buy:
for %%n in (!shop_item_names!) do (
    echo - %%~n
)
exit /b 0
#+++

:shop.sell
call :argparse2 --name "shop" ^
    ^ "[-h,--help]:                 help shop_syntax" ^
    ^ "[-v,--variant NAME ...]:     list shop_item_variants" ^
    ^ "item_name:                   set shop_item_name" ^
    ^ "amount:                      set shop_item_amount" ^
    ^ "[price]:                     set shop_item_price" ^
    ^ -- %* || exit /b 2
if defined shop_syntax (
    echo usage: shop [SHOP_OPTIONS] sell !shop_syntax!
    echo=
    echo    -h, --help              Show this help
    echo    -v,--variant NAME       List of available variants
    echo    item_name               Item name
    echo    amount                  Amount of item to sell
    echo    price                   Total price
    exit /b 0
)
set "message=!shop_user! wants to sell !shop_item_amount! !shop_item_name!."
if defined shop_item_price (
    set "message=!message:~0,-1! for !shop_item_price!."
)
if defined shop_item_variants (
    set "variant_formatted= "
    for %%n in (!shop_item_variants!) do (
        set "variant_formatted=!variant_formatted! %%~n,"
    )
    set "message=!message! Variants: {!variant_formatted:~2,-1!}."
)
echo !message!
exit /b 0
#+++


:tests.setup
rem set "debug="
set "STDERR_REDIRECTION=2> nul"
call :unset_all p_
set "internal_error=2"
set "spec_error=3"
set "arg_error=4"
exit /b 0


:tests.teardown
exit /b 0


:tests.spec.test_internal_specs
call :argparse2._parse_opt_spec || (
    call %unittest% fail "Got error when parsing internal opt specs"
)
call :argparse2._read_opt_spec _final || (
    call %unittest% fail "Got error when reading internal opt specs"
)
for %%v in (_position _spec_names _spec_flags _spec_required _known_flags) do (
    if not "!%%v!" == "!_final%%v!" (
        call %unittest% fail "Opt spec '%%v': Expected '!%%v!', got '!_final%%v!'"
    )
)
exit /b 0


:tests.spec.test_dry_run
call :argparse2 -d ^
    ^ "-a:            set p_opts=fail" ^
    ^ -- -a || (
    call %unittest% fail "Got error when using -d with valid spec"
)
call :argparse2 --dry-run ^
    ^ "-a:            set p_opts=fail" ^
    ^ -- -a || (
    call %unittest% fail "Got error when using --dry-run with valid spec"
)
if defined p_opts (
    call %unittest% fail "Arguments should not be parsed"
)
exit /b 0


:tests.spec.test_valid
call :argparse2 --dry-run ^
    ^ "arg1:                set p_arg1" ^
    ^ "[-h,--help]:         help p_help" ^
    ^ "[--version]:         end p_show_version=true" ^
    ^ "[--sc]:              set p_opt_sc=1" ^
    ^ "[--ac]:              list p_opt_ac=+1" ^
    ^ "[-s TEXT]:           set p_opt_s" ^
    ^ "[--sd [TEXT]]:       set p_opt_s=default" ^
    ^ "[-a,--append TEXT]:  list p_opt_a" ^
    ^ "[--ad [TEXT]]:       list p_opt_a=default" ^
    ^
    ^ %= flags =% ^
    ^ "-f:                      set p_opt_a=1" ^
    ^ "-g,--g2:                 set p_opt_a=1" ^
    ^ "--h-1,--h-2,--h-3:       set p_opt_a=1" ^
    ^
    ^ %= consume many =% ^
    ^ "cm_arg1 ...:             list p_arg1" ^
    ^ "[cm_arg2 ...]:           list p_arg2" ^
    ^ "--cm-rr TEXT ...:        list p_opt_a" ^
    ^ "[--cm-or TEXT ...]:      list p_opt_a" ^
    ^ "--cm-ro [TEXT ...]:      list p_opt_a" ^
    ^ "[--cm-oo [TEXT ...]]:    list p_opt_a" ^
    ^
    ^ -- || (
    call %unittest% fail "Got error when using valid specs"
)
exit /b 0


:tests.spec.test_end_marker_missing
call :argparse2 --dry-run ^
    ^ "arg1:                set p_arg1" ^
    ^ %STDERR_REDIRECTION% && (
    call %unittest% fail "Unraised error on missing -- seperator"
)
exit /b 0


:tests.spec.test_option_unknown
call :argparse2 --invalid ^
    ^ -- %STDERR_REDIRECTION% && (
    call %unittest% fail "Unraised error when given unknown option"
)
exit /b 0


:tests.spec.test_metavar_bad_syntax
call :argparse2 --dry-run ^
    ^ " :                   set p_arg1" ^
    ^ -- %STDERR_REDIRECTION% && (
    call %unittest% fail "Unraised error when metavar is empty"
)
call :argparse2 --dry-run ^
    ^ "[:                   set p_arg1" ^
    ^ -- %STDERR_REDIRECTION% && (
    call %unittest% fail "Unraised error when metavar have unmatched '['"
)
call :argparse2 --dry-run ^
    ^ "]:                   set p_arg1" ^
    ^ -- %STDERR_REDIRECTION% && (
    call %unittest% fail "Unraised error when metavar have unmatched ']'"
)
call :argparse2 --dry-run ^
    ^ "[[arg1]]:            set p_arg1" ^
    ^ -- %STDERR_REDIRECTION% && (
    call %unittest% fail "Unraised error when metavar have nested '[]'"
)
call :argparse2 --dry-run ^
    ^ "--flag [:    set p_arg1" ^
    ^ -- %STDERR_REDIRECTION% && (
    call %unittest% fail "Unraised error when metavar have unmatched '[' after flag"
)
call :argparse2 --dry-run ^
    ^ "--flag ]:    set p_arg1" ^
    ^ -- %STDERR_REDIRECTION% && (
    call %unittest% fail "Unraised error when metavar have unmatched ']' after flag"
)
call :argparse2 --dry-run ^
    ^ "--flag -metavar-:    set p_arg1" ^
    ^ -- %STDERR_REDIRECTION% && (
    call %unittest% fail "Unraised error when metavar is detected as flag"
)
exit /b 0


:tests.spec.test_consume_many_bad_syntax
call :argparse2 --dry-run ^
    ^ "[arg1] ...:      list p_arg1" ^
    ^ -- %STDERR_REDIRECTION% && (
    call %unittest% fail "Unraised error when using '[arg] ...'"
)
call :argparse2 --dry-run ^
    ^ "[-a TEXT] ...:   list p_arg1" ^
    ^ %STDERR_REDIRECTION% && (
    call %unittest% fail "Unraised error when using '[--flag metavar] ...'"
)
call :argparse2 --dry-run ^
    ^ "[-a [...]] :   list p_arg1" ^
    ^ %STDERR_REDIRECTION% && (
    call %unittest% fail "Unraised error when using '[--flag metavar] ...'"
)
call :argparse2 --dry-run ^
    ^ "[-a [ ...]] :   list p_arg1" ^
    ^ %STDERR_REDIRECTION% && (
    call %unittest% fail "Unraised error when using '[--flag metavar] ...'"
)
call :argparse2 --dry-run ^
    ^ "-a ...:          list p_arg1" ^
    ^ -- %STDERR_REDIRECTION% && (
    call %unittest% fail "Unraised error when using '-a ...'"
)
call :argparse2 --dry-run ^
    ^ "...:                set p_arg1" ^
    ^ %STDERR_REDIRECTION% && (
    call %unittest% fail "Unraised error when using '...' only"
)
call :argparse2 --dry-run ^
    ^ " ...:                set p_arg1" ^
    ^ %STDERR_REDIRECTION% && (
    call %unittest% fail "Unraised error when using '...' only"
)
exit /b 0


:tests.spec.test_consume_many_bad_action
call :argparse2 --dry-run ^
    ^ "arg1 ...:        set p_arg1" ^
    ^ -- %STDERR_REDIRECTION% && (
    call %unittest% fail "Unraised error when using '[arg] ...'"
)
call :argparse2 --dry-run ^
    ^ "[-a TEXT ...]:   set p_opt_a" ^
    ^ %STDERR_REDIRECTION% && (
    call %unittest% fail "Unraised error when using '[--flag metavar] ...'"
)
exit /b 0


:tests.spec.test_dest_missing
call :argparse2 --dry-run ^
    ^ "arg1:    set" ^
    ^ -- %STDERR_REDIRECTION% && (
    call %unittest% fail "Unraised error when destination variable is missing"
)
exit /b 0


:tests.spec.test_const_invalid
call :argparse2 --dry-run ^
    ^ "[--sc]:      set p_opt_sc" ^
    ^ -- %STDERR_REDIRECTION% && (
    call %unittest% fail "Unraised error when store_const has missing const"
)
call :argparse2 --dry-run ^
    ^ "[--ac]:      list p_opt_ac" ^
    ^ -- %STDERR_REDIRECTION% && (
    call %unittest% fail "Unraised error when append_const has missing const"
)
call :argparse2 --dry-run ^
    ^ "[--version]: end p_show_version" ^
    ^ -- %STDERR_REDIRECTION% && (
    call %unittest% fail "Unraised error when action 'end' has missing const"
)
call :argparse2 --dry-run ^
    ^ "arg1:        set p_arg1=this_must_not_be_here" ^
    ^ -- %STDERR_REDIRECTION% && (
    call %unittest% fail "Unraised error when store arg has unexpected const"
)
call :argparse2 --dry-run ^
    ^ "argv ...:    list p_argv=this_must_not_be_here" ^
    ^ -- %STDERR_REDIRECTION% && (
    call %unittest% fail "Unraised error when append arg has unexpected const"
)
call :argparse2 --dry-run ^
    ^ "[--s TEXT]:  set p_opt_s=this_must_not_be_here" ^
    ^ -- %STDERR_REDIRECTION% && (
    call %unittest% fail "Unraised error when store flag has unexpected const"
)
call :argparse2 --dry-run ^
    ^ "[--a TEXT]:  list p_opt_a=this_must_not_be_here" ^
    ^ -- %STDERR_REDIRECTION% && (
    call %unittest% fail "Unraised error when append flag has unexpected const"
)
exit /b 0


:tests.spec.test_flag_bad_syntax
call :argparse2 --dry-run ^
    ^ "[-a,alpha]:      set p_opt_sc=1" ^
    ^ -- %STDERR_REDIRECTION% && (
    call %unittest% fail "Unraised error when flag does not start with '-' or '/'"
)
call :argparse2 --dry-run ^
    ^ "[-a --alpha]:    set p_opt_sc=1" ^
    ^ -- %STDERR_REDIRECTION% && (
    call %unittest% fail "Unraised error when flag is not seperated by comma"
)
call :argparse2 --dry-run ^
    ^ "[-1]:            set p_opt_sc=1" ^
    ^ -- %STDERR_REDIRECTION% && (
    call %unittest% fail "Unraised error when number flag is used"
)
call :argparse2 --dry-run ^
    ^ "[-long]:         set p_opt_sc=1" ^
    ^ -- %STDERR_REDIRECTION% && (
    call %unittest% fail "Unraised error when short flag contains more than 1 character"
)
exit /b 0


:tests.spec.test_flag_duplicate
call :argparse2 --dry-run ^
    ^ "[-a]:            set p_opt_sc=1" ^
    ^ "[-a]:            set p_opt_sc=2" ^
    ^ -- %STDERR_REDIRECTION% && (
    call %unittest% fail "Unraised error when duplicate flag exists"
)
call :argparse2 --dry-run ^
    ^ "[-a,--alpha]:    set p_opt_sc=1" ^
    ^ "[-r,--alpha]:    set p_opt_sc=2" ^
    ^ -- %STDERR_REDIRECTION% && (
    call %unittest% fail "Unraised error when duplicate flag exists at subsequent flag"
)
exit /b 0


:tests.spec.test_action_invalid
for %%a in (invalid help list end) do (
    call :argparse2 --dry-run ^
        ^ "arg1:                %%a p_arg1" ^
        ^ -- %STDERR_REDIRECTION% && (
        call %unittest% fail "Unraised error when using 'metavar' with action '%%a'"
    )
)
for %%a in (invalid help set end) do (
    call :argparse2 --dry-run ^
        ^ "arg1 ...:                %%a p_arg1" ^
        ^ -- %STDERR_REDIRECTION% && (
        call %unittest% fail "Unraised error when using 'metavar ...' with action '%%a'"
    )
)
for %%a in (invalid) do (
    call :argparse2 --dry-run ^
        ^ "[-s]:                    %%a p_opt_s=+1" ^
        ^ -- %STDERR_REDIRECTION% && (
        call %unittest% fail "Unraised error when using '--flag' with action '%%a'"
    )
)
for %%a in (invalid help end) do (
    call :argparse2 --dry-run ^
        ^ "[-s TEXT]:               %%a p_opt_sc" ^
        ^ -- %STDERR_REDIRECTION% && (
        call %unittest% fail "Unraised error when using '--flag metavar' with action '%%a'"
    )
)
for %%a in (invalid help set end) do (
    call :argparse2 --dry-run ^
        ^ "[-s TEXT ...]:           %%a p_opt_s" ^
        ^ -- %STDERR_REDIRECTION% && (
        call %unittest% fail "Unraised error when using '--flag metavar ...' with action '%%a'"
    )
)
exit /b 0


:tests.spec.test_internal_help
for %%f in (-h --help) do (
    call :argparse2 %%f > "help_msg" || (
        call %unittest% fail "Got error when help flag is given"
    )
    set /p "result=" < "help_msg"
    set "expected=usage:"
    for /f "tokens=1" %%a in ("!result!") do set "result=%%a"
    if not "!result!" == "!expected!" (
        call %unittest% fail "Expected '!expected!', got '!result!'"
    )
)
exit /b 0


:tests.spec.test_skip_test_spec
call :argparse2 -T --dry-run ^
    ^ "[-a]:            set p_opt_a=A" ^
    ^ -- || (
    call %unittest% fail "Got error when using '--skip-test-spec' with valid spec"
)
call :argparse2 --skip-test-spec --dry-run ^
    ^ "[-a]:            set p_opt_a=A" ^
    ^ -- || (
    call %unittest% fail "Got error when using '--skip-test-spec' with valid spec"
)
exit /b 0


:tests.spec.preview_error_messages
call :argparse2 ^
    ^ "[-f r] ...: list p_11" ^
    ^ --
echo=
call :argparse2 ^
    ^ "[-f [r] ...]: list p_11" ^
    ^ --
echo=
call :argparse2 ^
    ^ "[-d -d]: set p_12" ^
    ^ --
echo=
call :argparse2 ^
    ^ "...: set p_13" ^
    ^ --
echo=
call :argparse2 ^
    ^ "[-d,dddd]: set p_21" ^
    ^ --
echo=
call :argparse2 ^
    ^ "-1: set p_22" ^
    ^ --
echo=
call :argparse2 ^
    ^ "[-d,-d]: set p_23" ^
    ^ --
echo=
call :argparse2 ^
    ^ "[-ddddd]: set p_24" ^
    ^ --
echo=
call :argparse2 ^
    ^ "[-u,--user NAME]: help p_40" ^
    ^ --
echo=
call :argparse2 ^
    ^ "[-u,--user p_50]: set" ^
    ^ --
echo=
call :argparse2 ^
    ^ "[-d,--ddd]: set p_51" ^
    ^ --
echo=
call :argparse2 ^
    ^ "[-u,--user NAME]: set p_52=xxx" ^
    ^ --
echo=
exit /b 0


:tests.args.test_consume_valid
if ^"%1^" == "" (
    call :tests.args.test_consume_valid ^
        ^ alpha "bravo" charlie "delta" ^
        ^ -a a_ -b b1_ --bravo b2_ ^
        ^ -c c c_ -d "d" d_ -e e1 e1_ -e e2 e2_ ^
        ^ -f f1 f1_ -f "f2" f2_ ^
        ^ -g g1 g2 "-g" g3 ^
        ^ -h -i i -j -k k1 k2 ^
        ^ -- -g "yankee" -- zulu -1 -999 ^
        ^ %=END=%
    exit /b
)
call :argparse2 ^
    ^ "arg1:                set p_arg1" ^
    ^ "arg2:                set p_arg2" ^
    ^ "arg3 ...:            list p_arg3" ^
    ^ "-a:                  set p_opt_a=A" ^
    ^ "extra ...:           list p_extra" ^
    ^ "-b,--bravo:          list p_opt_b=B" ^
    ^ "extra ...:           list p_extra" ^
    ^ "extra ...:           list p_extra" ^
    ^ "-c TEXT:             set p_opt_c" ^
    ^ "extra ...:           list p_extra" ^
    ^ "-d TEXT:             set p_opt_d" ^
    ^ "extra ...:           list p_extra" ^
    ^ "-e TEXT:             set p_opt_e" ^
    ^ "extra ...:           list p_extra" ^
    ^ "extra ...:           list p_extra" ^
    ^ "-f TEXT:             list p_opt_f" ^
    ^ "extra ...:           list p_extra" ^
    ^ "extra ...:           list p_extra" ^
    ^ "-g TEXT ...:         list p_opt_g" ^
    ^ "-h [TEXT]:           set p_opt_h=H" ^
    ^ "-i [TEXT]:           set p_opt_i=I" ^
    ^ "-j [TEXT ...]:       list p_opt_j=J" ^
    ^ "-k [TEXT ...]:       list p_opt_k=K" ^
    ^ "arg4 ...:            list p_arg4" ^
    ^ -- %* || (
    call %unittest% fail "Got error when consuming valid arguments"
    exit /b 0
)
set expected=alpha,bravo,charlie "delta" %=END=%
set expected=!expected!,-g "yankee" -- zulu -1 -999 %=END=%
set expected=!expected!,a_ b1_ b2_ c_ d_ e1_ e2_ f1_ f2_ %=END=%
set expected=!expected!,A,B B ,c,d,e2,f1 "f2" ,g1 g2 "-g" g3 ,H,i,J,k1 k2 %=END=%
set result=!p_arg1!,!p_arg2!,!p_arg3!,!p_arg4!,!p_extra!
set result=!result!,!p_opt_a!,!p_opt_b!,!p_opt_c!,!p_opt_d!,!p_opt_e!,!p_opt_f!
set result=!result!,!p_opt_g!,!p_opt_h!,!p_opt_i!,!p_opt_j!,!p_opt_k!
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:tests.args.test_optional_valid
if ^"%1^" == "" (
    call :tests.args.test_optional_valid -d -e
    exit /b
)
call :argparse2 ^
    ^ "[arg1]:              set p_arg1" ^
    ^ "[arg2 ...]:          list p_arg2" ^
    ^ "[-a]:                set p_opt_a=A" ^
    ^ "[-b TEXT]:           set p_opt_b" ^
    ^ "[-c TEXT ...]:       list p_opt_c" ^
    ^ "-d [TEXT]:           set p_opt_d" ^
    ^ "-e [TEXT ...]:       list p_opt_e" ^
    ^ -- %* || (
    call %unittest% fail "Got error when all consumes are optional"
    exit /b 0
)
set expected=,,,,,,
set result=!p_arg1!,!p_arg2!,!p_opt_a!,!p_opt_b!,!p_opt_c!,!p_opt_d!,!p_opt_e!
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:tests.args.test_help
call :argparse2 ^
    ^ "arg1:                set p_arg1" ^
    ^ "[arg2]:              set p_arg2" ^
    ^ "[arg3 ...]:          list p_arg3" ^
    ^ "[-h,--help]:         help p_help" ^
    ^ "-a,--alp,--alpha:    set p_opt_a=1" ^
    ^ "[-b,--bravo TEXT]:   set p_opt_b" ^
    ^ "-c [TEXT]:           set p_opt_c" ^
    ^ "-d TEXT ...:         list p_opt_d" ^
    ^ "[-e [T1 T2 ...]]:    list p_opt_e" ^
    ^ -- -h || (
    call %unittest% fail "Got error when generating help for valid specs"
)
set "expected="
set "expected=!expected![-h|--help] (-a|--alp|--alpha) [(-b|--bravo) TEXT]"
set "expected=!expected! -c [TEXT] -d TEXT ... [-e [T1 T2 ...]]"
set "expected=!expected! arg1 [arg2] [arg3 ...]"
set "result=!p_help!"
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:tests.args.test_end
call :argparse2 ^
    ^ "[--version]:         end p_show_version=true" ^
    ^ "arg1:                set p_arg1" ^
    ^ -- --version || (
    call %unittest% fail "Got error when using end"
)
set expected=true
set result=!p_show_version!
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:tests.args.test_arg_too_many
if ^"%1^" == "" (
    call :tests.args.test_arg_too_many a b
    exit /b
)
call :argparse2 ^
    ^ "arg1:                set p_arg1" ^
    ^ -- %* %STDERR_REDIRECTION% && (
    call %unittest% fail "Unraised error when require 1 arg but got more"
    exit /b 0
)
call :argparse2 ^
    ^ "[-a]:                set p_opt_a=A" ^
    ^ -- %* %STDERR_REDIRECTION% && (
    call %unittest% fail "Unraised error when require 0 args but got more"
    exit /b 0
)
exit /b 0


:tests.args.test_flag_unknown
if ^"%1^" == "" (
    call :tests.args.test_flag_unknown --alph
    exit /b
)
call :argparse2 ^
    ^ "[-a,--alp,--alpha]:  set p_opts=a" ^
    ^ -- %* %STDERR_REDIRECTION% && (
    call %unittest% fail "Unraised error when unknown flag is given"
    exit /b 0
)
exit /b 0


:tests.args.test_required_missing
call :argparse2 ^
    ^ "arg1:                set p_arg1" ^
    ^ -- %* %STDERR_REDIRECTION% && (
    call %unittest% fail "Unraised error when argument is required but nothing is given"
    exit /b 0
)
call :argparse2 ^
    ^ "-a,--alpha:          set p_opts=a" ^
    ^ -- %* %STDERR_REDIRECTION% && (
    call %unittest% fail "Unraised error when flag is required but nothing is given"
    exit /b 0
)
exit /b 0


:tests.args.test_consume_required_missing
if ^"%1^" == "" (
    call :tests.args.test_consume_required_missing -a
    exit /b
)
call :argparse2 ^
    ^ "-a AAA:          set p_opt_a" ^
    ^ -- %* %STDERR_REDIRECTION% && (
    call %unittest% fail "Unraised error when using store without expected argument"
)
call :argparse2 ^
    ^ "-a AAA ...:      list p_opt_a" ^
    ^ -- %* %STDERR_REDIRECTION% && (
    call %unittest% fail "Unraised error when using append without expected argument"
)
exit /b 0


:tests.args.test_exit_code
call :argparse2 --invalid ^
    ^ -- %STDERR_REDIRECTION%
set "result=!errorlevel!"
set "expected=!spec_error!"
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected exit code '!expected!' for option spec error, got '!result!'"
)
call :argparse2 --dry-run ^
    ^ -- %STDERR_REDIRECTION%
set "result=!errorlevel!"
set "expected=!spec_error!"
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected exit code '!expected!' for spec error, got '!result!'"
)
call :argparse2 ^
    ^ "arg1:          set p_arg1" ^
    ^ -- %STDERR_REDIRECTION%
set "result=!errorlevel!"
set "expected=!arg_error!"
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected exit code '!expected!' for arg error, got '!result!'"
)
exit /b 0


:tests.args.test_command_name
if ^"%1^" == "" (
    call :tests.args.test_command_name --invalid invalid
    exit /b
)
set "expected=my-command-name-here"
call :argparse2 --name "!expected!" ^
    ^ "-a TEXT:        set p_argv" ^
    ^ -- %* 2> "error_msg" && (
    call %unittest% error "Unraised error, cannot capture error message"
)
set /p "result=" < "error_msg"
for /f "tokens=1 delims=:" %%a in ("!result!") do set "result=%%a"
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:tests.args.test_stop_nonopt
if ^"%1^" == "" (
    call :tests.args.test_stop_nonopt -a alpha bravo -b charlie
    exit /b
)
call :argparse2 --stop-nonopt ^
    ^ "arg1:                set p_arg1" ^
    ^ "[arg2 ...]:          list p_arg2" ^
    ^ "[-a TEXT]:           set p_opt_a" ^
    ^ "[-b]:                set p_opt_b=B" ^
    ^ -- %* || (
    call %unittest% fail "Got error when all consumes are optional"
    exit /b 0
)
set expected=bravo,-b charlie ,alpha,
set result=!p_arg1!,!p_arg2!,!p_opt_a!,!p_opt_b!
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:tests.capture.test_store_special_chars
if ^"%1^" == "" (
    call :tests.list_characters
    set "args="
    set "specs="
    set "expected="
    for %%v in (!symbols!) do (
        set args=!args! !%%v!
        set specs=!specs! "[%%v]: set p_%%v"
        if "!%%v:~0,1!!%%v:~-1,1!" == ^"^"^"^" (
            set "expected=!expected!,!%%v:~1,-1!"
        ) else set "expected=!expected!,!%%v!"
    )
    call :tests.capture.test_store_special_chars !args!
    exit /b
)
call :argparse2 ^
    ^ !specs! ^
    ^ -- %* || (
    call %unittest% fail "Parse failed"
    exit /b 0
)
set "result="
for %%v in (!symbols!) do (
    set "result=!result!,!p_%%v!"
)
for %%v in (expected result) do set "%%v=!%%v:~1!"
if not "!result!" == "!expected!" (
    call %unittest% fail "Got incorrect result using one of these symbols: !symbols!"
)
exit /b 0


:tests.capture.test_append_special_chars
if ^"%1^" == "" (
    call :tests.list_characters
    set "args="
    set "expected="
    for %%v in (!symbols!) do (
        set args=!args! !%%v!
        set "expected=!expected!!%%v! "
    )
    call :tests.capture.test_append_special_chars !args!
    exit /b
)
call :argparse2 ^
    ^ "[argv ...]:      list p_argv" ^
    ^ -- %* || (
    call %unittest% fail "Parse failed"
    exit /b 0
)
set "result=!p_argv!"
if not "!result!" == "!expected!" (
    call %unittest% fail "Got incorrect result using one of these symbols: !symbols!"
)
exit /b 0


:tests.list_characters
set null=""
set letters=abcdefghijklmnopqrstuvwxyz
set digits=0123456789
set caret="^^^^"
set ast=*
set qm=?
set amp="&"
set hm="-"
set eq="="
set scolon=";"
set coma=","
set colon=:
set vline="|"
set parns_l=(
set parns_r=)
set sqbr_l=[
set sqbr_r=]
set "symbols="
set "symbols=!symbols! letters null ast qm caret coma eq scolon amp vline"
set "symbols=!symbols! hm colon parns_l parns_r sqbr_l sqbr_r"
set "symbols=!symbols! digits"
exit /b 0


:tests.debug_msg <context>
::  rem %debug% call :tests.debug_msg read_opt_spec
::  rem %debug% call :tests.debug_msg validate_spec
::  rem %debug% call :tests.debug_msg parse_spec
::  rem %debug% call :tests.debug_msg parse_args
::  rem %debug% call :tests.debug_msg validate_args
::  rem %debug% call :tests.debug_msg capture_args
::      rem %debug% echo !_position!:!_value!
::          rem %debug% echo - new spec: [!_new_spec!]
if "%~1" == "validate_spec" (
    for %%v in (
        _position _flags _metavar _required _consume_required _action _dest
    ) do echo %%v: [!%%v!]
    echo=
    exit /b 0
)
(
    echo ========================================
    if "%~1" == "read_opt_spec" (
        echo Read Opt Spec
    ) else if "%~1" == "parse_spec" (
        echo Parse Spec
        echo _position: !_position!
    ) else if "%~1" == "parse_args" (
        call :argparse2._generate_help _spec_syntax
        echo Parse Args
        echo _position: !_position!
        echo _stop_on_extra: !_stop_on_extra!
        echo=
        echo !_spec_syntax!
        echo=
        echo Specs:
        echo=!_spec_flags!
        echo=!_spec_names!
        echo=
        echo Required: [!_spec_required!]
        echo=
        goto 2> nul
        echo Receive
        call echo=%%*
    ) else if "%~1" == "validate_args" (
        echo Validate Args
        echo Required: [!_spec_required!]
    ) else if "%~1" == "capture_args" (
        echo Capture Arguments:
        echo=!_actions!
    ) else (
        echo Unknown DEBUG MSG '%~1'
    )
    echo ----------------------------------------
)
exit /b 0


:EOF
exit /b
