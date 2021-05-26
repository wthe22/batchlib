:entry_point > nul 2> nul
call %*
exit /b


:argparse [-i] [-s] <spec> [...] -- [arg] [...]
setlocal EnableDelayedExpansion
call :argparse._read_spec %* || exit /b 2
call :argparse._validate_specs %* || exit /b 2
call :argparse._generate_instructions %* || exit /b 3
call :argparse._exec_instructions 2 || exit /b 3
exit /b 0
#+++

:argparse._read_spec %*
set LF=^
%=REQUIRED=%
%=REQUIRED=%
set "_specs="
for %%v in (_validate _ignore_unknown _stop_nonopt) do set "%%v="
set "_shifts=0"
set "_mode=flag"
for /l %%# in (1,1,20) do for /l %%# in (1,1,20) do (
    call set _value=%%1
    set /a "_shifts+=1"
    if not defined _value (
        1>&2 echo argparse: missing -- seperator
        exit /b 2
    )
    if "!_value!" == "--" exit /b 0
    if "!_value:~0,1!,!_mode!" == "-,flag" (
        set "_valid="
        for %%s in (
            "-i --ignore-unknown:_ignore_unknown=true"
            "-s --stop-nonopt:_stop_nonopt=true"
        ) do for /f "tokens=1* delims=:" %%o in (%%s) do (
            for %%f in (%%o) do if "!_value!" == "%%f" (
                set "%%p"
                set "_valid=true"
            )
        )
        if not defined _valid ( 1>&2 echo argparse: unknown option '!_value!' )
    ) else (
        set "_mode=spec"
        call set _value=%%~1
        for /f "tokens=1-2* delims=: " %%o in ("!_value!") do (
            set "_specs=!_specs!%%o:%%p:%%q!LF!"
        )
    )
    shift /1
)
exit /b 1
#+++

:argparse._generate_instructions {_specs}
for /l %%i in (1,1,!_shifts!) do shift /1
set "_argc=0"
set "_nonopt_encountered="
for /l %%# in (1,1,20) do for /l %%# in (1,1,20) do (
    call set _value=%%1
    if not defined _value exit /b 0
    set "_op="
    set "_for_next_use="
    set "_parse_opt="
    if "!_value:~0,1!" == "-" set "_parse_opt=true"
    if defined _stop_nonopt (
        if defined _nonopt_encountered set "_parse_opt="
    )
    if defined _parse_opt (
        for /f "tokens=1-2* delims=:" %%o in ("!_specs!") do ( rem
        ) & if not defined _op ( rem
        ) & for /f "tokens=1* delims=/-" %%a in ("%%o") do (
            if not "%%o" == "%%a-%%b" if "!_value!" == "-%%a" set _op="%%p:%%q"
            if "!_value!" == "--%%b" set _op="%%p:%%q"
            if defined _op (
                for %%c in (store append) do if "%%p" == "%%c" (
                    set "_for_next_use=true"
                )
            )
        )
        if not defined _ignore_unknown if not defined _op (
            1>&2 echo argparse: unknown option '!_value!'
            exit /b 3
        )
    )
    if not defined _op (
        set "_nonopt_encountered=true"
        set /a "_argc+=1"
        for /f "tokens=1* delims=:" %%a in ("!_specs!") do ( rem
        ) & if not defined _op (
            for %%t in ([] []!_argc!) do (
                if "%%a" == "%%t" set _op="%%b"
            )
        )
    )
    if defined _for_next_use (
        set "_instructions=!_instructions! shift"
        shift /1
        call set _value=%%1
        if not defined _value (
            1>&2 echo argparse: expected argument for last option
            exit /b 2
        )
    )
    set "_instructions=!_instructions! !_op! shift"
    shift /1
)
exit /b 1
#+++

:argparse._exec_instructions [depth] {_instructions}
(
    for /l %%i in (1,1,%~1,1) do goto 2> nul
    for %%a in (%_instructions%) do ( rem
    ) & for /f "tokens=1* delims=:" %%p in ("%%~a") do (
        if /i "%%p" == "append" (
            call set %%q=^!%%q^! %%1
            set "%%q=!%%q:^^=^!"
        )
        if /i "%%p" == "store" (
            call set "%%q=.%%~1"
            set "%%q=!%%q:^^=^!"
            set "%%q=!%%q:~1!"
        )
        if /i "%%p" == "append_const" (
            for /f "tokens=1* delims==" %%e in ("%%q") do set "%%e=!%%e!%%f"
        )
        if /i "%%p" == "store_const" set "%%q"
        if /i "%%p" == "shift" shift /1
    )
    ( call )
)
exit /b 2
#+++

