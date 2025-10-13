:entry_point
call %*
exit /b


:metadata [return_prefix]
set "%~1dependencies= "
set "%~1dev_dependencies=input_path input_string"
set "%~1categories=file"
exit /b 0


:checksum <return_var> <input_file> [hash]
set "%~1="
setlocal EnableDelayedExpansion EnableExtensions
set "_method="
set "_algorithm=%~3"
if not defined _algorithm set "_algorithm=sha1"
for %%a in (MD2 MD4 MD5 SHA1 SHA256 SHA384 SHA512) do (
    if /i "!_algorithm!" == "%%a" set "_method=certutil"
)
if not defined _method ( 1>&2 echo error: no known methods to perform hash '%~3' & exit /b 2 )
set "_result="
if "!_method!" == "certutil" (
    if "%~z2" == "0" (
        set "_result="
        if /i "!_algorithm!" == "MD2" set "_result=8350e5a3e24c153df2275c9f80692773"
        if /i "!_algorithm!" == "MD4" set "_result=31d6cfe0d16ae931b73c59d7e0c089c0"
        if /i "!_algorithm!" == "MD5" set "_result=d41d8cd98f00b204e9800998ecf8427e"
        if /i "!_algorithm!" == "SHA1" set "_result=da39a3ee5e6b4b0d3255bfef95601890afd80709"
        if /i "!_algorithm!" == "SHA256" (
            set "_result=e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
        )
        if /i "!_algorithm!" == "SHA384" for %%s in (
            38b060a751ac96384cd9327eb1b1e36a21fdb71114be0743
            4c0cc7bf63f6e1da274edebfe76f65fbd51ad2f14898b95b
        ) do set "_result=!_result!%%s"
        if /i "!_algorithm!" == "SHA512" for %%s in (
            cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce
            47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e
        ) do set "_result=!_result!%%s"
    ) else for /f "usebackq skip=1 tokens=*" %%a in (`certutil -hashfile "%~f2" !_algorithm!`) do (
        if not defined _result set "_result=%%a"
    )
)
for /f "tokens=*" %%r in ("!_result!") do (
    endlocal
    set "%~1=%%r"
)
exit /b 0


:doc.man
::  NAME
::      checksum - calculate checksum of a file
::
::  SYNOPSIS
::      checksum <return_var> <input_file> [hash]
::
::  POSITIONAL ARGUMENTS
::      return_var
::          Variable to store the result.
::
::      input_file
::          Path of the input file.
::
::      hash
::          The algorithm of the hash. Possible values for HASH are:
::              MD2, MD4, MD5, SHA1, SHA256, SHA384, SHA512
::          This option is case-insensitive. By default, it is 'SHA1'.
::
::  EXIT STATUS
::      0:  - Success.
::      2:  - No known methods to perform the specified hash.
exit /b 0


:doc.demo
call :input_path --exist --file --optional file_path || set "file_path=%~f0"
call :input_string --optional checksum_type
call :checksum checksum "!file_path!" !checksum_type!
echo=
echo File: !file_path!
echo Checksum: !checksum!
exit /b 0


:EOF
exit /b
