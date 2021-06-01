:entry_point > nul 2> nul
call %*
exit /b


:check_path [-e|-n] [-f|-d] <path_var>
setlocal EnableDelayedExpansion EnableExtensions
for %%v in (_require_attrib  _require_exist) do set "%%v="
call :argparse ^
    ^ "#1:store                     :_path_var" ^
    ^ "-e,--exist:store_const       :_require_exist=true" ^
    ^ "-n,--not-exist:store_const   :_require_exist=false" ^
    ^ "-f,--file:store_const        :_require_attrib=-" ^
    ^ "-d,--directory:store_const   :_require_attrib=d" ^
    ^ -- %* || exit /b 2
set "_path=!%_path_var%!"
if "!_path:~0,1!!_path:~-1,1!" == ^"^"^"^" set "_path=!_path:~1,-1!"
if not defined _path ( 1>&2 echo%0: Path not defined & exit /b 3 )
set "_temp=!_path!"
if "!_path:~1,1!" == ":" set "_temp=!_path:~0,1!!_path:~2!"
for /f tokens^=1-2*^ delims^=:?^"^<^>^| %%a in ("Q?_!_temp!_") do (
    if not "%%c" == "" ( 1>&2 echo%0: Invalid path characters & exit /b 3 )
)
for /f "tokens=1-2* delims=*" %%a in ("Q*_!_temp!_") do (
    if not "%%c" == "" ( 1>&2 echo%0: Wildcards are not allowed & exit /b 3 )
)
if "!_path:~1!" == ":" set "_path=!_path!\"
set "_file_exist=false"
for %%f in ("!_path!") do (
    set "_path=%%~ff"
    set "_attrib=%%~af"
)
if defined _attrib (
    set "_attrib=!_attrib:~0,1!"
    set "_file_exist=true"
)
if "!_attrib!" == "d" (
    for %%f in ("!_path!\.") do set "_path=%%~ff"
)
if defined _require_exist if not "!_file_exist!" == "!_require_exist!" (
    if "!_require_exist!" == "true" 1>&2 echo%0: Input does not exist
    if "!_require_exist!" == "false" 1>&2 echo%0: Input already exist
    exit /b 2
)
if "!_file_exist!" == "true" if defined _require_attrib if not "!_attrib!" == "!_require_attrib!" (
    if defined _require_exist (
        if "!_require_attrib!" == "d" 1>&2 echo%0: Input is not a folder
        if "!_require_attrib!" == "-" 1>&2 echo%0: Input is not a file
    ) else (
        if "!_require_attrib!" == "d" 1>&2 echo%0: Input must be a new or existing folder, not a file
        if "!_require_attrib!" == "-" 1>&2 echo%0: Input must be a new or existing file, not a folder
    )
    exit /b 2
)
for /f "tokens=* delims=" %%c in ("!_path!") do (
    endlocal
    set "%_path_var%=%%c"
)
exit /b 0


:lib.build_system [return_prefix]
set "%~1install_requires=argparse"
set "%~1extra_requires=Input.string"
set "%~1category=file"
exit /b 0


:doc.man
::  NAME
::      check_path - check if a path satisfies the given requirements
::
::  SYNOPSIS
::      check_path [-e|-n] [-f|-d] <path_var>
::
::  POSITIONAL ARGUMENTS
::      path_var
::          Variable that contains a path.
::
::  OPTIONS
::      -e, --exist
::          Target must exist.
::
::      -n, --not-exist
::          Target must not exist.
::
::      -f, --file
::          Target must be a file (if exist).
::
::      -d, --directory
::          Target must be a folder (if exist).
::
::  EXIT STATUS
::      0:  - The path satisfy the requirements.
::      2:  - The path does not satisfy the requirements.
::      3:  - The path is invalid.
::
::  ENVIRONMENT
::      cd
::          Affects the base path of the path in path_var if relative path is given.
::
::  NOTES
::      - Variables in path will not be expanded (e.g.: %appdata%).
::      - Path in variable is converted to absolte path on success.
exit /b 0


:doc.demo
call :Input.string config_file  --message "Input an existing file: "
call :check_path --exist --file config_file && (
    echo Your input is valid
) || echo Your input is invalid

call :Input.string folder  --message "Input an existing folder or a new folder name: "
call :check_path --directory folder && (
    echo Your input is valid
) || echo Your input is invalid