:argparse._validate_specs {_specs}
setlocal EnableDelayedExpansion
set "_alphanum=ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
if not defined _specs (
    1>&2 echo argparse: no specs were provided
    exit /b 2
)
for /f "tokens=1-2* delims=:" %%o in ("!_specs!") do (
    set "_flag=%%o"
    if "!_flag:~0,2!" == "[]" (
        if not "!_flag:~2,1!" == "" (
            set "_invalid="
            if !_flag:~2! LSS 1 set "_invalid=true"
            if !_flag:~2! GTR 400 set "_invalid=true"
            if defined _invalid (
                1>&2 echo argparse: parameter number '%%~c' invalid, must be integer ^(1-400^)
                exit /b 2
            )
        )
    ) else (
        set "_short_opt=!_flag:~0,1!"
        for %%c in ("!_short_opt!") do if "!_alphanum:%%~c=!" == "!_alphanum!" (
            1>&2 echo argparse: short flag '%%~c' invalid, must be alphanum
            exit /b 2
        )
        set "_invalid=true"
        set "_modifier=!_flag:~1,1!"
        for %%m in ("" "/" "-") do if "!_modifier!" == %%m set "_invalid="
        if defined _invalid (
            1>&2 echo argparse: invalid option modifier '!_modifier!'
            exit /b 2
        )
        set "_invalid=true"
        for /f "tokens=1* delims=/-" %%a in ("%%o") do (
            for %%s in ("%%a" "%%a/%%b" "%%a-%%b") do if "!_flag!" == %%s set "_invalid="
        )
        if defined _invalid (
            1>&2 echo argparse: invalid option spec '%%o'
            exit /b 2
        )
    )
    set "_invalid=true"
    for %%c in (
        store store_const append append_const
    ) do if "%%c" == "%%p" set "_invalid="
    if defined _invalid (
        1>&2 echo argparse: invalid action '%%p'
        exit /b 2
    )
    set "_invalid="
    for /f "tokens=1* delims==" %%a in ("%%q.") do (
        if "%%a" == "." (
            1>&2 echo argparse: no variable given to store result
            exit /b 2
        )
        for %%c in (store append) do if "%%c" == "%%p" (
            if not "%%b" == "" set "_invalid=true"
        )
        if defined _invalid (
            1>&2 echo argparse: action '%%p' must not set any value
            exit /b 2
        )
        for %%c in (store_const append_const) do if "%%c" == "%%p" (
            if "%%b" == "" set "_invalid=true"
        )
        if defined _invalid (
            1>&2 echo argparse: action '%%p' requires a value to set
            exit /b 2
        )
    )
)
exit /b 0


:lib.build_system
set "%~1install_requires= "
set "%~1extra_requires=Input.string"
set "%~1category=devtools"
exit /b 0


:doc.man
::  NAME
::      argparse - parse options passed to script or function
::
::  SYNOPSIS
::      argparse [-i] [-s] <spec> [...] -- [arg] [...]
::
::  OPTIONS
::      Note: They must appear before all SPECs
::
::      -i, --ignore-unknown
::          Ignores unknown options and assume they are
::          positional arguments instead.
::
::      -s, --stop-nonopt
::          Stop scanning for options as soon as
::          the first non-option argument is seen.
::
::  PARSING SPECIFACTIONS
::      Each parsing specification is a string composed of:
::
::          <SHORT_FLAG>[</ or -><LONG_FLAG>]:<ACTION>:<VARIABLE>[=CONST]
::
::      SHORT_FLAG
::          A short flag letter (which is mandatory). It must be an alphanumeric
::          character.
::
::       / or -
::          Use '/' if the short flag can be used.
::          Use '-' if it should not be exposed as a valid short flag.
::              (i.e. only long flags can be used)
::
::      LONG_FLAG
::          A long flag name which is optional. If not present then only the
::          short flag letter can be used.
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
::  EXIT STATUS
::      0:  - Success.
::      2:  - Invalid specs.
::      3:  - Error while processing arguments
::
::  NOTES
::      - Multi-character short options are not supported.
::        (e.g: you must use 'ls -a -l' instead of 'ls -al')
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
call :Input.string parameters || (
    set parameters=5 -m "A True Masterpiece" -t Art -t "Paintings" --anonymous -r -r -r
)
echo=
echo Input parameters:
echo=!parameters!
call :doc.demo.rate !parameters!
exit /b 0
#+++

