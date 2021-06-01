:entry_point > nul 2> nul
call %*
exit /b


:parse_version <return_var> <version>
set "%~1="
setlocal EnableDelayedExpansion
set "_version=#%~2"
set "_version=!_version:+=+#!"
for /f "tokens=1* delims=+" %%a in ("!_version!") do (
    set "_public=%%a"
    set "_local=+%%b"
    if "!_local!" == "+" (
        set "_local="
    ) else set "_local=!_local:+#=+!"
)
for %%t in (
    " ="
    ".= " "-=" "_="
    "alpha=a"
    "beta=b"
    "preview=c" "pre=c" "rc=c"
    "post=p" "rev=p" "r=p"
    "dev=d"
) do set "_public=!_public:%%~t!"
for %%s in (a b c p d) do (
    set "_public=!_public:%%s= %%s!"
    set "_public=!_public:%%s =%%s!"
)
set "_public=!_public:~1!"
set "_result="
set "_buffer="
for %%s in (!_public!) do (
    set "_segment=%%s"
    set "_type="
    set "_number="
    if "!_segment:~0,1!" GTR "9" (
        for %%t in (
            "D:p"
            "Ba:a" "Bb:b" "Bc:c"
            "A:d"
        ) do for /f "tokens=1-2 delims=:" %%a in (%%t) do (
            if "!_segment:~0,1!" == "%%b" set "_type=%%a"
        )
        set "_number=!_segment:~1!"
    )
    if not defined _type (
        set "_type=E"
        set "_number=!_segment!"
    )
    if not defined _number set "_number=0"
    set "_evaluated="
    set /a "_evaluated=!_number!" || ( 1>&2 echo error: failed to evaluate number & exit /b 2 )
    set /a "_number=!_evaluated!" || ( 1>&2 echo error: failed to evaluate number & exit /b 2 )
    set "_number=000!_number!"
    set "_number=!_number:~-3,3!"
    if not "!_type!" == "E" set "_buffer="
    set "_buffer=!_buffer!!_type!!_number!"
    if not "!_type!,!_number!" == "E,000" (
        set "_result=!_result!!_buffer!"
        set "_buffer="
    )
)
set "_result=F000!_result!C"
if defined _local (
    set "_local=!_local:~1!"
    set "_is_number="
    if defined _local (
        set "_temp=_!_local!"
        for %%c in (
            a b c d e f g h i j k l m
            n o p q r s t u v w x y z
            0 1 2 3 4 5 6 7 8 9 .
        ) do set "_temp=!_temp:%%c=!"
        if not "!_temp!" == "_" ( 1>&2 echo error: invalid local version identifier & exit /b 2 )

        set "_temp=_!_local!"
        for /l %%n in (0,1,9) do set "_temp=!_temp:%%n=!"
        if "!_temp!" == "_" set "_is_number=true"
    )
    if defined _is_number (
        for %%p in (10) do (
            for /l %%n in (1,1,%%p) do set "_local=0!_local!"
            set "_local=!_local:~-%%p,%%p!"
        )
        set "_local=B!_local!"
    ) else set "_local=A!_local!"
    set "_result=!_result!+!_local!"
)
for /f "tokens=*" %%r in ("!_result!") do (
    endlocal
    set "%~1=%%r"
)
exit /b 0


