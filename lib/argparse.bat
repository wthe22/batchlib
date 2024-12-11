:entry_point
call %*
exit /b


:argparse [-i] [-s] <spec> ... -- %*
setlocal EnableDelayedExpansion
set LF=^
%=REQUIRED=%
%=REQUIRED=%
call :argparse._read_opts %* || exit /b 2
call :argparse._read_spec %* || exit /b 2
call :argparse._validate_specs || exit /b 2
call :argparse._generate_instructions %* || exit /b 3
call :argparse._exec_instructions || exit /b 3
exit /b 0
#+++

:argparse._read_opts %* -> {_shifts}
set "_._name=argparse"
for %%v in (_ignore_unknown _stop_nonopt) do set "_.%%v="
call :argparse._read_opts._parse ^
    ^ "-n,--name:store                  :_._name" ^
    ^ "-i,--ignore-unknown :store_const :_._ignore_unknown=true" ^
    ^ "-s,--stop-nonopt:store_const     :_._stop_nonopt=true" ^
    ^ -- %*
set "_shifts=!_opt_shifts!"
for %%v in (_name _ignore_unknown _stop_nonopt) do set "%%v=!_.%%v!"
exit /b 0
#+++

:argparse._read_opts._parse %* -> {_shifts}
set "_shifts=0"
call :argparse._read_spec %*
call :argparse._validate_specs || exit /b 2
set "_self_shifts=!_shifts!"
set "_ignore_unknown="
set "_stop_nonopt=true"
call :argparse._generate_instructions %* || exit /b 3
set /a "_opt_shifts=!_shifts! - !_argc! - !_self_shifts!"
call :argparse._exec_instructions || exit /b 3
exit /b 0
#+++

:argparse._read_spec %* {_shifts*} -> {_specs}
for /l %%n in (1,1,!_shifts!) do shift /1
set "_specs="
for /l %%# in (1,1,10) do for /l %%# in (1,1,10) do (
    call set _value=%%1
    if not defined _value (
        1>&2 echo argparse: Missing -- seperator
        exit /b 2
    )
    if "!_value!" == "--" (
        set /a "_shifts+=1"
        exit /b 0
    )
    call set _value=%%~1
    for /f "tokens=1-2* delims=: " %%b in ("!_value!") do (
        set "_specs=!_specs!%%b:%%c:%%d!LF!"
    )
    shift /1
    set /a "_shifts+=1"
)
exit /b 1
#+++

:argparse._generate_instructions %* {_shifts*} {_specs} -> {_instructions} {_argc}
for /l %%i in (1,1,!_shifts!) do shift /1
set "_instructions="
set "_argc=0"
set "_stop_opt_parsing="
for /l %%# in (1,1,20) do for /l %%# in (1,1,20) do (
    call set _value=%%1
    if not defined _value exit /b 0
    set "_op="
    set "_for_next_use="
    set "_parse_opt="
    if not defined _stop_opt_parsing if "!_value!" == "--" (
        set "_stop_opt_parsing=true"
        set "_op=pass"
    )
    if not defined _stop_opt_parsing (
        if "!_value:~0,1!" == "-" set "_parse_opt=true"
    )
    if defined _parse_opt (
        for /f "tokens=1-2* delims=:" %%b in ("!_specs!") do ( rem
        ) & if not defined _op ( rem
            for %%f in (%%b) do if "!_value!" == "%%f" set _op="%%c:%%d"
            if defined _op (
                for %%a in (store append) do if "%%c" == "%%a" (
                    set "_for_next_use=true"
                )
            )
        )
        if not defined _ignore_unknown if not defined _op (
            1>&2 echo !_name!: Unknown option '!_value!'
            exit /b 3
        )
    )
    if not defined _op (
        if defined _stop_nonopt (
            if not defined _stop_opt_parsing set "_stop_opt_parsing=true"
        )
        set /a "_argc+=1"
        for /f "tokens=1* delims=:" %%a in ("!_specs!") do ( rem
        ) & if not defined _op (
            for %%t in (# #!_argc!) do (
                if "%%a" == "%%t" set _op="%%b"
            )
        )
    )
    if defined _for_next_use (
        set "_instructions=!_instructions! shift"
        shift /1
        set /a "_shifts+=1"
        call set _value=%%1
        if not defined _value (
            1>&2 echo !_name!: Expected argument for last option
            exit /b 2
        )
    )
    set "_instructions=!_instructions! !_op! shift"
    shift /1
    set /a "_shifts+=1"
)
echo argparse: Too many arguments
exit /b 1
#+++

