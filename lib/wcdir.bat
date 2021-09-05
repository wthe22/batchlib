:entry_point
call %*
exit /b


:wcdir <return_var> <wildcard_path> [-f|-d]
set "%~1="
setlocal EnableDelayedExpansion
set "_list_dir=true"
set "_list_file=true"
if "%~3" == "-d" set "_list_file="
if "%~3" == "-f" set "_list_dir="
set "_args=%~2"
set "_args=!_args:/=\!"
set "_result="
set LF=^
%=REQUIRED=%
%=REQUIRED=%
call :wcdir._find "!_args!"
for /f "tokens=* delims=" %%r in ("!_result!") do (
    if not defined %~1 endlocal
    set %~1=!%~1!%%r^
%=REQUIRED=%
%=REQUIRED=%
)
exit /b 0
#+++

:wcdir._find   wildcard_path
for /f "tokens=1* delims=\" %%a in ("%~1") do if "%%a" == "*:" (
    for %%l in (
        A B C D E F G H I J K L M
        N O P Q R S T U V W X Y Z
    ) do pushd "%%l:\" 2> nul && call :wcdir._find "%%b"
) else if "%%b" == "" (
    if defined _list_dir dir /b /a:d "%%a" > nul 2> nul && (
        for /d %%f in ("%%a") do set "_result=!_result!%%~ff!LF!"
    )
    if defined _list_file dir /b /a:-d "%%a" > nul 2> nul && (
        for %%f in ("%%a") do set "_result=!_result!%%~ff!LF!"
    )
) else for /d %%f in ("%%a") do pushd "%%f\" 2> nul && call :wcdir._find "%%b"
popd
exit /b


:lib.dependencies [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=Input.string strip_dquotes capchar"
set "%~1category=file"
exit /b 0


:doc.man
::  NAME
::      wcdir - find files/folders that matches the wildcard path
::
::  SYNOPSIS
::      wcdir <return_var> <wildcard_path> [-f|-d]
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the result. Each path is seperated
::          by a Line Feed character (hex code '0A').
::
::      wildcard_path
::          The wildcard path to find. May contain multiple wildcards.
::
::  OPTIONS
::      -f, --file
::          Search for files only.
::
::      -d, --directory
::          Search for directories only.
::
::  ENVIRONMENT
::      cd
::          Affects the base path of wildcard_path if relative path is given.
::
::  NOTES
::      - Variables in path will not be expanded (e.g.: %appdata%).
::      - Does not list hidden files and folders.
exit /b 0


:doc.demo
call :Input.string wildcard_path || set "wildcard_path=C:\Windows\Sys*\*script.exe"
call :strip_dquotes wildcard_path
call :wcdir result "!wildcard_path!"
echo=
echo Wildcard path:
echo !wildcard_path!
echo=
echo Found List:
echo=!result!
exit /b 0


:tests.setup
:tests.teardown
exit /b 0


:tests.test_all
if exist "tree" rmdir /s /q "tree"
for %%a in (
    "lap"
    "let"
    "pet"
) do (
    set "word=%%~a"
    mkdir "tree\!word:~0,1!\!word:~1,1!"
    call 2> "tree\!word:~0,1!\!word:~1,1!\!word:~2,1!"
)
for %%a in (
    "ape"
    "ate"
    "pea"
) do (
    set "word=%%~a"
    mkdir "tree\!word:~0,1!\!word:~1,1!\!word:~2,1!"
)
call :capchar LF

set test_cases= ^
    ^ "pe*: pea pet" !LF!^
    ^ "a*e: ape ate" !LF!^
    ^ "*et: let pet" !LF!^
    ^ "l**: lap let" !LF!^
    ^ "*e*: let pea pet" !LF!^
    ^ "**t: let pet" !LF!^
    ^ "***: ape ate lap let pea pet" ^
    ^ %=END=%
set "LF="
for /f "tokens=* delims=" %%a in ("!test_cases!") do ( rem
) & for /f "tokens=1* delims=:" %%b in (%%a) do (
    set "pattern=%%b"
    set "pattern=!pattern:~0,1!\!pattern:~1,1!\!pattern:~2,1!"
    call :wcdir result_path "tree\!pattern!"
    set "result="
    for %%f in (!result_path!) do (
        set "word=%%~ff"
        set "word=!word:*%cd%\tree\=!"
        set "word=!word:\=!"
        set "result=!result! !word!"
    )
    if not "!result!" == "%%c" (
        call %unittest% fail "Given pattern '%%b', expected '%%c', got '!result!'"
    )
)
exit /b 0


:EOF
exit /b
