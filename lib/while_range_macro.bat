:entry_point  # Beginning of file
call %*
exit /b


:while_range_macro [return_var] [base] [power]
for /f "tokens=1 delims==" %%v in ("%~1=while_range") do ( rem
) & for /f "tokens=1 delims==" %%b in ("%~2=256") do (
    set "%%v="
    for /l %%n in (1,1,%~3,2) do (
        set "%%v=!%%v!for /l %%^_ in (1,1,%%b) do "
    )
)
exit /b 0


:lib.dependencies [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=Input.number timeit"
set "%~1category=devtools"
exit /b 0


:doc.man
::  NAME
::      while_range_macro - setup macro for psuedo infinite loop
::
::  SYNOPSIS
::      while_range_macro [return_var] [base] [power]
::      %while_range%   code
::
::  DESCRIPTION
::      The aim of this macro is to emulate while true loops in batch script
::      as an alternative to the GOTO loop (which is much slower). This macro
::      is actually a FOR loop that will terminate after it reaches a certain
::      number of loops. Unlike a normal single large loop, it is designed to
::      exit the FOR loop quickly when the 'EXIT /b' command is executed.
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the macro. By default, it is 'while_range'.
::
::      base
::          The number of the loops in a single FOR loop. The larger the base,
::          the slower it takes to exit the loop. By default, it is '256'.
::
::      power
::          The number of nested FOR loops to use. The higher the power, the longer
::          it takes to exhaust the loop. The loops needed to exhaust the loop is
::          calculated as: 'base ^ power'. By default, it is '4'.
::
::  NOTES
::      - By default, it takes 256^4 (4294967296) loops to exhaust
exit /b 0


:doc.demo
call :Input.number base --range "0~1024" --optional || set "base=256"
call :Input.number power --range "0~16" --optional || set "power=4"
call :Input.number loops_to_quit --range "0~2147483647" --optional || (
    set "loops_to_quit=300"
)
echo=

call :timeit.setup_macro
call :while_range_macro while_range !base! !power!
echo Base   : !base!
echo Power  : !power!
echo Loops  : !loops_to_quit!
echo Measuring time needed to exit the loop...
%timeit% call :tests.stop_at !loops_to_quit!
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


:EOF  # End of File
exit /b
