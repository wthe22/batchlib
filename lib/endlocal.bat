:entry_point
call %*
exit /b


:endlocal <depth> <old[:new]> ...
setlocal EnableDelayedExpansion
set LF=^
%=REQUIRED=%
%=REQUIRED=%
set "_depth="
set "_content=endlocal!LF!"
for %%v in (%*) do for /f "tokens=1-2 delims=:" %%a in ("%%~v:%%~v") do (
    if not defined _depth (
        set "_depth=%%~v"
    ) else (
        set "_value=#!%%a!"
        set "_value=!_value:\=\\!"
        set "_value=!_value:+=++!"
        set _value=!_value:"=\+22!
        set "_value=!_value:^=\+5E!"
        call set "_value=%%_value:^!=\+21%%"
        set "_content=!_content!%%b=!_value!!LF!"
    )
)
for /f "tokens=* delims= eol=" %%a in ("!_content!") do ^
for /f "tokens=1 delims==" %%r in ("%%a") do ^
if "%%a" == "endlocal" (
    goto 2> nul
    for /l %%i in (1,1,%_depth%) do endlocal
) else (
    set "%%a"
    if "!!" == "" (
        setlocal EnableDelayedExpansion
        set "_de=Enable"
    ) else (
        setlocal EnableDelayedExpansion
        set "_de=Disable"
    )
    for %%e in (!_de!) do (
        if "%%e" == "Enable" (
            endlocal
        )
        set "%%r=!%%r!"
        call set "%%r=%%%%r:\+21=^!%%"
        set "%%r=!%%r:\+5E=^!"
        set %%r=!%%r:\+22="!
        set "%%r=!%%r:\\=\!"
        set "%%r=!%%r:++=+!"
        set "%%r=!%%r:~1!"
        if "%%e" == "Disable" (
            for /f "tokens=* delims= eol=" %%v in ("!%%r!") do (
                endlocal
                set "%%r=%%v"
            )
        )
    )
)
exit /b 0


:lib.dependencies [return_prefix]
set "%~1install_requires= "
set "%~1category=algorithms"
exit /b 0


:doc.man
::  NAME
::      endlocal - make variables survive ENDLOCAL
::
::  SYNOPSIS
::      endlocal <depth> <old[:new]> ...
::
::  POSITIONAL ARGUMENTS
::      depth
::          Number of times to endlocal.
::
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
call :endlocal 1 var_del var_hello:var_new_name
echo=
set "var_"
exit /b 0


:tests.setup
:tests.teardown
exit /b 0


:tests.test_basic
if ^"%1^" == "" (
    for %%o in (Enable Disable) do (
        for %%i in (Enable Disable) do (
            call :tests.test_basic %%o %%i
        )
    )
    exit /b 0
)
setlocal EnableDelayedExpansion
set "outer_de=%~1"
set "inner_de=%~2"
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

setlocal %outer_de%DelayedExpansion
setlocal %inner_de%DelayedExpansion
for %%v in (%local.changed%) do set "var.%%v=changed"
for %%v in (%local.deleted%) do set "var.%%v="
call :endlocal 1 %local.persist_vars%

setlocal EnableDelayedExpansion
for %%v in (!expected.null!) do (
    if defined var.%%v (
        call %unittest% fail "Expected null '%%v' on %~1DE"
    )
)
for %%v in (!expected.old!) do (
    if not "!var.%%v!" == "old" (
        call %unittest% fail "Expected old '%%v' on %~1DE"
    )
)
for %%v in (!expected.changed!) do (
    if not "!var.%%v!" == "changed" (
        call %unittest% fail "Expected changed '%%v' on outer:!outer_de!, inner:!inner_de!"
    )
)
exit /b 0


:tests.test_special_chars
set expected=; ^& type ? ^> nul ^< nul ^| dir ? "; & type ? > nul < nul | dir *"
for %%a in (Enable Disable) do (
    for %%b in (Enable Disable) do (
        setlocal %%aDelayedExpansion
        setlocal %%bDelayedExpansion
        setlocal EnableDelayedExpansion
        endlocal
        call :endlocal 1 expected:result
        setlocal EnableDelayedExpansion
        endlocal
        setlocal EnableDelayedExpansion
        if not "!result!" == "!expected!" (
            call %unittest% fail "%%aDE to %%bDE"
        )
    )
)
exit /b 0


:tests.test_expanded_chars
set expected==^^^^ ^^^^^^^^ %%0 %%%%^^a ^^!e^^! "^^ ^^^^ %%0 %%%%^a ^!e^!"
for %%a in (Enable Disable) do (
    for %%b in (Enable Disable) do (
        setlocal %%aDelayedExpansion
        setlocal %%bDelayedExpansion
        setlocal EnableDelayedExpansion
        endlocal
        call :endlocal 1 expected:result
        setlocal EnableDelayedExpansion
        endlocal
        setlocal EnableDelayedExpansion
        if not "!result!" == "!expected!" (
            call %unittest% fail "%%aDE to %%bDE"
        )
    )
)
exit /b 0


:tests.test_internal_chars
set expected=\\++\+\\++\+ \\+22\++22\+22 \"++"\
for %%a in (Enable) do (
    for %%b in (Enable) do (
        setlocal %%aDelayedExpansion
        setlocal %%bDelayedExpansion
        setlocal EnableDelayedExpansion
        endlocal
        call :endlocal 1 expected:result
        setlocal EnableDelayedExpansion
        endlocal
        setlocal EnableDelayedExpansion
        if not "!result!" == "!expected!" (
            call %unittest% fail "%%aDE to %%bDE"
        )
    )
)
exit /b 0


:EOF
exit /b