:argparse._exec_instructions {_instructions}
(
    for /l %%i in (1,1,2) do goto 2> nul
    for %%i in (%_instructions%) do ( rem
    ) & for /f "tokens=1* delims=:" %%c in ("%%~i") do (
        if /i "%%c" == "append" (
            call set %%d=^!%%d^! %%1
            set "%%d=!%%d:^^=^!"
        )
        if /i "%%c" == "store" (
            call set "%%d=.%%~1"
            set "%%d=!%%d:^^=^!"
            set "%%d=!%%d:~1!"
        )
        if /i "%%c" == "append_const" (
            for /f "tokens=1* delims==" %%v in ("%%d") do set "%%v=!%%v!%%w"
        )
        if /i "%%c" == "store_const" set "%%d"
        if /i "%%c" == "shift" shift /1
    )
    ( call )
)
exit /b 2
#+++

:argparse._validate_specs {_specs}
setlocal EnableDelayedExpansion
set "_alphanum=ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
if not defined _specs (
    1>&2 echo argparse: No specs were provided
    exit /b 2
)
set "_all_specs= "
for /f "tokens=1-2* delims=:" %%b in ("!_specs!") do (
    set "_spec=%%b"
    if "!_spec:~0,1!" == "#" (
        if not "!_all_specs: %%b = !" == "!_all_specs!" (
            1>&2 echo argparse: Positional argument '%%b' already defined
            exit /b 2
        )
        set "_pos=!_spec:~1!"
        if defined _pos (
            set "_invalid="
            if !_pos! LSS 1 set "_invalid=true"
            if !_pos! GTR 400 set "_invalid=true"
            if defined _invalid (
                1>&2 echo argparse: Invalid positional argument '%%b'
                exit /b 2
            )
        )
        set "_all_specs=!_all_specs!%%b "
    ) else for %%o in (%%b) do (
        if not "!_all_specs: %%o = !" == "!_all_specs!" (
            1>&2 echo argparse: Flag '%%o' already defined
            exit /b 2
        )
        set "_flag=%%o"
        for /f "tokens=* delims=-" %%f in ("!_flag!") do set "_flag=%%f"
        if "!_flag!" == "%%o" set "_flag="
        if not defined _flag (
            1>&2 echo argparse: Invalid flag '%%o'
            exit /b 2
        )
        set "_all_specs=!_all_specs!%%o "
    )
    set "_invalid=true"
    for %%a in (
        store store_const append append_const
    ) do if "%%c" == "%%a" set "_invalid="
    if defined _invalid (
        1>&2 echo argparse: Invalid action '%%c'
        exit /b 2
    )
    set "_invalid="
    for /f "tokens=1* delims==" %%v in ("%%d.") do (
        if "%%v" == "." (
            1>&2 echo argparse: Spec '%%b' have no destination variable
            exit /b 2
        )
        set "_needs_value=?"
        for %%a in (store append) do if "%%c" == "%%a" set "_needs_value="
        for %%a in (store_const append_const) do if "%%c" == "%%a" set "_needs_value=true"
        if defined _needs_value if "%%w" == "" (
            1>&2 echo argparse: Spec '%%b' with action '%%c' requires a value to set
            exit /b 2
        )
        if not defined _needs_value if not "%%w" == "" (
            1>&2 echo argparse: Spec '%%b' with action '%%c' must not set any value
            exit /b 2
        )
    )
)
exit /b 0


