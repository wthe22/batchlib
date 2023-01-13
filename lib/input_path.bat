:entry_point
call %*
exit /b


:input_path [-m message] [-b base_dir] [-e|-n] [-f|-d] [-o] <return_var>
setlocal EnableDelayedExpansion EnableExtensions
for %%v in (
    _return_var _message _base_dir _optional _warn_overwrite
    _check_options
) do set "%%v="
call :argparse2 --name %0 ^
    ^ "return_var:              set _return_var" ^
    ^ "[-m,--message MESSAGE]:  set _message" ^
    ^ "[-o,--optional]:         set _optional=true" ^
    ^ "[-b,--base-dir DIR]:     set _base_dir" ^
    ^ "[-w,--warn-overwrite]:   set _warn_overwrite=true" ^
    ^ "[-e,--exist]:            list _check_options= -e" ^
    ^ "[-n,--not-exist]:        list _check_options= -n" ^
    ^ "[-f,--file]:             list _check_options= -f" ^
    ^ "[-d,--directory]:        list _check_options= -d" ^
    ^ -- %* || exit /b 2
if defined _base_dir cd /d "!_base_dir!"
if not defined _message (
    if defined _optional (
        set "_message=Input !_return_var! (optional): "
    ) else set "_message=Input !_return_var!: "
)
call :input_path._loop || exit /b 4
set "user_input=^!!user_input!"
set "user_input=!user_input:^=^^^^!"
set "user_input=%user_input:!=^^^!%"
for /f "delims= eol=" %%a in ("!user_input!") do (
    endlocal
    set "%_return_var%=%%a"
    set "%_return_var%=!%_return_var%:~1!"
    if not defined %_return_var% exit /b 3
)
exit /b 0
#+++

:input_path._loop
for /l %%# in (1,1,10) do for /l %%# in (1,1,10) do (
    set "user_input="
    set /p "user_input=!_message!"
    if defined user_input (
        call :check_path user_input !_check_options! && (
            if not defined _warn_overwrite exit /b 0
            if not exist "!user_input!" exit /b 0
            call :input_yesno _ --default N ^
                ^ --message "File already exist. Overwrite file? [y/N] " ^
                ^ && exit /b 0
        )
    ) else if defined _optional exit /b 0
)
echo%0: Too many invalid inputs
exit /b 1


:lib.dependencies [return_prefix]
set "%~1install_requires=argparse2 check_path input_yesno"
set "%~1extra_requires="
set "%~1category=ui"
exit /b 0


:doc.man
::  NAME
::      input_path - read a path string from standard input
::
::  SYNOPSIS
::      input_path [-m message] [-b dir] [-e|-n] [-f|-d]
::                 [-o] [-w] <return_var>
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the absolte path of the file/folder.
::
::  OPTIONS
::      -m MESSAGE, --message MESSAGE
::          Use MESSAGE as the prompt message.
::          By default, the message is generated automatically.
::
::      -b DIR, --base-dir DIR
::          Function will CD to this directory first before reading input.
::
::      -o, --optional
::          Input is optional and could be skipped by entering nothing.
::
::      -w, --warn-overwrite
::          Warn that file will be overwritten if an existing file is entered.
::
::  CHECK OPTIONS
::      These options that are passed to check_path()
::
::      -e, --exist
::          Target must exist. Mutually exclusive with '--not-exist'.
::
::      -n, --not-exist
::          Target must not exist. Mutually exclusive with '--exist'.
::
::      -f, --file
::          Target must be a file (if exist). Mutually exclusive with '--directory'.
::
::      -d, --directory
::          Target must be a folder (if exist). Mutually exclusive with '--file'.
::
::  EXIT STATUS
::      0:  - Input is successful.
::      2:  - Invalid argument.
::      3:  - User skips the input.
::      4:  - Too many invalid inputs (100 attempts).
exit /b 0