call :Input.string new_name  --message "Input a non-existing file name: "
call :check_path --not-exist new_name && (
    echo Your input is valid
) || echo Your input is invalid
exit /b 0


:tests.setup
if exist "hello" (
    rd /s /q "hello" || del /f /q "hello"
) 2> nul || ( call :unittest.error "cannot setup dummy directory" & exit /b 1 )
md "hello"
if exist "world" (
    del /f /q "world" || rd /s /q "world"
) 2> nul || ( call :unittest.error "cannot setup dummy file" & exit /b 1 )
call 2> "world"
if exist "none" (
    del /f /q "none" || rd /s /q "none"
) 2> nul || ( call :unittest.error "cannot setup non-existing file" & exit /b 1 )
exit /b 0


:tests.teardown
exit /b 0


:tests.test_invalid_characters
set "char.wc=C:\hello*world"
set "char.colon=C:\hello:world"
set "char.pipe=C:\hello|world"
set "char.qm=C:\hello?world"
set "char.lab=C:\hello<world"
set "char.rab=C:\hello>world"
set char.dquote=C:\hello"world
for %%a in (wc colon pipe qm lab rab dquote) do (
    call :check_path char.%%a 2> nul && (
        call %unittest% fail "unexpected success with invalid character: %%a"
    )
)
exit /b 0


:tests.test_exist
call :tests.check_errorlevel ^
    ^ "0: -e  :%~d0\" ^
    ^ "0: -e  :%~d0" ^
    ^ "0: -e  :hello\" ^
    ^ "0: -e  :hello" ^
    ^ "2: -e  :world\" ^
    ^ "0: -e  :world" ^
    ^ "2: -e  :none"
exit /b 0


:tests.test_not_exist
call :tests.check_errorlevel ^
    ^ "2: -n  :%~d0\" ^
    ^ "2: -n  :hello" ^
    ^ "2: -n  :world" ^
    ^ "0: -n  :none"
exit /b 0


:tests.test_file
call :tests.check_errorlevel ^
    ^ "2: -f  :%~d0" ^
    ^ "2: -f  :hello" ^
    ^ "0: -f  :world" ^
    ^ "0: -f  :none"
exit /b 0


:tests.test_directory
call :tests.check_errorlevel ^
    ^ "0: -d  :%~d0" ^
    ^ "0: -d  :hello" ^
    ^ "2: -d  :world" ^
    ^ "0: -d  :none"
exit /b 0


:tests.test_mixed
call :tests.check_errorlevel ^
    ^ "2: -e -f   :none" ^
    ^ "2: -e -d   :none"
exit /b 0


:tests.test_updir
call :tests.check_errorlevel ^
    ^ "0: -e  : none\..\hello" ^
    ^ "0: -e  : none\..\world"
exit /b 0


:tests.check_errorlevel <errorlevel:option:path>
for %%a in (%*) do ( rem
) & for /f "tokens=1-2* delims=:" %%b in (%%a) do (
    set "input_path=%%d"
    call :check_path input_path %%c 2> nul
    set "result=!errorlevel!"
    set "expected=%%b"
    if not "!result!" == "!expected!" (
        call %unittest% fail "given '%%c', expected errorlevel '!expected!', got '!result!'"
    )
)
exit /b 0


:tests.test_full_path
for %%a in (
    "%~d0|%~d0\"
    "%~d0\|%~d0\"
    "hello|!cd!\hello"
    "hello\|!cd!\hello"
    "world|!cd!\world"
    "none|!cd!\none"
    "none\.|!cd!\none"
    "none\.\none|!cd!\none\none"
    "none\..|!cd!"
    "none\..\empty|!cd!\empty"
) do for /f "tokens=1* delims=|" %%b in (%%a) do (
    set "result=%%b"
    call :check_path result %%c 2> nul
    set "expected=%%c"
    if not "!result!" == "!expected!" (
        call %unittest% fail "expected '!expected!', got '!result!'"
    )
)
exit /b 0

rem ======================== notes ========================

rem Path invalid characters:
rem <>|?*":\/

rem if : is the 2nd character, it will add backslash after it if 3rd is not
rem if path starts with 'C:' and not followed by '\' it will replace 'C:' with the script's initial cwd
rem :"<>| are treated as normal characters
rem * and ? is treated as wildcard

rem (!) Drive letter checking can be improved maybe?


:EOF  # End of File
exit /b