:lib.build_system [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=Input.string"
set "%~1category=packaging"
exit /b 0


:doc.man
::  NAME
::      parse_version - versions parser for comparing versions
::
::  SYNOPSIS
::      parse_version <return_var> <version>
::
::  DESCRIPTION
::      Abstracts handling of project version. This function is inspired by Python
::      PEP 440 and packaging.version.parse(). The parsed version is a string
::      representation of the version that can be used to compare different versions
::      using simple IF statements.
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the result.
::
::      version
::          The version of the script. Syntax of the version follows Python PEP 440,
::          except for the no Epoch support. For more information see version scheme
::          section. If the version is undefined, it is assumed to be '0'.
::
::  VERSION SCHEME
::                                  [N!]N(.N)*[{a|b|rc}N][.postN][.devN]
::      Repr  | Segment
::      F       Epoch               [N!]
::      E       Release                 N(.N)*
::      B       Pre-release                   [{a|b|rc}N]
::      D       Post-release                             [.postN]
::      A       Development release                              [.devN]
::      C       End of string
::
::      Although the Epoch segment in version is not supported, but it still have
::      its own internal representation in the result string.
::      The 'Repr' column is the internal representation of the version.
::
::  ALIASES
::      a   : a, alpha
::      b   : b, beta
::      rc  : rc, c, pre, preview
::      post: r, post
::      dev : dev
::
::  EXIT STATUS
::      0:  - Success.
::      2:  - Invalid version.
::
::  EXAMPLE
::      call :parse_version version1 "1.4.1"
::      call :parse_version version2 "1.4.1-a.2"
::      if "%version1%" GEQ "%version2%" echo True
::
::  NOTES
::      - Support for version numbers is only up to 3 digits of integer.
::        (e.g.: 999.999, 1.2.3.dev999)
::      - Numbers longer than 3 digits is truncated. (e.g.: 1.dev2345 -> 1.dev345)
exit /b 0


:doc.demo
call :Input.string version1 || set "version1=2.0a"
call :Input.string version2 || set "version2=2.0"
call :Input.string comparison || set "comparison=LSS"
echo=
call :parse_version version1.parsed !version1!
call :parse_version version2.parsed !version2!
echo '!version1!' %comparison% '!version2!'?
if "!version1.parsed!" %comparison% "!version2.parsed!" (
    echo True
) else echo False
exit /b 0


:tests.setup
set "return.true=0"
set "return.false=1"
exit /b 0


:tests.teardown
exit /b 0


:tests.test_representation
for %%a in (
    "F000C: "
    "F000C: 0"
    "F000C: 0.0"
    "F000E001C: 1"
    "F000E001C: 1.0"
    "F000E001C: 1.0.0"

    "F000A000C: .dev"
    "F000A000C: _dev"
    "F000A000C: -dev"
    "F000A001C: dev1"
    "F000A001C: dev.1"

    "F000Ba000C: .a"
    "F000Ba000C: _a"
    "F000Ba000C: -a"
    "F000Ba001C: a1"
    "F000Ba001C: a.1"

    "F000D000C: .r"
    "F000D000C: _r"
    "F000D000C: -r"
    "F000D001C: r1"
    "F000D001C: r.1"

    "F000A000C: dev"
    "F000Ba000C: a"
    "F000Ba000C: alpha"
    "F000Bb000C: b"
    "F000Bb000C: beta"
    "F000Bc000C: c"
    "F000Bc000C: rc"
    "F000Bc000C: pre"
    "F000Bc000C: preview"
    "F000D000C: r"
    "F000D000C: rev"
    "F000D000C: post"

    "F000A001C: dev1"
    "F000Ba002C: a2"
    "F000Bb003C: b3"
    "F000Bc004C: c4"
    "F000D005C: r5"

    "F000C+A: +"
    "F000C+Aa: +a"
    "F000C+A2a: +2a"
    "F000C+B0000000000: +0"

    "F000E001E002C: 1.2"
    "F000E001E002E003C: 1.2.3"
    "F000E001E002E003E004C: 1.2.3.4"

    "F000E001E000E003C: 1.0.3"
    "F000E001E000E000E004C: 1.0.0.4"

    "F000E001E000E002Ba000C+A123abc: 1.0.2a+123abc"
    "F000E001Ba000D000A000C+A: 1.0.0a.post.dev+"
    "F000E001E000E002Ba003D004A005C+B0000000001: 1.0.2-a3.post4.dev5+1"
) do for /f "tokens=1* delims=:" %%b in (%%a) do (
    set "given=%%c"
    call :parse_version result !given!
    set "expected=%%b"
    if not "!result!" == "!expected!" (
        call %unittest% fail "Given '!given!', expected '!expected!', got '!result!'"
    )
)
exit /b 0


:tests.test_comparison
for %%a in (
    "true:  1 EQU 1.0"
    "true:  1 EQU 1.0.0"
    "true:  1.1 EQU 1.1.0"
    "true:  1.0-a EQU 1.0-a.0"

    "true:  1.0-a EQU 1.0-alpha"
    "true:  1.0-b EQU 1.0-beta"
    "true:  1.0-rc EQU 1.0-c"
    "true:  1.0-rc EQU 1.0-pre"
    "true:  1.0-rc EQU 1.0-preview"

    "true:  1.4.1-a.5 NEQ 2.4.1-a.5"
    "true:  1.4.1-a.5 NEQ 1.5.1-a.5"
    "true:  1.4.1-a.5 NEQ 1.4.2-a.5"
    "true:  1.4.1-a.5 NEQ 1.4.1-b.5"
    "true:  1.4.1-a.5 NEQ 1.4.1-a.6"
    "false: 1.4.1-a.5 NEQ 1.4.1-a.5"

    "true:  1.4.1 LSS 1.4.2"
    "true:  1.4.1-a LSS 1.4.1.-b"
    "true:  1.4.1-b LSS 1.4.1.-rc"
    "true:  1.4.1-rc LSS 1.4.1"
    "true:  1.4.1-a LSS 1.4.1-a.1"

    "false: 1.4.1 LSS 1.4.1"
    "false: 1.4.1-a.5 LSS 1.4.1-a.5"

    "true:  1.4.2 GTR 1.4.1"
    "true:  1.4.1-b GTR 1.4.1-a"
    "true:  1.4.1-rc GTR 1.4.1-b"
    "true:  1.4.1 GTR 1.4.1-rc"
    "true:  1.4.1-a.1 GTR 1.4.1-a"

    "false: 1.4.1 GTR 1.4.1"
    "false: 1.4.1-a.5 GTR 1.4.1-a.5"

    "true:  1.4.1-a.5 GEQ 1.4.1-a.5"
    "true:  1.4.1-a.5 LEQ 1.4.1-a.5"

    "false: 1.4.1-b.4 GEQ 1.4.1-b.5"
    "false: 1.4.1-b.5 LEQ 1.4.1-b.4"

    "true:  0.dev LEQ 0+"
    "true:  0 LEQ 0+"
    "true:  0.post GTR 0+"

    "true:  0+1 GTR 0+"
    "true:  0+a GTR 0+"
    "true:  0+1 GTR 0+a"
    "true:  0+1 GTR 0+2a"
) do for /f "tokens=1* delims=: " %%b in (%%a) do (
    set "given=%%c"
    call :tests.compare !given!
    set "result=!errorlevel!"
    set "expected=!return.%%b!"
    if not "!result!" == "!expected!" (
        call %unittest% fail "Given '!given!', expected '!expected!', got '!result!'"
    )
)
exit /b 0
#+++

:tests.compare <version1> <comparison> <version2>
call :parse_version version1 "%~1"
call :parse_version version2 "%~3"
if "!version1!" %~2 "!version2!" exit /b 0
exit /b 1


:EOF  # End of File
exit /b
