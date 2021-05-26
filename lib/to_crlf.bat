:entry_point > nul 2> nul
call %*
exit /b


:to_crlf
:to_crlf.alt1
:to_crlf.alt2
for %%n in (1 2) do call :is_crlf.alt%%n --check-exist 2> nul && (
    call :is_crlf.alt%%n && exit /b 2
    echo Converting EOL...
    type "%~f0" | more /t4 > "%~f0.tmp" && (
        move "%~f0.tmp" "%~f0" > nul && exit /b 0
    )
    ( 1>&2 echo warning: Convert EOL failed )
    exit /b 3
)
( 1>&2 echo error: failed to call is_crlf^(^) )
exit /b 3


:lib.build_system [return_prefix]
set "%~1install_requires=is_crlf"
set "%~1category=packaging"
exit /b 0


:doc.man
::  NAME
::      to_crlf - convert EOL of the script to CRLF
::
::  SYNOPSIS
::      to_crlf
::      to_crlf.alt1
::      to_crlf.alt2
::
::  EXIT STATUS
::      0:  - EOL conversion is successful.
::      2:  - EOL conversion is not necessary.
::      3:  - EOL conversion failed.
::
::  BEHAVIOR
::      - Script SHOULD exit (not 'exit /b') if EOL conversion is successful
::        to prevent unexpected errors, unless you know what you are doing.
::
::  NOTES
::      - Function MUST be embedded into the script to work correctly.
::      - Tabs are converted to 4 spaces
::      - Can be used to detect and fix script EOL if it was downloaded
::        from GitHub, since uses Unix EOL (LF).
exit /b 0


:doc.demo
echo Fixing EOL...
for %%n in (1 2) do call :to_crlf.alt%%n & (
    set "result=!errorlevel!"
    echo=
    echo Called [to_crlf.alt%%n]
    if "!result!" == "0" (
        echo Fix successful
        echo Script will exit.
        pause
        exit 0
    )
    if "!result!" == "2" echo Fix not necessary
    if "!result!" == "3" echo Fix failed
)
exit /b 0


:EOF  # End of File
exit /b