:lib.dependencies [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=input_string"
set "%~1category=cli"
exit /b 0


:doc.man
::  NAME
::      argparse - parse options passed to script or function (deprecated)
::
::  SYNOPSIS
::      argparse [-i] [-s] <spec> ... -- %*
::
::  OPTIONS
::      Note: They must appear before all SPECs
::
::      -n, --name
::          Command name for use in error messages. By default it is 'argparse'.
::
::      -i, --ignore-unknown
::          Ignores unknown options and assume they are
::          positional arguments instead.
::
::      -s, --stop-nonopt
::          Stop scanning for options as soon as the first non-option argument
::          is seen. The rest is treated positional arguments.
::
::  POSITIONAL ARGUMENTS
::      spec
::          The list of arguments that should be parsed. The complete syntax can
::          be found in the PARSING SPECIFACTIONS section. Maximum specification
::          supported is 100
::
::      %*
::          The arguments to parse. Arguments MUST be obtained from '%*' (because
::          it consumes the caller's %1, %2, etc. argument), or else it will fail.
::          Maximum argument supported is 400.
::
::  PARSING SPECIFACTIONS
::      Each parsing specification is a string composed of:
::
::          <POSITION or FLAG>:<ACTION>:<VARIABLE>[=CONST]
::
::      POSITION
::          The position number for positional argument (e.g. #1, #2, ...),
::          with each flag seperated by comma. Positional argument starts with
::          hashtag, followed by the position number (starts from 1). To capture
::          all positional arguments, use '#' only.
::
::      FLAG
::          The flags to capture, with each flag seperated by comma. Flags can be
::          a short flag (e.g. -s), or a long flag (e.g. --hello, --hello-world).
::          Valid characters are alphanumeric and dash only.
::
::      ACTION
::          Specify how the arguments should be handled. Possible actions are:
::
::              store
::                  Store the (unquoted) argument's value to VARIABLE
::
::              store_const
::                  Store the value of CONST to VARIABLE
::
::              append
::                  Append the argument's value to VARIABLE,
::                  each seperated by a space, with quotes preserved.
::
::              append_const
::                  Append the value of CONST to VARIABLE, without being seperated
::
::      Do not use duplicate flags in specification. Although currently it is
::      not enforced/validated, it could cause unwanted behavior.
::
::  EXIT STATUS
::      0:  - Success.
::      2:  - Invalid specs.
::      3:  - Error while processing arguments
::
::  NOTES
::      - Multi-character short options are not supported.
::        (e.g: you must use 'ls -a -l' instead of 'ls -al')
::      - Function SHOULD be embedded into the script.
exit /b 0


:doc.demo
echo A DEMO function to submit rating
echo=
echo Usage: rate  ^<stars^> [-m MESSAGE] [-t TAG]
echo=
echo POSITIONAL ARGUMENTS
echo    stars
echo        The stars given as rating
echo=
echo OPTIONS
echo    -m, --message MESSAGE
echo        Submit the following message for the review.
echo=
echo    -t, --tag TAG
echo       Submit category tag. Can be used multiple times.
echo=
echo    --anonymous
echo        Submit as an anonymous user.
echo=
echo    -r, --recommend
echo        Recommend this rating. Can be used multiple times.
echo=
echo=
call :input_string parameters || (
    set parameters=5 -m "A True Masterpiece" -t Art -t "Paintings" --anonymous -r -r -r
)
echo=
echo Input parameters:
echo=!parameters!
echo=
call :doc.demo.rate !parameters!
exit /b 0
#+++

:doc.demo.rate
for %%v in (stars message tags is_anon recommendations) do set "p_%%v="
call :argparse --name "rate" ^
    ^ "#1:store                 :p_stars" ^
    ^ "-m,--message:store       :p_msg" ^
    ^ "--anonymous:store_const  :p_is_anon=true" ^
    ^ "-t,--tag:append          :p_tags" ^
    ^ "-r,--recommend:append_const :p_recommends= +1" ^
    ^ -- %* || ( 1>&2 echo parse failed & exit /b 2 )
echo=
echo Arguments:
set "p_"
echo=
set /a "p_recommends=!p_recommends!"
if defined p_is_anon (
    echo Anonymous has given a !p_stars!-star review
) else echo !username! has given a !p_stars!-star review
if defined p_msg (
    echo    "!p_msg!"
)
set /p "=Tags: " < nul
for %%t in (!p_tags!) do set /p "=%%~t, " < nul
echo=
echo Recommend (+!p_recommends!)
exit /b 0


:tests.setup
set "STDERR_REDIRECTION=2> nul"
for %%v in (
    argv argc opts
    flag_sc flag_ac flag_s flag_a
    argv1 argv2 argv3
    opt_a opt_r opt_g opt_v
) do set "p_%%v="
exit /b 0


:tests.teardown
exit /b 0


:tests.test_no_arg_error
call :argparse ^
    ^ %STDERR_REDIRECTION% && (
    call %unittest% fail "Success with no arguments"
)
exit /b 0


:tests.test_missing_seperator_error
call :argparse ^
    ^ "-a:store:a" ^
    ^ "-b:store:b" ^
    ^ %STDERR_REDIRECTION% && (
    call %unittest% fail "Success with specs"
)
exit /b 0


:tests.test_no_spec_error
call :argparse ^
    ^ -- %STDERR_REDIRECTION% && (
    call %unittest% fail "Success with no specs"
)
exit /b 0


:tests.test_validate
setlocal EnableDelayedExpansion EnableExtensions
call :argparse ^
    ^ "#:append                 :p_argv" ^
    ^ "#1:store                 :p_arg_1" ^
    ^ "#10:store                :p_arg_10" ^
    ^ "-h,--help:store_const    :p_flag_sc=true" ^
    ^ "--plus:append_const      :p_flag_ac=+1" ^
    ^ "-s:store                 :p_flag_s" ^
    ^ "--append:append          :p_flag_a" ^
    ^ "--hello-world:store      :p_flag_s" ^
    ^ -- || (
    call %unittest% fail "Validate correct syntax"
)
exit /b 0


:tests.test_invalidate_no_variable
call :argparse ^
    ^ "#:store_const" ^
    ^ -- %STDERR_REDIRECTION% && (
    call %unittest% fail "Success using function without variable defined"
)
exit /b 0


:tests.test_invalidate_argv_index_number
call :argparse ^
    ^ "#z:store_const  :p_argv=" ^
    ^ -- %STDERR_REDIRECTION% && (
    call %unittest% fail "Success with invalid argv index"
)
exit /b 0


:tests.test_invalidate_neither_name_or_flag
call :argparse ^
    ^ "z:store_const  :p_argv=" ^
    ^ -- %STDERR_REDIRECTION% && (
    call %unittest% fail "Success with invalid argv index syntax"
)
exit /b 0


:tests.test_invalidate_missing_flag_name
call :argparse ^
    ^ "-:store_const    :p_flag_sc=true" ^
    ^ "--:store_const    :p_flag_sc=true" ^
    ^ -- %STDERR_REDIRECTION% && (
    call %unittest% fail "Success with invalid short flag letter"
)
exit /b 0


:tests.test_invalidate_action
call :argparse ^
    ^ "#:hello    :p_flag_sc=true" ^
    ^ -- %STDERR_REDIRECTION% && (
    call %unittest% fail "Success with invalid short flag letter"
)
exit /b 0


:tests.test_invalidate_append_with_const
call :argparse ^
    ^ "#:append    :p_flag_a=invalid" ^
    ^ -- %STDERR_REDIRECTION% && (
    call %unittest% fail "Success using append with undesirable CONST"
)
exit /b 0


:tests.test_invalidate_store_with_const
call :argparse ^
    ^ "#:store     :p_flag_s=invalid" ^
    ^ -- %STDERR_REDIRECTION% && (
    call %unittest% fail "Success using store with undesirable CONST"
)
exit /b 0


:tests.test_invalidate_append_const_without_const
call :argparse ^
    ^ "#:append_const  :p_flag_ac" ^
    ^ -- %STDERR_REDIRECTION% && (
    call %unittest% fail "Success using append_const without defining CONST"
)
exit /b 0


:tests.test_invalidate_store_const_without_const
call :argparse ^
    ^ "#:store_const     :p_flag_sc" ^
    ^ -- %STDERR_REDIRECTION% && (
    call %unittest% fail "Success using store_const without defining CONST"
)
exit /b 0


:tests.test_invalidate_multiple_arg_definition
call :argparse ^
    ^ "#:store_const     :p_flag_sc=1" ^
    ^ "#:store_const     :p_flag_sc=2" ^
    ^ -- %STDERR_REDIRECTION% && (
    call %unittest% fail
)
exit /b 0


:tests.test_invalidate_multiple_opt_definition
call :argparse ^
    ^ "-a,--alpha:store_const     :p_flag_sc=1" ^
    ^ "-a,--alpha:store_const     :p_flag_sc=2" ^
    ^ -- %STDERR_REDIRECTION% && (
    call %unittest% fail
)
exit /b 0


:tests.test_ignore_unknown
if ^"%1^" == "" (
    call :tests.test_ignore_unknown alpha  -r --golf victor
    exit /b
)
call :argparse --ignore-unknown ^
    ^ "#:append    :p_argv" ^
    ^ -- %* || (
    call %unittest% fail "Parse failed"
    exit /b 0
)
set expected= alpha -r --golf victor
set result=!p_argv!
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_command_name
if ^"%1^" == "" (
    call :tests.test_command_name -z
    exit /b
)
set "expected=hello"
call :argparse --name "!expected!" ^
    ^ "#:append    :p_argv" ^
    ^ -- %* 2> "error_msg" && (
    call %unittest% error "Cannot capture error message"
)
for /f "usebackq tokens=1 delims=:" %%a in ("error_msg") do set "result=%%a"
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_stop_nonopt
if ^"%1^" == "" (
    call :tests.test_stop_nonopt -a alpha --romeo -r
    exit /b
)
call :argparse --stop-nonopt ^
    ^ "#:append                 :p_argv" ^
    ^ "-a,--alpha:append_const  :p_opt_a=a" ^
    ^ "-r,--romeo:append_const  :p_opt_r=r" ^
    ^ -- %* || (
    call %unittest% fail "Parse failed"
    exit /b 0
)
set expected= alpha --romeo -r,a,
set result=!p_argv!,!p_opt_a!,!p_opt_r!
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_argv_append
if ^"%1^" == "" (
    call :tests.test_argv_append alpha "romeo"  "golf" victor
    exit /b
)
call :argparse ^
    ^ "#:append    :p_argv" ^
    ^ -- %* || (
    call %unittest% fail "Parse failed"
    exit /b 0
)
set expected= alpha "romeo" "golf" victor
set result=!p_argv!
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_argv_store
if ^"%1^" == "" (
    call :tests.test_argv_store alpha "romeo"
    exit /b
)
call :argparse ^
    ^ "#1:store    :p_argv1" ^
    ^ "#2:store    :p_argv2" ^
    ^ "#3:store    :p_argv3" ^
    ^ -- %* || (
    call %unittest% fail "Parse failed"
    exit /b 0
)
set expected=alpha,romeo,
set result=!p_argv1!,!p_argv2!,!p_argv3!
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_argv_append_const
if ^"%1^" == "" (
    call :tests.test_argv_append_const alpha romeo golf victor
    exit /b
)
call :argparse ^
    ^ "#:append_const   :p_argc=+1" ^
    ^ -- %* || (
    call %unittest% fail "Parse failed"
    exit /b 0
)
set expected=+1+1+1+1
set result=!p_argc!
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_flag_quoted
if ^"%1^" == "" (
    call :tests.test_flag_quoted "--alpha" "--romeo" "-g" victor
    exit /b
)
call :argparse ^
    ^ "#:append                 :p_argv" ^
    ^ "-a,--alpha:append_const  :p_opts=a" ^
    ^ "-r,--romeo:append_const  :p_opts=r" ^
    ^ "-g,--golf:append_const   :p_opts=g" ^
    ^ "-v,--victor:append_const :p_opts=v" ^
    ^ -- %* || (
    call %unittest% fail "Parse failed"
    exit /b 0
)
set expected= "--alpha" "--romeo" "-g" victor,
set result=!p_argv!,!p_opts!
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_flag_matching
if ^"%1^" == "" (
    call :tests.test_flag_matching -a -r -g -v --alpha --romeo --golf --vic-tor
    exit /b
)
call :argparse --ignore-unknown ^
    ^ "#:append                 :p_argv" ^
    ^ "-a:append_const          :p_opts=a" ^
    ^ "-r,--romeo:append_const  :p_opts=r" ^
    ^ "--golf:append_const      :p_opts=g" ^
    ^ "--vic-tor:append_const   :p_opts=v" ^
    ^ -- %* || (
    call %unittest% fail "Parse failed"
    exit /b 0
)
set expected= -g -v --alpha,arrgv
set result=!p_argv!,!p_opts!
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_opt_end
if ^"%1^" == "" (
    call :tests.test_opt_end --alpha --romeo -- -a -r
    exit /b
)
call :argparse ^
    ^ "#:append                 :p_argv" ^
    ^ "-a,--alpha:append_const  :p_opts=a" ^
    ^ "-r,--romeo:append_const  :p_opts=r" ^
    ^ -- %* || (
    call %unittest% fail "Parse failed"
    exit /b 0
)
set expected= -a -r,ar
set result=!p_argv!,!p_opts!
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_opt_store_none
if ^"%1^" == "" (
    call :tests.test_opt_store_none -a
    exit /b
)
call :argparse ^
    ^ "#:append        :p_argv" ^
    ^ "-a,--alpha:store    :p_opts" ^
    ^ -- %* %STDERR_REDIRECTION% && (
    call %unittest% fail "Success for store without expected argument"
)
exit /b 0


:tests.test_opt_append_none
if ^"%1^" == "" (
    call :tests.test_opt_append_none -a
    exit /b
)
call :argparse ^
    ^ "#:append        :p_argv" ^
    ^ "-a,--alpha:append   :p_opts" ^
    ^ -- %* %STDERR_REDIRECTION% && (
    call %unittest% fail "Success for store without expected argument"
)
exit /b 0


:tests.test_opt_store
if ^"%1^" == "" (
    call :tests.test_opt_store -a --alpha --romeo -r
    exit /b
)
call :argparse ^
    ^ "#:append        :p_argv" ^
    ^ "-a,--alpha:store    :p_opt_a" ^
    ^ "-r,--romeo:store    :p_opt_r" ^
    ^ -- %* || (
    call %unittest% fail "Parse failed"
    exit /b 0
)
set expected=,--alpha,-r
set result=!p_argv!,!p_opt_a!,!p_opt_r!
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_opt_append
if ^"%1^" == "" (
    call :tests.test_opt_append -a --alpha --romeo -r
    exit /b
)
call :argparse ^
    ^ "#:append        :p_argv" ^
    ^ "-a,--alpha:append   :p_opt_a" ^
    ^ "-r,--romeo:append   :p_opt_r" ^
    ^ -- %* || (
    call %unittest% fail "Parse failed"
    exit /b 0
)
set expected=, --alpha, -r
set result=!p_argv!,!p_opt_a!,!p_opt_r!
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_opt_store_const
if ^"%1^" == "" (
    call :tests.test_opt_store_const -a --alpha --romeo -r
    exit /b
)
call :argparse ^
    ^ "#:append            :p_argv" ^
    ^ "-a,--alpha:store_const  :p_opt_a=a" ^
    ^ "-r,--romeo:store_const  :p_opt_r=r" ^
    ^ -- %* || (
    call %unittest% fail "Parse failed"
    exit /b 0
)
set expected=,a,r
set result=!p_argv!,!p_opt_a!,!p_opt_r!
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_opt_append_const
if ^"%1^" == "" (
    call :tests.test_opt_append_const -a --alpha --romeo -r
    exit /b
)
call :argparse ^
    ^ "#:append            :p_argv" ^
    ^ "-a,--alpha:append_const :p_opt_a=a" ^
    ^ "-r,--romeo:append_const :p_opt_r=r" ^
    ^ -- %* || (
    call %unittest% fail "Parse failed"
    exit /b 0
)
set expected=,aa,rr
set result=!p_argv!,!p_opt_a!,!p_opt_r!
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_argv_special_chars
if ^"%1^" == "" (
    call :tests.test_argv_special_chars "^" "*" "?" "&" "=" "-" ";" ":" ""
    exit /b
)
call :argparse ^
    ^ "#:append            :p_argv" ^
    ^ -- %* || (
    call %unittest% fail "Parse failed"
    exit /b 0
)
set expected= "^" "*" "?" "&" "=" "-" ";" ":" ""
set result=!p_argv!
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '^!expected^!', got '^!result^!'"
)
exit /b 0


:tests.test_opt_special_chars
if ^"%1^" == "" (
    call :tests.test_opt_special_chars ^
        ^ --caret "^" ^
        ^ --asterisk "*" ^
        ^ --question-mark "?" ^
        ^ --ampersand "&" ^
        ^ --equal "=" ^
        ^ --dash "-" ^
        ^ --semicolon ";" ^
        ^ --colon ":" ^
        ^ --null ""
    exit /b
)
call :argparse ^
    ^ "#:append                :p_argv" ^
    ^ "-c,--caret:store            :p_crt" ^
    ^ "-w,--asterisk:store         :p_ast" ^
    ^ "-q,--question-mark:store    :p_qm" ^
    ^ "-a,--ampersand:store        :p_amp" ^
    ^ "-e,--equal:store            :p_eq" ^
    ^ "-d,--dash:store             :p_dash" ^
    ^ "-s,--semicolon:store        :p_sc" ^
    ^ "-o,--colon:store            :p_col" ^
    ^ "-n,--null:store             :p_null" ^
    ^ -- %* || (
    call %unittest% fail "Parse failed"
    exit /b 0
)
set "expected=,^,*,?,&,=,-,;,:,"
set "result=!p_argv!,!p_crt!,!p_ast!,!p_qm!,!p_amp!,!p_eq!,!p_dash!,!p_sc!,!p_col!,!p_null!"
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '^!p_argv^!', got '^!p_argv^!' + something else"
)
exit /b 0


:EOF
exit /b
