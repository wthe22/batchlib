:entry_point
call %*
exit /b


:metadata [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires="
set "%~1category=cli"
exit /b 0


:conemu
@(
    call :conemu.setup
    set "conemu._errorlevel=0"
    call :conemu._loop
    call :conemu.cleanup
)
@exit /b 0
#+++

:conemu._loop
@for /l %%# in (1,1,256) do @for /l %%# in (1,1,256) do @(
    call :conemu._prompt_cmd
)
@goto conemu._loop
#+++

:conemu._prompt_cmd
@call :conemu.prompt
@setlocal EnableDelayedExpansion EnableExtensions
@set "_cmd="
@for /l %%# in (1,1,16) do @for /l %%# in (1,1,16) do @(
    set "_input="
    set /p "_input=" || exit /b 0
    set "_cmd=!_cmd!!_input!"
    if not "!_input:~-1,1!" == "^" @goto conemu._exec_cmd
    set "_cmd=!_cmd:~0,-1!"
    call :conemu.prompt_more
)
exit /b 2
#+++

:conemu._exec_cmd
@(
    goto 2> nul
    set "conemu._errorlevel="
    cmd /c exit /b %conemu._errorlevel%
    %_cmd%
    call set "conemu._errorlevel=%%errorlevel%%"
)
exit /b 1
#+++

:conemu.setup
@(
    set "conemu._parent_prompt=!prompt!"
    prompt $g$s
)
@exit /b 0
#+++

:conemu.cleanup
@(
    prompt !conemu._parent_prompt!
)
exit /b 0
#+++

:conemu.prompt
@(
    setlocal EnableDelayedExpansion
    for /f "usebackq delims=" %%h in (`hostname`) do @( set "_host=%%h" )
    set "_cwd=!cd!\"
    for %%h in ("!userprofile!") do @( set "_cwd=!_cwd:%%~h\=~\!" )
    set "_cwd=!_cwd:~0,-1!"
    set "_prompt=!username!@!_host! !_cwd!"
    if not "!conemu._errorlevel!" == "0" @(
        set "_prompt=!_prompt! [!conemu._errorlevel!]"
    )
    set /p "=!_prompt!> " < nul
)
@exit /b 0
#+++

:conemu.prompt_more
@(
    set /p "=> " < nul
)
exit /b 0


:doc.man
::  NAME
::      conemu - interactive command line interface emulator
::
::  SYNOPSIS
::      conemu
::
::  DESCRIPTION
::      conemu is a interactive command line interface in a batch script.
::      It allows users to type in command and do interactive debugging.
::
::      The interface is not bulletproof; you could crash the script by entering
::      a command with invalid syntax, but it behaves well if the syntax entered
::      is valid.
::
::  NOTES
::      - EnableDelayedExpansion must be activated before calling this function
::      - Invalid syntax could cause script to stop unexpectedly
::      - Percent signs are not expanded:
::          - Displaying variables that uses percent will not work,
::            please use exclamation mark or the CALL command instead.
::          - Use single percent sign on codes that normally use double percent sign
::      - Errorlevel behaves similarly to command prompt
exit /b 0


:doc.demo
echo Welcome to conemu, the batch script interactive console interface
echo Type 'exit /b' to quit.
echo=
call :conemu
exit /b 0


:EOF
exit /b
