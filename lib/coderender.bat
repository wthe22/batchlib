:entry_point > nul 2> nul
call %*
exit /b


:coderender  <file> <label>
setlocal EnableDelayedExpansion EnableExtensions
set "_source_file=%~f1"
set "_label=%~2"
cd /d "!tmp_dir!" 2> nul || cd /d "!tmp!"
call :functions.range _range "!_source_file!" "!_label!"
call :readline "!_source_file!" !_range! 1:-1 > ".coderender._template" || exit /b 2
for %%f in (code literal) do call 2> ".coderender._%%f" (
findstr /n "^" ".coderender._template" > ".coderender._numbered"
call :coderender._group_lines
> ".coderender._render.bat" (
    echo call :coderender._render
    echo exit /b
    echo=
    echo=
    type "%~f0"
    echo=
    echo=
    echo :coderender._render
    type ".coderender._code"
    echo exit /b
    echo=
    echo=
    type ".coderender._literal"
)
call ".coderender._render.bat" || exit /b 3
exit /b 0
#+++

:coderender._group_lines
setlocal DisableDelayedExpansion
set "_prev_group="
for /f "usebackq tokens=* delims=" %%o in (".coderender._numbered") do (
    set "_line=%%o"
    setlocal EnableDelayedExpansion
    for /f "tokens=1 delims=:" %%n in ("!_line!") do set "_line_no=%%n"
    set "_line=!_line:*:=!"

    set "_group=code"
    if "!_line:~0,4!" == "::  " set "_group=literal"
    if "!_line:~0,3!" == "::" set "_group=literal"

    if not "!_group!" == "!_prev_group!" (
        if "!_group!" == "literal" (
            >> ".coderender._code" (
                echo call :coderender._type line_!_line_no!
            )
            >> ".coderender._literal" (
                echo :coderender._captured.line_!_line_no!
            )
        )
        if "!_prev_group!" == "literal" (
            >> ".coderender._literal" (
                echo exit /b 0
                echo=
            )
        )
    )
    >> ".coderender._!_group!" (
        echo(!_line!
    )
    for %%g in (!_group!) do (
        endlocal
        set "_prev_group=%%g"
    )
)
if "%_prev_group%" == "literal" (
    echo exit /b 0
    echo=
) >> ".coderender._literal"
exit /b 0
#+++

:coderender._type
call :functions.range _range "%~f0" "coderender._captured.%~1" || exit /b 2
call :readline "%~f0" !_range! 1:-1 4
exit /b 0


:lib.build_system [return_prefix]
set "%~1install_requires=functions.range readline"
set "%~1extra_requires=functions.range readline"
set "%~1category=packaging"
exit /b 0


:doc.man
::  NAME
::      coderender - a renderer for batch script
::
::  SYNOPSIS
::      coderender  <file> <label>
::
::  POSITIONAL ARGUMENTS
::      file
::          Path of the template file.
::
::      label
::          The function label that contains the template. Function/template
::          line range is determined by functions.range().
::
::  TEMPLATE SYNTAX
::      Each line of literal blocks starts with '::  ' or '::' (for empty lines), and the rest is codes.
::      Codes will run normally while literal blocks is just printed out literally.
::
::  ENVIRONMENT
::      tmp_dir
::          Path to store the temporary output.
::
::      temp
::          Fallback path for tmp_dir if tmp_dir does not exist
::
::  EXIT STATUS
::      0:  - Success.
::      2:  - Template not found.
::      3:  - Error rendering template (the function template exit code is not 0).
exit /b 0


:doc.demo
echo Render result of 'doc.demo.template':
call :coderender "%~f0" "doc.demo.template"
exit /b 0


:doc.demo.template
set "favorite=French fries"
::  Hello! I am a literal block
::  You get what you see: <|> ^()^
::
::  Marked by '::  ' at front, or '::' only for empty lines
:: I'm a comment
rem I'm also a comment
echo [!random!] > nul
if !random! LEQ 16384 (
::  Just another line...
) else (
::  It's another line!
)
for /l %%i in (1,1,3) do (
    set /p "=%%i: " < nul
::  Repeat
)
exit /b 0


:tests.setup
set "text="
exit /b 0


:tests.teardown
exit /b 0


:tests.test_literal
call :tests.type output.hello > "expected"
call :coderender "%~f0" "tests.template.literal" > "result"
fc /a /lb1 result expected > nul || (
    call %unittest% fail
)
exit /b 0

:tests.template.literal
::  Hello
::  Hi
::  Howdy
exit /b 0


:tests.test_code
call :tests.type output.hello > "expected"
call :coderender "%~f0" "tests.template.code" > "result"
fc /a /lb1 result expected > nul || (
    call %unittest% fail
)
exit /b 0

:tests.template.code
echo Hello
echo Hi
echo Howdy
exit /b 0


:tests.test_code_n_literal
call :tests.type output.hello > "expected"
call :coderender "%~f0" "tests.template.code_n_literal" > "result"
fc /a /lb1 result expected > nul || (
    call %unittest% fail
)
exit /b 0

:tests.template.code_n_literal
echo Hello
::  Hi
echo Howdy
exit /b 0


:tests.test_split_code
call :tests.type output.hello > "expected"
call :coderender "%~f0" "tests.template.split_code" > "result"
fc /a /lb1 result expected > nul || (
    call %unittest% fail
)
exit /b 0

:tests.template.split_code
set "text=Hi"
::  Hello
echo !text!
::  Howdy
exit /b 0


:tests.test_multiline_code
call :tests.type output.hello > "expected"
call :coderender "%~f0" "tests.template.multiline_code" > "result"
fc /a /lb1 result expected > nul || (
    call %unittest% fail
)
exit /b 0

:tests.template.multiline_code
for %%l in (H e l l o) do (
    < nul set /p "=%%l"
)
echo=
echo Hi
for %%l in (H o w d y) do (
    < nul set /p "=%%l"
)
echo=
exit /b 0


:tests.test_comments
call :tests.type output.hello > "expected"
call :coderender "%~f0" "tests.template.comments" > "result"
fc /a /lb1 result expected > nul || (
    call %unittest% fail
)
exit /b 0

:tests.template.comments
rem This is a comemnt
:: This is a another comemnt
::  Hello
::  Hi
::  Howdy
exit /b 0


:tests.test_empty_lines
call :tests.type output.empty_lines > "expected"
call :coderender "%~f0" "tests.template.empty_lines" > "result"
fc /a /lb1 result expected > nul || (
    call %unittest% fail
)
exit /b 0

:tests.template.empty_lines
::  Hello
::
::  Hi
exit /b 0


:tests.test_for_loop
call :tests.type output.repetition > "expected"
call :coderender "%~f0" "tests.template.for_loop" > "result"
fc /a /lb1 result expected > nul || (
    call %unittest% fail
)
exit /b 0

:tests.template.for_loop
for /l %%l in (1,1,2) do (
::  Hello
::  Hi
)
exit /b 0


:tests.test_if
call :tests.type output.hello > "expected"
call :coderender "%~f0" "tests.template.if" > "result"
fc /a /lb1 result expected > nul || (
    call %unittest% fail
)
exit /b 0

:tests.template.if
::  Hello
::  Hi
if "a" == "a" (
::  Howdy
) else (
::  Nah
)
exit /b 0


:tests.output.repetition
::  Hello
::  Hi
::  Hello
::  Hi
exit /b 0


:tests.output.hello
::  Hello
::  Hi
::  Howdy
exit /b 0


:tests.output.empty_lines
::  Hello
::
::  Hi
exit /b 0


:tests.type <name>
call :functions.range _range "%~f0" tests.%~1
call :readline "%~f0" !_range! 1:-1 4
exit /b


:EOF  # End of File
exit /b
