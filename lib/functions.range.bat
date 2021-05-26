:entry_point > nul 2> nul
call %*
exit /b


:functions.range <return_var> <input_file> <label [...]>
setlocal EnableDelayedExpansion
set "_return_var=%~1"
set "_input_file=%~f2"
set "_labels=%~3"
set "_=!_labels!" & set "_labels= "
for %%l in (!_!) do set "_labels=!_labels!%%l "
for %%v in (_missing _ranges) do set "%%v=!_labels!"
for %%v in (_included _current _start _end) do set "%%v="
cd /d "!tmp_dir!" 2> nul || cd /d "!tmp!"
for /f "delims= " %%t in ('robocopy /l . . /njh /njs') do set "TAB=%%t"
for /f %%a in ('copy /z "%ComSpec%" nul') do set "CR=%%a"
set LF=^
%=REQUIRED=%
%=REQUIRED=%
set _search=^
	^ /c:"^^[!TAB! @]*exit  */b.*!CR!*!LF!!CR!*!LF!" ^
	^ /c:"^^[!TAB! @]*goto  *.*!CR!*!LF!!CR!*!LF!" ^
    ^ /c:"^^[!TAB! @]*:[^^: ]"
findstr /n /r !_search! "!_input_file!" > "_tokens" 2> nul || (
    1>&2 echo%0: cannot open file '!_input_file!' & exit /b 3
)
for /f "usebackq tokens=*" %%o in ("_tokens") do ( rem
) & for /f "tokens=1 delims=:" %%n in ("%%o") do (
    set "_line=%%o"
    set "_line=!_line:*:=!"
    for /f "tokens=* delims=@%TAB% " %%a in ("!_line!") do set "_line=%%a"
    if "!_line:~0,1!" == ":" (
        for /f "tokens=1 delims=:%TAB% " %%a in ("!_line!") do set "_line=%%a"
        for %%l in ("!_line!") do (
            if not "!_missing!" == "!_missing: %%~l = !" (
                if defined _current (
                    set "_ranges=!_ranges: %%~l = !"
                    set "_included=!_included! %%~l"
                ) else (
                    set "_current=%%~l"
                    set "_start=%%n"
                )
                set "_missing=!_missing: %%~l = !"
            )
        )
    ) else if defined _current for %%l in ("!_current!") do (
        set "_end=%%n"
        for %%r in (!_start!:!_end!) do set "_ranges=!_ranges: %%~l = %%r !"
        for %%v in (_current _start _end) do set "%%v="
    )
)
for %%l in (!_current!) do (
    for %%r in (!_start!:) do set "_ranges=!_ranges: %%l = %%r !"
)
if "!_missing:~1,1!" == "" (
    set "_missing="
) else (
    1>&2 echo%0: label not found: !_missing!
    set "_missing=true"
)
for /f "tokens=1* delims=:" %%q in ("Q:!_ranges!") do (
    endlocal
    set "%_return_var%=%%r"
    if "%_missing%" == "true" exit /b 3
)
exit /b 0


:lib.build_system [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=capchar Input.path Input.string"
set "%~1category=packaging"
exit /b 0


:doc.man
::  NAME
::      functions.range - get the line range of functions
::
::  SYNOPSIS
::      functions.range <return_var> <input_file> <label [...]>
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the results, each seperated by space.
::
::      input_file
::          Path of the input (batch) file.
::
::      labels
::          The function names to find, each seperated by space.
::
::  ENVIRONMENT
::      cd
::          Affects the base path of input_file if relative path is given.
::
::  EXIT STATUS
::      0:  - Label is found.
::      3:  - Label is not found.
::
::  NOTES
::      - The order of the function will be based on the order of occurrence
::        in the parameter.
::      - End of function is marked by an '[@]exit /b [errorlevel]',
::        followed by an empty line.
exit /b 0


:doc.demo
call :Input.path input_file --file --exist
call :Input.string label_name || set "label_name=EOF"
echo=
echo Input file : !input_file!
echo Label name : !label_name!
echo=
call :functions.range range "!input_file!" "!label_name!"
echo Range  : !range!
exit /b 0


:tests.setup
set "return.success=0"
set "return.fail=3"
call :capchar TAB
> "basic" (
    echo=
    echo :hello
    echo echo a
    echo exit /b
    echo=
    echo :hi
    echo echo b
    echo goto :EOF
    echo=
    echo :howdy
    echo echo c
    echo exit /b 0
    echo=
)
> "joined" (
    echo=
    echo :hello
    echo exit /b
    echo #+++
    echo=
    echo :hi
    echo echo b
    echo goto :EOF
    echo #+++
    echo=
    echo :howdy
    echo echo c
    echo exit /b 0
    echo=
)
> "labels" (
    echo=
    echo    :space
    echo !TAB!:tab
    echo @:at
    echo !TAB!@ :mix
    echo exit /b 0
    echo=
)
exit /b 0


:tests.teardown
exit /b 0


:tests.test_detect_start
for %%a in (
    "2: hello"
    "6: hi"
    "10: howdy"
) do for /f "tokens=1* delims=: " %%b in (%%a) do (
    set "given=%%c"
    set "expected=%%b"
    call :functions.range range "basic" !given!
    for /f "tokens=1-2 delims=: " %%s in ("!range!:None") do set "result=%%s"
    if not "!result!" == "!expected!" (
        call %unittest% fail "given '!given!' expected '!expected!', got '!result!'"
    )
)
exit /b 0


:tests.test_detect_stop
for %%a in (
    "4: hello"
    "8: hi"
    "12: howdy"
) do for /f "tokens=1* delims=: " %%b in (%%a) do (
    set "given=%%c"
    set "expected=%%b"
    call :functions.range range "basic" !given!
    for /f "tokens=1-2 delims=: " %%s in ("!range!:None") do set "result=%%t"
    if not "!result!" == "!expected!" (
        call %unittest% fail "given '!given!' expected '!expected!', got '!result!'"
    )
)
exit /b 0


:tests.test_detect_labels
for %%a in (
    "2: space"
    "3: tab"
    "4: at"
    "5: mix"
) do for /f "tokens=1* delims=: " %%b in (%%a) do (
    set "given=%%c"
    set "expected=%%b"
    call :functions.range range "labels" !given!
    for /f "tokens=1-2 delims=: " %%s in ("!range!:None") do set "result=%%s"
    if not "!result!" == "!expected!" (
        call %unittest% fail "given '!given!' expected '!expected!', got '!result!'"
    )
)
exit /b 0


:tests.test_undetect_joined
for %%a in (
    "13: hello"
    "13: hi"
    "13: howdy"
) do for /f "tokens=1* delims=: " %%b in (%%a) do (
    set "given=%%c"
    set "expected=%%b"
    call :functions.range range "joined" !given!
    for /f "tokens=1-2 delims=: " %%s in ("!range!:None") do set "result=%%t"
    if not "!result!" == "!expected!" (
        call %unittest% fail "given '!given!' expected '!expected!', got '!result!'"
    )
)
exit /b 0


:tests.test_errorlevel
for %%a in (
    "success: hello"
    "fail: nooo"
) do for /f "tokens=1* delims=: " %%b in (%%a) do (
    set "given=%%c"
    set "expected=!return.%%b!"
    call :functions.range range "basic" !given! 2> nul
    set "result=!errorlevel!"
    if not "!result!" == "!expected!" (
        call %unittest% fail "given '!given!' expected '!expected!', got '!result!'"
    )
)
exit /b 0


:EOF  # End of File
exit /b
