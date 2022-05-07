:entry_point
call %*
exit /b


:version_parse <return_var> <version>
set "%~1="
setlocal EnableDelayedExpansion
set "_version=%~2"
for /f "tokens=1-3" %%a in ("a !_version!") do (
    if not "%%c" == "" ( 1>&2 echo%0: Version cannot contain whitespaces & exit /b 2 )
    set "_version=%%b"
)
if /i "!_version:~0,1!" == "v" set "_version=!_version:~1!"
call :version_parse._validate_syntax || exit /b
for /f "tokens=1 delims=+" %%a in ("v!_version!") do set "_public=%%a"
set "_public=!_public:~1!"
set "_tmp=!_version!+"
set "_local=!_tmp:*+=!"
if defined _local set "_local=!_local:~0,-1!"
if defined _local if not "!_local:+=!" == "!_local!" (
    1>&2 echo%0: Invalid local version label & exit /b 2
)
if not defined _public (
    1>&2 echo%0: Public version identifier cannot be empty & exit /b 2
)
call :version_parse._transform_public
call :version_parse._transform_local
set "_schemes=Y R E P D L F"
set "_possible_scheme=!_schemes!"
set "_recurring_scheme=R L"
set "_tmp=Y_x_0 !_public! !_local!"
for %%s in (!_possible_scheme!) do set "_tokens_%%s="
for %%p in (!_tmp!) do for /f "tokens=1-2* delims=_" %%s in ("%%p") do (
    set "_type=%%t"
    if "!_possible_scheme:%%s=!" == "!_possible_scheme!" (
        1>&2 echo%0: Invalid segment pattern & exit /b 2
    )
    if "!_recurring_scheme:%%s=!" == "!_recurring_scheme!" (
        set "_possible_scheme=!_possible_scheme:*%%s=!"
    ) else set "_possible_scheme=!_possible_scheme:*%%s=%%s!"
    set "_value=%%u"
    for /f "tokens=1* delims=0123456789" %%a in ("#0%%u#") do (
        if "%%a,%%b" == "#,#" (
            if "%%s" == "L" set "_type=n"
            for /f "tokens=1* delims=0" %%a in ("#0%%u") do set "_value=%%b"
            if not defined _value set "_value=0"
        ) else if not "%%s" == "L" (
            1>&2 echo%0: Invalid number: %%p & exit /b 2
        )
    )
    set "_digits=na"
    if not "!_type!" == "l" (
        for /l %%n in (12,-1,1) do if "!_value:~%%n!" == "" set "_digits=%%n"
        if "!_digits!" == "na" (
            1>&2 echo%0: Digits too long: %%u & exit /b 2
        )
        set "_digits=00!_digits!"
        set "_digits=!_digits:~-2,2!"
    )
    set "_tokens_%%s=!_tokens_%%s! %%s_!_type!_!_digits!_!_value!"
)
set "_tmp="
for %%p in (!_tokens_R!) do set "_tmp=%%p !_tmp!"
set "_tokens_R="
set "_remove=true"
for %%p in (!_tmp!) do (
    if defined _remove (
        if not "%%p" == "R_x_01_0" set "_remove="
    )
    if not defined _remove (
        set "_tokens_R= %%p!_tokens_R!"
    )
)
if not defined _tokens_R set "_tokens_R= R_x_01_0"
set "_result="
for %%s in (!_schemes!) do (
    set "_result=!_result!!_tokens_%%s!"
)
set "_result=!_result! F"
for /f "tokens=*" %%r in ("!_result!") do (
    endlocal
    set "%~1=%%r"
)
exit /b 0
#+++

:version_parse._validate_syntax
set "_tmp=.!_version!."
for %%c in (- _ .) do set "_tmp=!_tmp:%%c=.!"
set "_tmp=!_tmp:+=+.!"
if not "!_tmp:..=!" == "!_tmp!" (
    1>&2 echo%0: Invalid version syntax & exit /b 2
)
for %%c in (
    a b c d e f g h i j k l m
    n o p q r s t u v w x y z
    0 1 2 3 4 5 6 7 8 9 +
) do set "_tmp=!_tmp:%%c=.!"
set "_tmp=!_tmp:.=!"
if defined _tmp (
    1>&2 echo%0: Version contains invalid characters & exit /b 2
)
exit /b 0
#+++

:version_parse._transform_public
for %%t in (
    "E_\3: preview pre rc c"
    "E_\2: beta b"
    "E_\1: alpha a"
    "P_x: post rev r"
    "D_x: dev"
) do for /f "tokens=1-2 delims=:" %%r in (%%t) do (
    for %%a in (%%s) do set "_public=!_public:%%a={%%r}!"
)
for %%c in (- _ .) do (
    set "_public=!_public:%%c{={!"
    set "_public=!_public:}%%c=}!"
)
set "_public=.!_public!"
for %%a in (
    "\1=a" "\2=b" "\3=c"
    "{= " "}=_"
    ".= R_x_"
    "-= P_x_"
) do set "_public=!_public:%%~a!"
exit /b 0
#+++