:doc.demo.rate
for %%v in (stars message tags is_anon recommendations) do set "p_%%v="
call :argparse ^
    ^ "[]1:store                :p_stars" ^
    ^ "m/message:store          :p_msg" ^
    ^ "a-anonymous:store_const  :p_is_anon=true" ^
    ^ "t/tag:append             :p_tags" ^
    ^ "r/recommend:append_const :p_recommends= +1" ^
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


:doc.demo
@setlocal EnableDelayedExpansion
@echo off
set "p_"
echo a[%*] 1[%1] [%2]
exit /b


:tests.setup
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
    ^ 2> nul && (
    call %unittest% fail "success with no arguments"
)
exit /b 0


:tests.test_missing_seperator_error
call :argparse ^
    ^ "a:store:a" ^
    ^ "b:store:b" ^
    ^ 2> nul && (
    call %unittest% fail "success with specs"
)
exit /b 0


:tests.test_no_spec_error
call :argparse ^
    ^ -- 2> nul && (
    call %unittest% fail "success with no specs"
)
exit /b 0


:tests.test_validate
setlocal EnableDelayedExpansion EnableExtensions
call :argparse ^
    ^ "[]:append            :p_argv" ^
    ^ "[]1:store            :p_arg0" ^
    ^ "h/help:store_const   :p_flag_sc=true" ^
    ^ "p-plus:append_const  :p_flag_ac=+1" ^
    ^ "s:store              :p_flag_s" ^
    ^ "a-append:append      :p_flag_a" ^
    ^ "r/:store             :p_flag_s" ^
    ^ "g-hello-world:store  :p_flag_s" ^
    ^ -- || (
    call %unittest% fail "validate correct syntax"
)
exit /b 0


:tests.test_invalidate_no_variable
call :argparse ^
    ^ "[]:store_const" ^
    ^ -- 2> nul && (
    call %unittest% fail "success using function without variable defined"
)
exit /b 0


:tests.test_invalidate_argv_index_number
call :argparse ^
    ^ "[]z:store_const  :p_argv=" ^
    ^ -- 2> nul && (
    call %unittest% fail "success with invalid argv index"
)
exit /b 0


:tests.test_invalidate_argv_index_syntax
call :argparse ^
    ^ "[1]:store_const  :p_argv=" ^
    ^ -- 2> nul && (
    call %unittest% fail "success with invalid argv index syntax"
)
exit /b 0


:tests.test_invalidate_option_modifier
call :argparse ^
    ^ "s#save:store_const   :p_flag_sc=true" ^
    ^ -- 2> nul && (
    call %unittest% fail "success with invalid option modifier"
)
exit /b 0


:tests.test_invalidate_short_option
call :argparse ^
    ^ "-:store_const    :p_flag_sc=true" ^
    ^ -- 2> nul && (
    call %unittest% fail "success with invalid short flag letter"
)
exit /b 0


:tests.test_invalidate_action
call :argparse ^
    ^ "[]:hello    :p_flag_sc=true" ^
    ^ -- 2> nul && (
    call %unittest% fail "success with invalid short flag letter"
)
exit /b 0


:tests.test_invalidate_append_with_const
call :argparse ^
    ^ "[]:append    :p_flag_a=invalid" ^
    ^ -- 2> nul && (
    call %unittest% fail "success using append with undesirable CONST"
)
exit /b 0


:tests.test_invalidate_store_with_const
call :argparse ^
    ^ "[]:store     :p_flag_s=invalid" ^
    ^ -- 2> nul && (
    call %unittest% fail "success using store with undesirable CONST"
)
exit /b 0


:tests.test_invalidate_append_const_without_const
call :argparse ^
    ^ "[]:append_const  :p_flag_ac" ^
    ^ -- 2> nul && (
    call %unittest% fail "success using append_const without defining CONST"
)
exit /b 0


:tests.test_invalidate_store_const_without_const
call :argparse ^
    ^ "[]:store_const     :p_flag_sc" ^
    ^ -- 2> nul && (
    call %unittest% fail "success using store_const without defining CONST"
)
exit /b 0


