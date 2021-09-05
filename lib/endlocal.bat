:entry_point
call %*
exit /b


:endlocal <old[:new]> ...
setlocal EnableDelayedExpansion
set LF=^
%=REQUIRED=%
%=REQUIRED=%
for %%v in (_content _value) do (
    if defined endlocal.%%v (
        ( 1>&2 echo%0: Interal variable 'endlocal.%%v' is used & exit /b 2 )
    )
)
for %%v in (%*) do for /f "tokens=1-2 delims=:" %%a in ("%%~v:%%~v") do (
    set "endlocal._value=^!!%%a!"
    call :endlocal._to_ede
    set "endlocal._content=!endlocal._content!%%b=!endlocal._value!!LF!"
)
for /f "delims= eol=" %%a in ("!endlocal._content!") do ( rem
) & for /f "tokens=1 delims==" %%b in ("%%a") do (
    if defined endlocal._content (
        goto 2> nul
        endlocal
    )
    set "%%a"
    if not "!!" == "" (
        setlocal EnableDelayedExpansion
        set "endlocal._value=!%%b!"
        call :endlocal._to_dde
        for /f "tokens=* delims=" %%c in ("=!endlocal._value!") do (
            endlocal
            set "%%b%%c"
        )
    )
    call set "%%b=%%%%b:~1%%"
)
exit /b 0
#+++

:endlocal._to_ede
set "endlocal._value=!endlocal._value:^=^^^^!"
set "endlocal._value=%endlocal._value:!=^^^!%"
exit /b
#+++

:endlocal._to_dde
set "endlocal._value=%endlocal._value%"
exit /b


:lib.dependencies [return_prefix]
set "%~1install_requires= "
set "%~1category=devtools"
exit /b 0


:doc.man
::  NAME
::      endlocal - make variables survive ENDLOCAL
::
::  SYNOPSIS
::      endlocal <old[:new]> ...
::
::  POSITIONAL ARGUMENTS
::      old
::          Variable name to keep (before endlocal).
::
::      new
::          Variable name to use (after endlocal). By default, the
::          new variable name is the same as the old variable name.
::
::  NOTES
::      - Variables that contains Line Feed character are not supported and it
::        could cause unexpected errors.
::      - In the code, adding exclamation mark at beginning of string is required
::        to trigger caret escaping behavior on quoted strings.
::
::  EXIT STATUS
::      0:  - Success.
::      2:  - Interal variable 'endlocal.*' is used.
exit /b 0


:doc.demo
set "var_del=This variable will be deleted"
set "var_keep=This variable will keep its content"
set "var_"
echo=
echo [setlocal]
setlocal EnableDelayedExpansion
echo=
set "var_del="
set "var_keep=Attempting to change it"
set "var_hello=I am a new variable^! ^^^^"
set "var_"
echo=
echo [endlocal]
call :endlocal var_del var_hello:var_new_name
echo=
set "var_"
exit /b 0


:tests.setup
:tests.teardown
exit /b 0


:tests.test_basic
if ^"%1^" == "" (
    for %%s in (
        Enable Disable
    ) do call :tests.test_basic "%%s"
    exit /b 0
)
setlocal EnableDelayedExpansion
set "initial.null=a b c"
set "initial.old=d e f g h"
set "local.changed=b c e g"
set "local.deleted=f h"
set "local.persist=c g h"
set "expected.null=a b h"
set "expected.old=d e f"
set "expected.changed=c g"

for %%v in (!initial.null!) do set "var.%%v="
for %%v in (!initial.old!) do set "var.%%v=old"

set "local.persist_vars="
for %%v in (!local.persist!) do (
    set "local.persist_vars=!local.persist_vars! var.%%v"
)

setlocal %~1DelayedExpansion
setlocal EnableDelayedExpansion
for %%v in (%local.changed%) do set "var.%%v=changed"
for %%v in (%local.deleted%) do set "var.%%v="
call :endlocal %local.persist_vars%

setlocal EnableDelayedExpansion
for %%v in (!expected.null!) do (
    if defined var.%%v (
        call %unittest% fail "%~1DE '%%v'"
    )
)
for %%v in (!expected.old!) do (
    if not "!var.%%v!" == "old" (
        call %unittest% fail "%~1DE '%%v'"
    )
)
for %%v in (!expected.changed!) do (
    if not "!var.%%v!" == "changed" (
        call %unittest% fail "%~1DE '%%v'"
    )
)
exit /b 0


:tests.test_special_chars
if ^"%1^" == "" (
    for %%s in (
        Enable Disable
    ) do call :tests.test_special_chars "%%s"
    exit /b 0
)
setlocal EnableDelayedExpansion
set persist= ^
    ^ dquotes dquotes2 ^
    ^ qmark ^
    ^ asterisk ^
    ^ colon ^
    ^ semicolon ^
    ^ caret caret2 ^
    ^ ampersand ^
    ^ equal ^
    ^ bang ^
    ^ pipe ^
    ^ percent ^
    ^ lab rab
set "persist_vars="
for %%v in (!persist!) do (
    set "var.%%v="
    set "persist_vars=!persist_vars! var.%%v"
)

setlocal %~1DelayedExpansion
setlocal EnableDelayedExpansion
call :tests.assets.set_special_chars var.
call :endlocal %persist_vars%

setlocal EnableDelayedExpansion
call :tests.assets.set_special_chars expected.
for %%v in (!persist!) do (
    if not "[!var.%%v!]" == "[!expected.%%v!]" (
        call %unittest% fail "%~1DE '%%v'"
    )
)
exit /b 0


:tests.assets.set_special_chars   prefix
set %~1dquotes="
set %~1dquotes2=""
set "%~1qmark=?"
set "%~1asterisk=*"
set "%~1colon=:"
set "%~1semicolon=;"
set "%~1caret=^"
set "%~1caret2=^^"
set "%~1ampersand=&"
set "%~1pipe=|"
set "%~1lab=<"
set "%~1rab=>"
set "%~1percent=%%"
set "%~1equal=="
if "!!" == "" (
    set "%~1bang=^!"
) else set "%~1bang=!"
set "%~1empty="
exit /b 0


:EOF
exit /b
