:entry_point > nul 2> nul
call %*
exit /b


:updater [-n] [-y] [-f] [-d url] <script_path>
setlocal EnableDelayedExpansion
for %%v in (_assume_yes _query_only _force _main_url _alt_url) do set "%%v="
call :argparse ^
    ^ "#1:store                     :_this" ^
    ^ "-n,--notify-only:store_const :_notify_only=true" ^
    ^ "-y,--yes:store_const         :_assume_yes=true" ^
    ^ "-f,--force:store_const       :_force=true" ^
    ^ "-d,--download-url:store      :_main_url" ^
    ^ -- %* || exit /b 2
for %%f in ("!_this!") do set "_this=%%~ff"
cd /d "!tmp!" & ( cd /d "!tmp_dir!" 2> nul )
set "_other=!cd!\latest.bat"
call "!_this!" -c :metadata _this. || (
    1>&2 echo%0: Fail to read metadata & exit /b 3
)
if not defined _main_url set "_main_url=!_this.download_url!"
if not defined _main_url (
    1>&2 echo%0: No download url found & exit /b 3
)
set "_success="
call :download_file "!_main_url!" "!_other!" && set "_success=true"
if not defined _success ( 1>&2 echo%0: Download failed & exit /b 4 )
call "!_other!" -c :metadata _other. || (
    1>&2 echo%0: Fail to read downloaded metadata & exit /b 5
)
set "_mismatch="
if not "!_other.name!" == "!_this.name!" (
    echo warning: script name is different: '!_this.name!' and '!_other.name!'
    set "_mismatch=true"
)
call :parse_version _this._p_ver "!_this.version!"
call :parse_version _other._p_ver "!_this.version!"
if "!_other._p_ver!" LSS "!_this._p_ver!" (
    echo No updates are available
) else if "!_other._p_ver!" == "!_this._p_ver!" (
    echo You are using the latest version
) else (
    echo !_this.name! !_this.version! upgradable to !_other.name! !_other.version!
)
if defined _notify_only exit /b 0
if not defined _force (
    if "!_other._p_ver!" LEQ "!_this._p_ver!" exit /b 0
)
if not defined _assume_yes (
    call :Input.yesno -d "N" -m "Proceed with update? [y/N] " || exit /b 0
)
(
    copy /b /y /v "!_other!" "!_this!" > nul
) && (
    echo Update success
    exit /b 0
) || exit /b 7
exit /b 1


:lib.build_system [return_prefix]
set "%~1install_requires=argparse download_file parse_version Input.yesno"
set "%~1extra_requires=ping_test coderender get_pid_by_title Input.path"
set "%~1category=packaging"
exit /b 0


:doc.man
::  NAME
::      updater - update a batch script from the internet
::
::  SYNOPSIS
::      updater [-n] [-y] [-f] [-d url] <script_path>
::
::  DESCRIPTION
::      Notify for updates, download them, and update the script.
::      The script must accept the argument '-c :metadata <prefix>' to get
::      metadata of the script (name, version, download_url).
::
::  POSITIONAL ARGUMENTS
::      return_prefix
::          Prefix of the variable to store the metadata (if exit code is 0)
::
::      script_path
::          Path of the (batch) file.
::
::  OPTIONS
::      -n, --notify-only
::          Notify about updates only, do not upgrade script
::
::      -y, --yes
::          Assume yes when prompt
::
::      -f, --force
::          Force update even if incompatibility is detected or script is
::          already the newest version
::
::      -d URL, --download-url URL
::          Use this URL to download instead of the one set in metadata()
::
::  ENVIRONMENT
::      tmp_dir
::          Path to store the update file.
::
::      temp
::          Fallback path for tmp_dir if tmp_dir does not exist
::
::  EXIT STATUS
::      0:  - Success
::      2:  - Invalid parameters
::      3:  - Failed to get script upgrade information
::      4:  - Failed to download update
::      5:  - Failed to retrive update information
::      6:  - Module name does not match.
::      7:  - Upgrade failed.
::
::  NOTES
::      - This function is still experimetal and is subject to change.
exit /b 0


:doc.demo
call :Input.path --exist --file script_file --optional || exit /b 0
call :updater "!script_file!"
exit /b 0


:tests.setup
set "server_is_up="
set "test_server_title=test_server_!random!"
start /min "!test_server_title!" cmd /c twistd ftp -r .
timeout /t 3 > nul
call :get_pid_by_title server_pid "!test_server_title!" && (
    set "server_is_up=true"
)
call :coderender "%~f0" tests.template.dummy  > "dummy.bat"
exit /b 0


:tests.teardown
if defined server_is_up (
    taskkill /f /t /pid !server_pid! > nul
)
exit /b 0


:tests.test_notify
if not defined server_is_up (
    call %unittest% skip "Test server is down"
    exit /b 0
)
call :updater -n "dummy.bat" > nul || (
    call %unittest% fail
)
exit /b 0


:tests.test_force_update
if not defined server_is_up (
    call %unittest% skip "Test server is down"
    exit /b 0
)
call :updater -f -y "dummy.bat" > nul || (
    call %unittest% fail
)
exit /b 0


:tests.template.dummy
::  :entry_point > nul 2> nul
::  @goto main
::
::
::  :metadata [return_prefix]
::  set "%~1name=dummy"
::  set "%~1version=0.1"
::  set "%~1author=anon"
::  set "%~1license=The MIT License"
::  set "%~1description=Dummy Script"
::  set "%~1release_date=12/31/2000"
::  set "%~1url="
::  set "%~1download_url=ftp://localhost:2121/dummy.bat"
::  exit /b 0
::
::
::  :main
::  @if ^"%1^" == "-c" @goto scripts.call
::  @goto scripts.main
::
::
::  :scripts.main
::  @setlocal EnableDelayedExpansion EnableExtensions
::  @echo off
::  1>&2 echo warning: wrong entry point
::  @exit /b
::
::
::  :scripts.call <label> [arguments]
::  @(
::      setlocal DisableDelayedExpansion
::      call set command=%%*
::      setlocal EnableDelayedExpansion
::      for /f "tokens=1* delims== " %%a in ("!command!") do @(
::          endlocal
::          endlocal
::          call %%b
::      )
::  )
::  @exit /b
exit /b 0


:EOF  # End of File
exit /b
