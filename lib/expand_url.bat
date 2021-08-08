:entry_point  # Beginning of file
call %*
exit /b


:expand_url <return_prefix> <url>
pushd "%~d0\"
for %%v in (url scheme host port path name ext query fragment) do set "%~1%%v="
for /f "tokens=1* delims=#" %%a in ("%~2") do (
    set "%~1fragment=%%b"
    for /f "tokens=1* delims=?" %%c in ("%%a") do (
        set "%~1query=%%d"
        set "%~1host=%%c"
        for /f "tokens=1* delims=:\/" %%e in ("%%c") do (
            if "%%e://%%f" == "%%c" (
                set "%~1scheme=%%e"
                set "%~1host=%%f"
            )
        )
        for /f "tokens=1* delims=\/" %%e in ("!%~1host!") do (
            set "%~1path= %%~pf"
            set "%~1path=!%~1path:\=/!"
            set "%~1path=!%~1path:~1!"
            set "%~1name=%%~nf"
            set "%~1ext=%%~xf"
            for /f "tokens=1* delims=:" %%g in ("%%e") do (
                set "%~1host=%%g"
                set "%~1port=%%h"
            )
        )
    )
)
popd
if defined %~1scheme set "%~1url=!%~1url!!%~1scheme!://"
set "%~1url=!%~1url!!%~1host!"
if defined %~1port set "%~1url=!%~1url!:!%~1port!"
set "%~1url=!%~1url!!%~1path!!%~1name!!%~1ext!"
if defined %~1query set "%~1url=!%~1url!?!%~1query!"
if defined %~1fragment set "%~1url=!%~1url!#!%~1fragment!"
exit /b 0


:lib.dependencies [return_prefix]
set "%~1install_requires= "
set "%~1extra_requires=Input.string"
set "%~1category=net"
exit /b 0


:doc.man
::  NAME
::      expand_url - expands a given URL to several smaller pieces
::
::  SYNOPSIS
::      expand_url <return_prefix> <url>
::
::  POSITIONAL ARGUMENTS
::      return_prefix
::          The prefix of the variable to store the results.
::
::      link
::          The string of the link to expand.
::
::  EXAMPLE
::      url        https://blog.example.com:80/1970/01/news.html?page=1#top
::      scheme     https
::                      ://
::      hostname           blog.example.com
::                                         :
::      port                                80
::      path                                  /1970/01/
::      filename                                       news
::      extension                                          .html
::                                                              ?
::      query                                                    page=1
::                                                                     #
::      fragment                                                        top
::
::  NOTES
::      - IPv6 URLs are not supported.
::      - The 'url' variable is the rebuild of the original url.
exit /b 0


:doc.demo
call :Input.string web_url || set "web_url=https://blog.example.com:80/1970/01/news.html?page=1#top"
call :expand_url web_url. "!web_url!"
set web_url
exit /b 0


:tests.setup
:tests.teardown
exit /b 0


:tests.test_all
for %%a in (
    "https://blog.example.com:80/1970/01/news.html?page=1#top"
) do (
    set "result="
    call :expand_url result. %%a
    if not "!result.url!" == "%%~a" (
        call %unittest% fail "Expected '%%~a', got '!result.url!'"
    )
)
exit /b 0


:EOF  # End of File
exit /b