rem Note:
rem - Beware of names that solely consist of whitespaces. For now, it is tested
rem   to be safe because explorer and cmd does not allow users to give file name
rem   that solely consist of whitespaces and quotes are always added when using
rem   TAB autocompletion if the file name contains whitespace


:doc.demo
echo Current directory: !cd!

echo=
call :input_path save_folder --directory ^
    ^ --message "Input an existing folder or a new folder name: "
echo Result: "!save_folder!"

echo=
call :input_path existing_file_or_folder --optional --exist
echo Result: "!existing_file_or_folder!"

echo=
echo Base directory is now "!tmp!"
call :input_path target_file --base-dir "!tmp!" --not-exist ^
    ^ --message "Input an non-existing file: "
echo Result: "!target_file!"

exit /b 0


:tests.setup
set "setup_fail="
if exist "tree" rmdir /s /q "tree"
mkdir "tree" || (
    call %unittest% error "cannot create folder"
    set "setup_fail=true"
)
for %%a in (
    "ref"
) do (
    set "word=%%~a"
    mkdir "tree\!word:~0,1!\!word:~1,1!"
    call 2> "tree\!word:~0,1!\!word:~1,1!\!word:~2,1!"
)
for %%a in (
    "red"
) do (
    set "word=%%~a"
    mkdir "tree\!word:~0,1!\!word:~1,1!\!word:~2,1!"
)
exit /b 0


:tests.teardown
exit /b 0


:tests.test_input
if defined setup_fail (
    call %unittest% error "test folder cannot be created"
    exit /b 0
)
for %%a in (
    "red:tree\red"
    "ref:tree\ref"
    "rex:tree\rex"
    "ref:tree\red ref: --file"
    "red:tree\ref red: --directory"
    "red:tree\rex red: --exist"
    "rex:tree\red rex: --not-exist"
    "red:.\ed: --base-dir tree\r"
    "ref:.\ef: --base-dir tree\r"
    "rex:.\ex: --base-dir tree\r"
) do for /f "tokens=1-2* delims=:" %%b in (%%a) do ( rem
) & for /f "tokens=1* delims=\" %%e in ("%%c") do (
    > "input" (
        for %%i in (%%f) do (
            call :tests.make_path relpath "%%e" "%%i"
            echo=!relpath!
        )
    )
    call :tests.make_path expected "!cd!\tree" "%%b"
    set "result="
    call :input_path result %%d < "input" > nul 2> nul
    if not "!result!" == "!expected!" (
        call %unittest% fail "given '%%c' and '%%d', expected errorlevel '!expected!', got '!result!'"
    )
)
exit /b 0


:tests.test_errorlevel
if defined setup_fail (
    call %unittest% error "test folder cannot be created"
    exit /b 0
)
for %%a in (
    "0:tree\rex"
    "0:tree\ref: --file"
    "0:tree\red: --directory"
    "0:tree\red: --exist"
    "0:tree\rex: --not-exist"
    "3:.: --file --optional"
    "4:.: --file"
) do for /f "tokens=1-2* delims=:" %%b in (%%a) do ( rem
) & for /f "tokens=1* delims=\" %%e in ("%%c") do (
    > "input" (
        for %%i in (%%f) do (
            call :tests.make_path relpath "%%e" "%%i"
            echo=!relpath!
        )
    )
    call :input_path result %%d < "input" > nul 2> nul
    set "result=!errorlevel!"
    set "expected=%%b"
    if not "!result!" == "!expected!" (
        call %unittest% fail "given '%%c' and '%%d', expected errorlevel '!expected!', got '!result!'"
    )
)
exit /b 0


:tests.make_path   return_var  prefix  word
set "letters=%~3"
set "letters=!letters:~0,1! !letters:~1,1! !letters:~2,1!"
set "%~1=%~2"
for %%l in (!letters!) do set "%~1=!%~1!\%%l"
exit /b 0


:EOF
exit /b
