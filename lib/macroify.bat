:entry_point
call %*
exit /b


:macroify <return_var> <input_file> <label>
setlocal EnableDelayedExpansion
set "_return_var=%~1"
set "_input_file=%~f2"
set "_label=%~3"
cd /d "!tmp_dir!" 2> nul || cd /d "!tmp!"
call :functions.range _range "!_input_file!" "!_label!" || exit /b 3
call :readline "!_input_file!" !_range! 1:-1 > ".macroify" || exit /b 3
for /f "tokens=1-2 delims=:" %%a in ("!_range!") do (
    set /a "_lines=%%b - %%a - 1"
)
< ".macroify" (
    endlocal
    set "%_return_var%="
    for /l %%n in (1,1,%_lines%) do (
        set "macroify._line="
        set /p "macroify._line="
        if "!macroify._line:~-1,1!" == "^" (
            set "%_return_var%=!%_return_var%!!macroify._line:~0,-1!"
        ) else set "%_return_var%=!%_return_var%!!macroify._line!!LF!"
    )
    set "%_return_var%=!%_return_var%:%%%%=%%!"
)
set "macroify._line="
exit /b 0


:lib.dependencies [return_prefix]
set "%~1install_requires=functions.range readline"
set "%~1extra_requires=capchar"
set "%~1category=devtools"
exit /b 0


:doc.man
::  NAME
::      macroify - convert a function to macro
::
::  SYNOPSIS
::      macroify <return_var> <input_file> <label>
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the macro.
::
::      input_file
::          Path of the input file.
::
::      label
::          The function name.
::
::  ENVIRONMENT
::      macroify._line
::          A temporary variable. Might be overwritten if used.
::
::      LF
::          A Line Feed character. Needs to be defined (by capchar) before
::          using this function.
::
::  EXIT STATUS
::      0:  - Success
::      3:  - Cannot open input file
::          - Label not found
::          - Read line failed
::
::  NOTES
::      - Macro must use parentheses (e.g. '( %macro% )') except if all commands
::        can be read at once (advanced). For example:
::          - All commands are read at once:
::              ::  echo first & (
::              ::      echo second
::              ::  )
::          - Commands are read seperately:
::              ::  echo first
::              ::  echo second
exit /b 0


:doc.demo
call :capchar LF
call :macroify codes "%~f0" "tests.template.multiline"
echo RAW CODE
echo ========
call :functions.range _range "%~f0" "tests.template.multiline" || exit /b 3
call :readline "%~f0" !_range! 1:-1 || exit /b 3
echo=
echo MACRO CODE
echo ==========
echo !codes!
echo=
echo RESULT
echo ======
( %codes% )
exit /b 0


:tests.setup
call :capchar LF
exit /b 0


:tests.teardown
exit /b 0


:tests.test_multiline
set "codes="
call :macroify codes "%~f0" "tests.template.multiline"
> "result" (
    %codes%
)
set expected=Hello;Multiline macro;
set "result="
for /f "usebackq tokens=* delims=" %%o in ("result") do set "result=!result!%%o;"
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:tests.template.multiline
echo Hello
echo Multiline^
 macro
exit /b 0


:tests.test_set_var
for %%v in (codes var1 var2) do set "%%v="
call :macroify codes "%~f0" "tests.template.set_var"
( %codes% )
set result=!var1!, !var2!
set expected=hello, 6
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:tests.template.set_var
set "var1=hello"
set /a "var2=1 + 2 + 3"
exit /b 0


:tests.test_for_loop
set "codes="
call :macroify codes "%~f0" "tests.template.for_loop"
> "result" (
    %codes%
)
set expected=#1;#2;#3;#4;
set "result="
for /f "usebackq tokens=* delims=" %%o in ("result") do set "result=!result!%%o;"
if not "!result!" == "!expected!" (
    call %unittest% fail "Expected '!expected!', got '!result!'"
)
exit /b 0


:tests.template.for_loop
for /l %%n in (1,1,4) do echo #%%n
exit /b 0


:EOF
exit /b
