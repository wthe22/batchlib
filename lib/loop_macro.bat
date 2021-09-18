:entry_point
call %*
exit /b


:loop_macro [return_var] [loops] [stacks]
for %%v in (%1) do ( rem
) & for /f "tokens=1 delims==" %%b in ("%~2=256") do (
    set "%%v="
    for /l %%n in (1,1,%~3,2) do (
        set "%%v=!%%v!for /l %%^_ in (1,1,%%b) do "
    )
)
exit /b 0


:lib.dependencies [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=Input.number timeit pow"
set "%~1category=devtools"
exit /b 0


:doc.man
::  NAME
::      loop_macro - create a macro to do large loops
::
::  SYNOPSIS
::      loop_macro <return_var> [loops] [stacks]
::      %macro_name%   code
::
::  DESCRIPTION
::      Simulate "infinite" loop using FOR loops instead of using GOTO loops
::      (which is much slower). Unlike a normal single large loop, it is designed
::      to exit the FOR loop quickly when the 'EXIT /b' command is executed.
::
::      The FOR loop parameter '%_' is used internally. However, it does not
::      represent the current loops count.
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the macro.
::
::      loops
::          The number of the loops in a single FOR loop. The larger the loop,
::          the slower it takes to exit the macro. By default, it is '256'.
::
::      stacks
::          The number of nested FOR loops to use. The higher the stack,
::          the longer it takes to exhaust the macro. By default, it is '4'.
::
::  NOTES
::      - Total loops for a macro = loops ^ stacks
::      - By default, it takes 256^4 (= 4,294,967,296) loops to exhaust the macro
exit /b 0


:doc.demo
call :Input.number loops --range "0~1024" --optional || set "loops=256"
call :Input.number stacks --range "0~16" --optional || set "stacks=4"
call :Input.number quit_at_loop --range "0~2147483647" --optional || (
    set "quit_at_loop=300"
)
echo=

echo Loops per FOR loop     : !loops!
echo Stacks of FOR loops    : !stacks!
echo Quit loop at   : !quit_at_loop!
echo=
call :pow max_loops !loops! !stacks! || set "max_loops=> 2147483647"
echo Maximum macro loops    : !max_loops!
echo=
echo Measuring time needed to exit the loop...
call :loop_macro while_range !loops! !stacks!
call :timeit.setup_macro
%timeit% call :tests.stop_at !quit_at_loop!
exit /b 0


:tests.stop_at   loops
set "loops=0"
%while_range% (
    if "!loops!" == "%~1" exit /b 0
    set /a "loops+=1"
)
exit /b 0


:tests.demo
%while_range% (
    set /a "number=!random! %% 10"
    < nul set /p "=!number! "
    if "!number!" == "0" (
        echo=
        exit /b 0
    )
)
echo=
echo END OF LOOP
exit /b 0


:EOF
exit /b