:version_parse._transform_local
if not defined _local exit /b 0
for %%c in (
    a b c d e f g h i j k l m
    n o p q r s t u v w x y z
) do set "_local=!_local:%%c=%%c!"
for %%c in (- _ .) do set "_local=!_local:%%c=.!"
set "_local=.!_local!"
set "_local=!_local:.= L_l_!"
exit /b 0


:lib.dependencies [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=input_string"
set "%~1category=packaging"
exit /b 0


:doc.man
::  NAME
::      version_parse - version parser for comparing versions
::
::  SYNOPSIS
::      version_parse <return_var> <version>
::
::  DESCRIPTION
::      Abstracts handling of project version. This function is inspired by Python
::      PEP 440 and packaging.version.parse(). The parsed version is a string
::      representation of the version that can be used to compare different versions
::      using simple IF statements.
::
::      Link to PEP440: https://www.python.org/dev/peps/pep-0440/
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
::      Version identifiers MUST comply with the following scheme:
::
::                          [N!]N(.N)*[{a|b|rc}N][.postN][.devN][+<local>]
::      Segment
::      Epoch               [N!]
::      Release                 N(.N)*
::      Pre-release                   [{a|b|rc}N]
::      Post-release                             [.postN]
::      Development release                              [.devN]
::      Local Version label                                     [+<local>]
::
::      The Epoch segment is not supported because the exclamation mark '!' is a
::      special character in batch script. Local version label MUST only contain
::      ASCII letters ([a-zA-Z]), ASCII digits ([0-9]), and periods (.).
::
::  ALIASES
::      a   : a, alpha
::      b   : b, beta
::      rc  : rc, c, pre, preview
::      post: r, post
::      dev : dev
::
::  EXIT STATUS
::      0:  - Success
::      2:  - Invalid Version
::          - Digits too long
::
::  EXAMPLE
::      call :version_parse version1 "1.4.1"
::      call :version_parse version2 "1.4.1-a.2"
::      if "%version1%" GEQ "%version2%" echo True
::
::  NOTES
::      - Support for version numbers is only up to 12 digits of integer.
::        (e.g. 987654321012 is ok, 9876543210123 is too long)
exit /b 0


:doc.dev
::  REPRESENTATION
::                                 [N!]N(.N)*[{a|b|rc}N][.postN][.devN][+<local>]
::      Repr | Segment
::      Y      Epoch               [N!]
::      R      Release                 N(.N)*
::      E      Pre-release                   [{a|b|rc}N]
::      P      Post-release                             [.postN]
::      D      Development release                              [.devN]
::      L      Local Version label                                     [+<local>]
::      F      End of String
::
::      The Epoch segment is not supported, but the representation exist in the
::      result string.
::
::      Each segment is represented with the following pattern:
::
::          <segment>_<extra>_<length>_<value>
::
::      segment
::          A letter representing a segment. Used to determine segment precedence.
::
::      extra
::          Extra information of a segment. On pre-release segment, this is used
::          to store pre-release type (a, b, rc). On local version label, this is
::          used to store precedence information (numeric, lexical)
::
::      length
::          Length of the value. Unknown length is represented by 'na'.
::          Used to determine number precedence.
::
::      value
::          The value for the segment. This value is normalized.
exit /b 0


:doc.demo
call :input_string version1 || set "version1=2.0a"
call :input_string version2 || set "version2=2.0"
call :input_string comparison || set "comparison=LSS"
echo=
call :version_parse version1.parsed !version1!
call :version_parse version2.parsed !version2!
set /p "='!version1!' %comparison% '!version2!'? " < nul
if "!version1.parsed!" %comparison% "!version2.parsed!" (
    echo True
) else echo False
exit /b 0


:tests.setup
set "message.chars_invalid=Version contains invalid characters"
set "message.syntax_invalid=Invalid version syntax"
set "message.num_invalid=Invalid number"
set "message.segment_invalid=Invalid segment pattern"
set "message.public_empty=Public version identifier cannot be empty"
set "message.digits_too_long=Digits too long"
set "message.local_invalid=Invalid local version label"
exit /b 0


:tests.teardown
exit /b 0


:tests.test_invalidate_empty
call :tests.invalidate syntax_invalid ""
call :tests.invalidate syntax_invalid " "
exit /b 0


:tests.test_invalidate_public
for %%a in (
    "syntax_invalid: v"
    "syntax_invalid: -1"
    "syntax_invalid: 0..1"
    "num_invalid: invalid"
    "num_invalid: 1-invalid"
    "num_invalid: 1alphalpha"
    "segment_invalid: 1a2a3"
    "segment_invalid: 1cc"
    "segment_invalid: 1rpre"
    "digits_too_long: 9876543210123"
) do for /f "tokens=1* delims=: " %%b in (%%a) do (
    call :tests.invalidate %%b "%%c"
)
exit /b 0


:tests.test_invalidate_local
for %%a in (
    "syntax_invalid: 0+"
    "public_empty: +0"
    "local_invalid: 0++0"
    "local_invalid: 0+0+0"
    "chars_invalid: 0+#"
    "syntax_invalid: 0+0..0"
    "syntax_invalid: 0+0--0"
    "syntax_invalid: 0+0__0"
    "syntax_invalid: 0+.a"
    "syntax_invalid: 0+-a"
    "syntax_invalid: 0+_a"
    "syntax_invalid: 0+a."
    "syntax_invalid: 0+a-"
    "syntax_invalid: 0+a_"
) do for /f "tokens=1* delims=: " %%b in (%%a) do (
    call :tests.invalidate %%b "%%c"
)
exit /b 0


:tests.invalidate  <expected_message> <given>
set "expected=!message.%~1!"
set "given=%~2"
call :version_parse result !given! 2> "stderr.txt"
set "stderr="
set /p "stderr=" < "stderr.txt"
set "stderr=.!stderr!"
set "stderr=!stderr:*: =!"
for %%s in ("!expected!") do (
    if "!stderr:%%~s=!" == "!stderr!" (
        type "stderr.txt" 1>&2
        call %unittest% fail "Given '!given!', expected error message '!expected!'"
    )
)
exit /b 0


:tests.test_trim
call :version_parse expected "0.1a"
call :version_parse result "  0.1a  "
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:tests.test_normalize
for %%a in (
    "0: 0 0.0 0.0.0 0.0.0.0 v0 V0"
    "0.1: 0.1.0 0.1.0.0 0.1.0.0.0"
    "1a0: 1a 1alpha 1.a 1-a 1_a 1-alpha 1a.0 1a-0 1a_0 1-a.0"
    "1b2: 1-b2 1-beta2"
    "1rc0: 1rc 1Rc 1RC 1rC 1c 1pre 1preview"
    "1.post2: 1-post2 1-2 1r2"
    "1.dev23: 1dev23 1-dev23"
    "1rc0.post0.dev0: 1rcrdev"
    "0+0: 0+00000"
    "0+123: 0+00123"
    "0+aa.b.c.ddd: 0+aa-b-c-ddd 0+aa_b_c_ddd 0+aa-b_c.ddd"
    "0+abcxyz0189: 0+ABCXYZ0189"
) do for /f "tokens=1* delims=: " %%b in (%%a) do (
    call :version_parse normalized %%b && (
        for %%d in (%%c) do (
            call :version_parse alternative %%d
            if not "!alternative!" == "!normalized!" (
                call %unittest% fail "Given '%%b', expected equal to '%%d'"
            )
        )
    ) || call %unittest% fail "Given '%%b', expected success"
)
exit /b 0


:tests.test_compare_segment
for %%a in (
    "1.dev0  1"
    "1rc0  1"
    "1  1+0"
    "1  1.post0"
    "2  2.1"

    "1.2dev0  1.2"
    "1.2rc0  1.2"
    "1.2  1.2+0"
    "1.2  1.2.post0"
    "1.2  2.1"

    "1.dev0  1a0"
    "1a0  1b0"
    "1a0  1rc0"
    "1b0  1rc0"
    "1rc0  1rc0+0"
    "1rc0  1rc0.post0"
    "2rc0  2.2rc0"
    "2rc0  10rc0"

    "1.dev0  1.post0"
    "1rc0  1.post0"
    "1.post0  1.post0+0"
    "2.post0  2.1.post0"
    "2.post0  10.post0"

    "1.dev0  1a.dev0"
    "1.dev0  1.dev0+0"
    "1.dev0  1.post0.dev0"
    "2.dev0  2.1.dev0"
    "2.dev0  10.dev0"

    "1.dev0+0  1+0"
    "1rc0+0  1+0"
    "1+0  1+0-0"
    "1+0  1.post0+0"
    "2+0  2.1+0"
    "2+0  10+0"
) do for /f "tokens=1* delims=: " %%b in (%%a) do (
    call :version_parse this "%%b"
    call :version_parse other "%%c"
    if not "!this!" LSS "!other!" (
        call %unittest% fail "Expected '%%b' less than '%%c'"
    )
    if not "!other!" GTR "!this!" (
        call %unittest% fail "Expected '%%b' greater than '%%c'"
    )
)
exit /b 0


:tests.test_compare_value
for %%a in (
    "2  10"
    "10  11"
    "987654321012  987654321013"

    "1.2  1.10"

    "1a2  1.a10"
    "1b2  1b10"
    "1rc2  1rc10"

    "1.post2  1.post10"

    "1.dev2  1.dev10"

    "1+a  1+z"
    "1+z  1+0"
    "1+0  1+1"
    "1+2  1+10"
) do for /f "tokens=1* delims=: " %%b in (%%a) do (
    call :version_parse this "%%b"
    call :version_parse other "%%c"
    if not "!this!" LSS "!other!" (
        call %unittest% fail "Expected '%%b' less than '%%c'"
    )
    if not "!other!" GTR "!this!" (
        call %unittest% fail "Expected '%%b' greater than '%%c'"
    )
)
exit /b 0


:EOF
exit /b
