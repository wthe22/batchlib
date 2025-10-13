:entry_point
call %*
exit /b


:metadata [return_prefix]
set "%~1dependencies=functions_range readline"
set "%~1dev_dependencies=functions_range readline get_os true"
set "%~1categories=algorithms"
exit /b 0


:coderender <file> <label> [--compile-only]
setlocal EnableDelayedExpansion EnableExtensions
set "_source_file=%~f1"
set "_label=%~2"
set "_render=true"
if "%~3" == "--compile-only" (
    set "_render="
)

cd /d "!tmp_dir!" 2> nul || cd /d "!tmp!"
call :functions_range _range "!_source_file!" "!_label!"
call :readline "!_source_file!" !_range! 1 > ".coderender._template" || exit /b 2
for %%f in (code literal) do call 2> ".coderender._%%f"
findstr /n "^" ".coderender._template" > ".coderender._numbered"
call :coderender._group_lines
if defined _render (
    set _write=^> ".coderender._render.bat"
)
%_write% (
    echo goto coderender._render
    echo=
    echo=
    echo :coderender._render
    type ".coderender._code"
    echo exit /b
    echo=
    echo=
    type ".coderender._literal"
    echo=
    echo=
    type "%~f0"
)
if defined _render (
    call ".coderender._render.bat" !_args! || exit /b 3
)
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
call :functions_range _range "%~f0" "coderender._captured.%~1" || exit /b 2
call :readline "%~f0" !_range! 1:-1 4
exit /b 0


:doc.man
::  NAME
::      coderender - simple template engine
::
::  SYNOPSIS
::      coderender <file> <label> --compile-only
::
::  DESCRIPTION
::      This function extracts the template codes into a file. That file will be
::      executed in order to render the output.
::
::      function -> render_template.bat -> output
::
::  POSITIONAL ARGUMENTS
::      file
::          Path of the template file.
::
::      label
::          The function label that contains the template. Function/template
::          line range is determined by functions_range().
::
::  OPTIONS
::      --compile-only
::          Generate codes to render the output instead of directly rendering
::          the output.
::
::  TEMPLATE SYNTAX
::      Each line of literal blocks starts with '::  ' or '::' (for empty lines),
::      and the rest are codes. Codes will run normally while literal blocks are
::      printed out literally. Template can access other parts of the file too
::      (e.g call functions).
::
::          rem This is a comment
::          :: This is also a comment
::          ::  This is a literal block!
::          rem The line below is a literal empty line
::          ::
::          if !score! GEQ 6 (
::          ::  You passed.
::              echo You score: !score!
::          ) else (
::          ::  You failed!
::          )
::
::  ENVIRONMENT
::      Global variables that affects this function:
::      - tmp_dir: Path to store the temporary files
::      - tmp: Fallback path of tmp_dir
::
::  EXIT STATUS
::      0:  - Success.
::      2:  - Template not found.
::      3:  - Error rendering template (the function template exit code is not 0).
exit /b 0


:doc.demo
cd /d "!tmp_dir!" 2> nul || cd /d "!tmp!"
echo Codes
echo =====
call :functions_range _range "%~f0" "doc.demo.template" || exit /b 2
call :readline "%~f0" !_range! 1:-1
echo=
echo Result
echo ======
call :coderender "%~f0" "doc.demo.template"
echo=
echo=
echo Result when using arguments:
echo ======================
call :coderender "%~f0" "doc.demo.template" --compile-only > "render.bat"
call "render.bat" add_extra
exit /b 0


:doc.demo.template
set "favorite=French fries"
::  Hello! I am a literal block
::  <What You See Is What You Get> ^(|)^
::
::  Marked by '::  ' at front, or '::' only for empty lines
:: I'm a comment
rem I'm also a comment
echo This wont appear > nul
if !random! LEQ 16384 (
::  The quick brown fox
) else (
::  The lazy dog
)
for /l %%i in (1,1,3) do (
::  Repeat
)
rem Functions within this file can be called too
call :get_os os_name --name
echo Windows Version: !os_name!
echo=
if "%~1" == "add_extra" (
::  The quick brown fox jumps over the lazy dog
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


:tests.test_call
call :tests.type output.function > "expected"
call :coderender "%~f0" "tests.template.function" > "result"
fc /a /lb1 result expected > nul || (
    call %unittest% fail
)
exit /b 0

:tests.template.function
call :true && (
::  PASS
) || (
::  FAIL
)
exit /b 0


:tests.test_args
call :tests.type output.hello > "expected"
call :coderender "%~f0" "tests.template.args" --compile-only > "template.bat"
call "template.bat" Howdy > "result"
fc /a /lb1 result expected > nul || (
    call %unittest% fail
)
exit /b 0

:tests.template.args
::  Hello
::  Hi
echo %1
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


:tests.output.function
::  PASS
exit /b 0


:tests.type <name>
call :functions_range _range "%~f0" tests.%~1
call :readline "%~f0" !_range! 1:-1 4
exit /b


:EOF
exit /b
