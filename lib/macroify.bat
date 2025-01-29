:entry_point
call %*
exit /b


:macroify <return_var> <input_file> <label>
setlocal EnableDelayedExpansion
set "_return_var=%~1"
set "_input_file=%~f2"
set "_label=%~3"
cd /d "!tmp_dir!" 2> nul || cd /d "!tmp!"
call :functions_range _range "!_input_file!" "!_label!" || exit /b 3
call :readline "!_input_file!" !_range! 1:-1 > ".macroify" || exit /b 3
for /f "tokens=1-2 delims=:" %%a in ("!_range!") do (
    set /a "_lines=%%b - %%a - 1"
)
< ".macroify" (
    endlocal
    set "%_return_var%="
    for /l %%n in (1,1,%_lines%) do (
        set ".macroify._line="
        set /p ".macroify._line="
        if "!.macroify._line:~-1,1!" == "^" (
            set "%_return_var%=!%_return_var%!!.macroify._line:~0,-1!"
        ) else set "%_return_var%=!%_return_var%!!.macroify._line!!LF!"
    )
    set "%_return_var%=!%_return_var%:%%%%=%%!"
)
set ".macroify._line="
exit /b 0


:lib.dependencies [return_prefix]
set "%~1install_requires=functions_range readline"
set "%~1extra_requires=capchar"
set "%~1category=algorithms"
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
::      This function creates and uses the following global variables:
::          - .macroify._line: A temporary variable
::
::      LF
::          A Line Feed character. Needs to be defined (by capchar) before
::          using this function.
::
::  DEVELOPMENT AND USAGE
::      There are few things to know when making a macro.
::
::      When function becomes a macro, there are some behavior changes:
::          - %...% variables does not work, must use !...! instead
::          - But %%a %~1 %%~b etc. works normally
::
::      When using a macro, in most cases you have to put the macro inside a
::      code block (parentheses) so that it can work normally.
::
::          rem ERROR:
::          %strip:$args=text1%
::
::          rem OK:
::          ( %strip:$args=text1% )
::
::          rem Also OK:
::          if "!strip_text!" == "true" (
::              rem It works because it is inside a parentheses
::              %strip:$args=text1%
::          )
::
::      The key is to make cmd think that your function is a single block of
::      command or inside one.
::
::  EXIT STATUS
::      0:  - Success
::      3:  - Cannot open input file
::          - Label not found
::          - Read line failed
exit /b 0


:doc.demo
call :capchar LF
call :macroify codes "%~f0" "tests.template.demo"
echo RAW CODE
echo ========
call :functions_range _range "%~f0" "tests.template.demo" || exit /b 3
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


:tests.template.demo
set "variable=correct"
echo Hello^^!
echo This will not be expanded: %variable%
echo This will be expanded: !variable!
echo Caret ^^ works normally
echo Multiline ^
text
for /l %%n in (1,1,3) do echo #%%n
exit /b 0


:EOF
exit /b
