:entry_point > nul 2> nul
call %*
exit /b


:is_crlf [--check-exist]
:is_crlf.alt1
:is_crlf.alt2
for %%f in (-c, --check-exist) do if /i ^"%1^" == "%%f" exit /b 0
@call :is_crlf._test 2> nul && exit /b 0 || exit /b 2
rem  1  DO NOT REMOVE / MODIFY THIS COMMENT SECTION           #
rem  2  IT IS IMPORTANT FOR THIS FUNCTION TO WORK CORRECTLY   #
rem  3  This comment section should be exactly 511 characters #
rem  4  long when the EOL is LF (Unix EOL).                   #
rem  5                                                        #
rem  6                                                        #
rem  7  Last line should be 1 character                       #
rem  8  shorter than the rest               DO NOT MODIFY -> #
:is_crlf._test
@exit /b 0


:lib.build_system [return_prefix]
set "%~1install_requires= "
set "%~1category=packaging"
exit /b 0


:doc.man
::  NAME
::      is_crlf - check EOL type of current script
::
::  SYNOPSIS
::      is_crlf [--check-exist]
::      is_crlf.alt1 [--check-exist]
::      is_crlf.alt2 [--check-exist]
::
::  OPTIONS
::      -c, --check-exist
::          Check if function exist / is callable.
::
::  EXIT STATUS
::      0:  - EOL is Windows (CRLF)
::          - Function is callable
::      1:  - The function is uncallable.
::      2:  - EOL is Unix (LF)
::
::  NOTES
::      - Function MUST be embedded into the script to work correctly.
::      - If EOL is Mac (CR), this script would probably have crashed
::        in the first place.
exit /b 0


:doc.demo
for %%n in (1 2) do call :is_crlf.alt%%n --check-exist 2> nul && (
    call :is_crlf.alt%%n && (
        echo [is_crlf.alt%%n] EOL is Windows 'CRLF'
    ) || echo [is_crlf.alt%%n] EOL is Unix 'LF'
)
exit /b 0


:EOF  # End of File
exit /b
