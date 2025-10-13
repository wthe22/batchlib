:entry_point
call %*
exit /b


:metadata [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=functions_range readline"
set "%~1category=string"
exit /b 0


:capchar <char> ...
setlocal EnableDelayedExpansion
for %%v in (
    BEL BS ESC TAB CR LF
    BASE BACK DQ NL
) do set "%%v="
for %%a in (%*) do set "%%a=true"
for %%a in (
    "BASE: BS"
    "BACK: BS"
    "DQ: BS"
    "NL: LF"
) do for /f "tokens=1* delims=:" %%b in (%%a) do (
    if defined %%b for %%v in (%%c) do set "%%v=true"
)
endlocal & (
if /i "%BEL%" == "true" for /f "usebackq delims=" %%a in (
    `forfiles /p "%~dp0." /m "%~nx0" /c "cmd /c echo 0x07"`
) do set "BEL=%%a"
if /i "%CR%" == "true" for /f %%a in ('copy /z "%ComSpec%" nul') do set "CR=%%a"
if /i "%LF%" == "true" set LF=^
%=REQUIRED=%
%=REQUIRED=%
if /i not "%BS%" == "" for /f %%a in ('"prompt $H & for %%b in (1) do rem"') do set "BS=%%a"
if /i not "%TAB%" == "" for /f "delims= " %%t in ('robocopy /l . . /njh /njs') do set "TAB=%%t"
if /i not "%ESC%" == "" for /f %%a in ('"prompt $E & for %%b in (1) do rem"') do set "ESC=%%a"
if /i not "%BASE%" == "" set "BASE=_!BS! !BS!"
if /i not "%BACK%" == "" set "BACK=!BS! !BS!"
if /i not "%DQ%" == "" set DQ="!BS! !BS!
if /i not "%NL%" == "" set "NL=^^!LF!!LF!^^"
)
exit /b 0


rem ======================== notes ========================

rem New Line (DisableDelayedExpansion)
set ^"NL=^^^%LF%%LF%^%LF%%LF%^"

rem Other characters
set DQ="
set "EM=^!"
set EM=^^!

rem ================================================


:doc.man
::  NAME
::      capchar - capture control characters
::
::  SYNOPSIS
::      capchar   <char> ...
::
::  POSITIONAL ARGUMENTS
::      char
::          The character to capture. See LIST OF CHARACTERS
::          and LIST OF MACROS for list of valid options.
::
::  LIST OF CHARACTERS
::      Var     Hex     Name
::      ------------------------------
::      BEL     07      Bell/Beep sound
::      BS      08      Backspace
::      TAB     09      Tab
::      LF      0A      Line Feed
::      CR      0D      Carriage Return
::      ESC     1B      Escape
::
::  LIST OF MACROS
::      Var     Description
::      ------------------------------
::      BASE    'Base' for SET /P so it can start with whitespace characters
::      BACK    Delete previous character (in console)
::      DQ      'Invisible' double quote to print special characters
::              without using caret (^). Must be used as %DQ%, not !DQ!.
::      NL      Set new line in variables
exit /b 0


:doc.demo
echo Capture control characters
echo=
call :capchar ^
    ^ BEL BS ESC TAB CR LF ^
    ^ BASE BACK DQ NL ^
    ^ %=END=%
echo ======================== CODE ========================
call :functions_range _range "%~f0" "doc.demo.proof"
call :readline "%~f0" !_range! 1:-1
echo ======================== RESULT ========================
call :doc.demo.proof
exit /b 0

:doc.demo.proof
echo Hello!LF!World!CR!.
echo Clean!BS!r
echo %DQ%|No&Escape|^<Characters>^
echo !ESC![104;97m Windows 10 !ESC![0m
< nul set /p "=!BASE! A Whitespace at front"
echo=
echo T!TAB!A!TAB!B
echo BEL[!BEL!]
exit /b 0


:tests.setup
:tests.teardown
exit /b 0


:tests.test_capture
for %%a in (
    "BEL: 07"
    "BS: 08"
    "TAB: 09"
    "LF: 0A"
    "CR: 0D"
    "ESC: 1B"
    "BASE: 5F 08 20 08"
    "BACK: 08 20 08"
    "DQ: 22 08 20 08"
    "NL: 5E 0A 0A 5E"
) do for /f "tokens=1* delims=: " %%b in (%%a) do (
    set "%%b="
    call :capchar %%b
    echo [!%%b!] > "char"
    certutil -encodehex "char" "raw_hex" > nul
    set "size=2"
    for %%h in (%%c) do set /a "size+=1"
    set /a "size=!size! * 3 - 1
    set "hex="
    for /f "usebackq tokens=1*" %%d in ("raw_hex") do ( rem
    ) & for %%s in (!size!) do (
        set "hex=%%e"
        set "hex=!hex:~0,%%s!"
    )
    del /f /q "raw_hex"
    set "expected=5b %%c 5d"
    set "result=!hex!"
    if /i not "!result!" == "!expected!" (
        call %unittest% fail "Expected '!expected!', got '!result!'"
    )
)
exit /b 0


:tests.test_multi_args
set "CR="
set "LF="
call :capchar CR LF
if not defined LF (
    call %unittest% fail
)
exit /b 0


:EOF
exit /b
