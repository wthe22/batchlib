:entry_point  # Beginning of file
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


:lib.build_system [return_prefix]
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
::          Path of the input (batch) file.
::
::      label
::          The function name.
::
::  ENVIRONMENT
::      macroify._line
::          A temporary variable. Might be overwritten if used.
::
::  EXIT STATUS
::      What the exit code of your function means. Some examples are:
::      0:  - Success
::      3:  - Cannot open input file
::          - Label not found
::          - Read line failed
exit /b 0


:doc.demo
call :capchar LF
call :macroify codes "%~f0" "tests.template.echo"
echo CODES
echo =====
echo !codes!
echo=
echo RESULT
echo ======
( %codes% )
exit /b 0


:tests.setup
exit /b 0


:tests.teardown
exit /b 0


:tests.template.echo
echo Hello
echo Hi
exit /b 0


:EOF  # End of File
rem DO NOT WRITE ANYTHING YOU NEED TO KEEP BELOW THIS FUNCTION.
rem ANYTHING BEYOND THIS FUNCTION WILL BE REMOVED WHEN ADDING DEPENDENCIES.
exit /b