:tests.test_ignore_unknown
if ^"%1^" == "" (
    call :tests.test_ignore_unknown alpha  -r --golf victor
    exit /b
)
call :argparse --ignore-unknown ^
    ^ "[]:append    :p_argv" ^
    ^ -- %* || (
    call %unittest% fail "parse failed"
    exit /b 0
)
set expected= alpha -r --golf victor
set result=!p_argv!
if not "!result!" == "!expected!" (
    call %unittest% fail "expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_stop_nonopt
if ^"%1^" == "" (
    call :tests.test_stop_nonopt -a alpha --romeo -r
    exit /b
)
call :argparse --stop-nonopt ^
    ^ "[]:append            :p_argv" ^
    ^ "a/alpha:append_const :p_opt_a=a" ^
    ^ "r/romeo:append_const :p_opt_r=r" ^
    ^ -- %* || (
    call %unittest% fail "parse failed"
    exit /b 0
)
set expected= alpha --romeo -r,a,
set result=!p_argv!,!p_opt_a!,!p_opt_r!
if not "!result!" == "!expected!" (
    call %unittest% fail "expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_argv_append
if ^"%1^" == "" (
    call :tests.test_argv_append alpha "romeo"  "golf" victor
    exit /b
)
call :argparse ^
    ^ "[]:append    :p_argv" ^
    ^ -- %* || (
    call %unittest% fail "parse failed"
    exit /b 0
)
set expected= alpha "romeo" "golf" victor
set result=!p_argv!
if not "!result!" == "!expected!" (
    call %unittest% fail "expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_argv_store
if ^"%1^" == "" (
    call :tests.test_argv_store alpha "romeo"
    exit /b
)
call :argparse ^
    ^ "[]1:store    :p_argv1" ^
    ^ "[]2:store    :p_argv2" ^
    ^ "[]3:store    :p_argv3" ^
    ^ -- %* || (
    call %unittest% fail "parse failed"
    exit /b 0
)
set expected=alpha,romeo,
set result=!p_argv1!,!p_argv2!,!p_argv3!
if not "!result!" == "!expected!" (
    call %unittest% fail "expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_argv_append_const
if ^"%1^" == "" (
    call :tests.test_argv_append_const alpha romeo golf victor
    exit /b
)
call :argparse ^
    ^ "[]:append_const  :p_argc=+1" ^
    ^ -- %* || (
    call %unittest% fail "parse failed"
    exit /b 0
)
set expected=+1+1+1+1
set result=!p_argc!
if not "!result!" == "!expected!" (
    call %unittest% fail "expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_opt_quoted
if ^"%1^" == "" (
    call :tests.test_opt_quoted "--alpha" "--romeo" "-g" victor
    exit /b
)
call :argparse ^
    ^ "[]:append                :p_argv" ^
    ^ "a/alpha:append_const     :p_opts=a" ^
    ^ "r/romeo:append_const     :p_opts=r" ^
    ^ "g/golf:append_const      :p_opts=g" ^
    ^ "v/victor:append_const    :p_opts=v" ^
    ^ -- %* || (
    call %unittest% fail "parse failed"
    exit /b 0
)
set expected= "--alpha" "--romeo" "-g" victor,
set result=!p_argv!,!p_opts!
if not "!result!" == "!expected!" (
    call %unittest% fail "expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_opt_modifier
if ^"%1^" == "" (
    call :tests.test_opt_modifier -a -r -g -v --alpha --romeo --golf --victor
    exit /b
)
call :argparse --ignore-unknown ^
    ^ "[]:append                :p_argv" ^
    ^ "a:append_const           :p_opts=a" ^
    ^ "r/romeo:append_const     :p_opts=r" ^
    ^ "g/golf:append_const      :p_opts=g" ^
    ^ "v-victor:append_const    :p_opts=v" ^
    ^ -- %* || (
    call %unittest% fail "parse failed"
    exit /b 0
)
set expected= -v --alpha,argrgv
set result=!p_argv!,!p_opts!
if not "!result!" == "!expected!" (
    call %unittest% fail "expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_opt_store_none
if ^"%1^" == "" (
    call :tests.test_opt_store_none -a
    exit /b
)
call :argparse ^
    ^ "[]:append        :p_argv" ^
    ^ "a/alpha:store    :p_opts" ^
    ^ -- %* 2> nul && (
    call %unittest% fail "success for store without expected argument"
)
exit /b 0


:tests.test_opt_append_none
if ^"%1^" == "" (
    call :tests.test_opt_append_none -a
    exit /b
)
call :argparse ^
    ^ "[]:append        :p_argv" ^
    ^ "a/alpha:append   :p_opts" ^
    ^ -- %* 2> nul && (
    call %unittest% fail "success for store without expected argument"
)
exit /b 0


:tests.test_opt_store
if ^"%1^" == "" (
    call :tests.test_opt_store -a --alpha --romeo -r
    exit /b
)
call :argparse ^
    ^ "[]:append        :p_argv" ^
    ^ "a/alpha:store    :p_opt_a" ^
    ^ "r/romeo:store    :p_opt_r" ^
    ^ -- %* || (
    call %unittest% fail "parse failed"
    exit /b 0
)
set expected=,--alpha,-r
set result=!p_argv!,!p_opt_a!,!p_opt_r!
if not "!result!" == "!expected!" (
    call %unittest% fail "expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_opt_append
if ^"%1^" == "" (
    call :tests.test_opt_append -a --alpha --romeo -r
    exit /b
)
call :argparse ^
    ^ "[]:append        :p_argv" ^
    ^ "a/alpha:append   :p_opt_a" ^
    ^ "r/romeo:append   :p_opt_r" ^
    ^ -- %* || (
    call %unittest% fail "parse failed"
    exit /b 0
)
set expected=, --alpha, -r
set result=!p_argv!,!p_opt_a!,!p_opt_r!
if not "!result!" == "!expected!" (
    call %unittest% fail "expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_opt_store_const
if ^"%1^" == "" (
    call :tests.test_opt_store_const -a --alpha --romeo -r
    exit /b
)
call :argparse ^
    ^ "[]:append            :p_argv" ^
    ^ "a/alpha:store_const  :p_opt_a=a" ^
    ^ "r/romeo:store_const  :p_opt_r=r" ^
    ^ -- %* || (
    call %unittest% fail "parse failed"
    exit /b 0
)
set expected=,a,r
set result=!p_argv!,!p_opt_a!,!p_opt_r!
if not "!result!" == "!expected!" (
    call %unittest% fail "expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_opt_append_const
if ^"%1^" == "" (
    call :tests.test_opt_append_const -a --alpha --romeo -r
    exit /b
)
call :argparse ^
    ^ "[]:append            :p_argv" ^
    ^ "a/alpha:append_const :p_opt_a=a" ^
    ^ "r/romeo:append_const :p_opt_r=r" ^
    ^ -- %* || (
    call %unittest% fail "parse failed"
    exit /b 0
)
set expected=,aa,rr
set result=!p_argv!,!p_opt_a!,!p_opt_r!
if not "!result!" == "!expected!" (
    call %unittest% fail "expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_argv_special_chars
if ^"%1^" == "" (
    call :tests.test_argv_special_chars "^" "*" "?" "&" "=" "-" ";" ":" ""
    exit /b
)
call :argparse ^
    ^ "[]:append            :p_argv" ^
    ^ -- %* || (
    call %unittest% fail "parse failed"
    exit /b 0
)
set expected= "^" "*" "?" "&" "=" "-" ";" ":" ""
set result=!p_argv!
if not "!result!" == "!expected!" (
    call %unittest% fail "expected '^!expected^!', got '^!result^!'"
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
    ^ "[]:append                :p_argv" ^
    ^ "c/caret:store            :p_crt" ^
    ^ "w/asterisk:store         :p_ast" ^
    ^ "q/question-mark:store    :p_qm" ^
    ^ "a/ampersand:store        :p_amp" ^
    ^ "e/equal:store            :p_eq" ^
    ^ "d/dash:store             :p_dash" ^
    ^ "s/semicolon:store        :p_sc" ^
    ^ "o/colon:store            :p_col" ^
    ^ "n/null:store             :p_null" ^
    ^ -- %* || (
    call %unittest% fail "parse failed"
    exit /b 0
)
set "expected=,^,*,?,&,=,-,;,:,"
set "result=!p_argv!,!p_crt!,!p_ast!,!p_qm!,!p_amp!,!p_eq!,!p_dash!,!p_sc!,!p_col!,!p_null!"
if not "!result!" == "!expected!" (
    call %unittest% fail "expected '^!p_argv^!', got '^!p_argv^!' + something else"
)
exit /b 0


:EOF  # End of File
exit /b
