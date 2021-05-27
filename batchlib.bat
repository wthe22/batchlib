:entry_point > nul 2> nul
@goto main


rem ======================================== Metadata ========================================

:metadata [return_prefix]
set "%~1name=batchlib"
set "%~1version=3.0a"
set "%~1author=wthe22"
set "%~1license=The MIT License"
set "%~1description=Batch Script Library"
set "%~1release_date=05/26/2021"   :: mm/dd/YYYY
set "%~1url=https://github.com/wthe22/batchlib"
set "%~1download_url=https://raw.githubusercontent.com/wthe22/batch-scripts/master/batchlib.bat"
exit /b 0


:about
setlocal EnableDelayedExpansion
call :metadata
echo !description! / !name! !version! ^(!release_date!^)
echo=
echo A collection of functions/snippets for batch script
echo Created to make batch scripting easier
echo=
echo Updated on !release_date!
echo=
echo Feel free to use, share, or modify this script for your projects :)
echo Visit http://winscr.blogspot.com/ for more scripts^^!
echo=
echo=
echo Copyright (C) 2020 by !author!
echo Licensed under !license!
endlocal
exit /b 0


rem ======================================== License ========================================

:license
echo MIT License
echo=
echo Copyright 2020 wthe22
echo=
echo Permission is hereby granted, free of charge, to any person obtaining a
echo copy of this software and associated documentation files (the "Software"),
echo to deal in the Software without restriction, including without limitation
echo the rights to use, copy, modify, merge, publish, distribute, sublicense,
echo and/or sell copies of the Software, and to permit persons to whom the
echo Software is furnished to do so, subject to the following conditions:
echo=
echo The above copyright notice and this permission notice shall be included in
echo all copies or substantial portions of the Software.
echo=
echo THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
echo OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
echo FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
echo AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
echo LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
echo FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
echo DEALINGS IN THE SOFTWARE.
exit /b 0


rem ======================================== Configurations ========================================

:config
call :config.default
call :config.preference
exit /b 0


:config.default
rem Default/common configurations. DO NOT MODIFY

rem Directory for temporary files
set "tmp_dir=!tmp!\!SOFTWARE.name!\!__name__!"
rem Directory to keep library, builds, etc.
set "lib_dir=%~dp0lib"
set "build_dir=%~dp0build"
exit /b 0


:config.preference
rem Configurations to change/override

set "tmp_dir=%~dp0tmp\tmp"
exit /b 0


rem ======================================== Changelog ========================================

:changelog
::  Core
::  - Renamed/remove all double underscore labels
::  - Improve menu structure
::  - Adjust function and category loading to read from each library file
::  - Add call, build, debug, run, test, and template command
::  - Script can self-build to satisfy dependencies (manual build)
::
::  Library
::  - Added dependency listing for extra requirements (for tests and demo)
::  - Move libraries to out of this script, with each library having its own file
::  - Since each library have its own file, it needs to be build to run correctly
::  - New functions:
::      - quicktest()
::      - utpy()
::      - mtime_to_isotime()
::      - get_pid_by_title()
::      - true()
::      - Input.number()
::  - Replaced functions:
::      - parse_args() -> argparse()
::      - textrender() -> coderender()
::      - extract_func() -> functions.range(), readline()
::  - Renamed functions:
::      - find_range() -> functions.match()
::      - roman2int() -> roman.decode()
::      - int2roman() -> roman.encode()
::      - bytes2size() -> bytes.format()
::      - size2bytes() -> bytes.parse()
::      - int2*() -> int.to_*()
::      - *2int() -> int.from_*()
::      - time2epoch() -> epoch.from_time()
::      - epoch2time() -> epoch.to_time()
::  - Removed functions:
::      - depsolve(): Reworked, it is now a core function, not a library anymore.
::      - module(): Unmaintainable, too complex. Use new script template instead.
::  - New features:
::      - Input.yesno(): Add option to set default value
::      - combi_wcdir(): Custom seperator
::      - Input.number(): Mark input as optional
::      - strip(): support question mark character
::  - Bug fixes:
::      - dosterm()/conemu(): Multiline commands
::      - get_pid(): Unique id not used
::      - capchar(): Only first argument is processed
::      - wcdir(): Error if LF is not defined before calling script
::      - pow(): Error if base number is 0
::  - Non-functional improvements:
::      - Functions with return values
::      - Functions that uses:
::          - parse_args()/argparse(),
::          - extract_func()/functions.range()/readline()
::      - Input.path()
::      - timeleft(): improve usability when copied
::  - Has backward incompatible changes:
::      - find_label() or functions.match(): Change function signature
::      - combi_wcdir(): Change function signature
::      - updater(): Reworked, now includes ui
::      - unittest(): Reworked
::      - dosterm()/conemu(): Cannot change prompt message anymore
::      - Input.*(): Exit status adjustment
::      - clear_line_macro(): Return var is now required
::      - get_os(): Return full os version
::
::  Minified Script
::  - Removed library tests
::
::  Tests
::  - Simplify test label names
::
::  Documentation
::  - All documentations is now written in comments
::  - Make library parameters usage docs more consistent
::  - Most demo now have auto generated input
exit /b 0


:changelog.todo
::  - Check docs
exit /b 0


rem ======================================== Main ========================================

:main
@if ^"%1^" == "/?" @goto doc.help
@if ^"%1^" == "-h" @goto doc.help
@if ^"%1^" == "--help" @goto doc.help
@if ^"%1^" == "-c" @goto scripts.call
@if ^"%1^" == "" @goto scripts.main
@call :scripts.%*
@exit /b


rem ======================================== Entry points ========================================

:scripts  # Entry points of the script
@exit /b 0


:scripts.call <label> [arguments]
@(
    setlocal DisableDelayedExpansion
    call set command=%%*
    setlocal EnableDelayedExpansion
    for /f "tokens=1* delims== " %%a in ("!command!") do @(
        endlocal
        endlocal
        call %%b
    )
)
@exit /b


:scripts.main
@setlocal EnableDelayedExpansion EnableExtensions
@echo off
call :common_setup
cls
echo !SOFTWARE.description! !SOFTWARE.version!
echo=
echo Loading...
call :Library.read_args
call :Category.load
call :LibBuild.remove_orphans
call :main_menu
exit /b


:scripts.build <file>
@setlocal EnableDelayedExpansion EnableExtensions
@echo off
call :common_setup
call :true 2> nul || set "lib=:lib.call "
call :build_script %*
exit /b


:scripts.debug <library> [arguments]
@setlocal EnableDelayedExpansion EnableExtensions
@echo off
call :common_setup
set "library=%~1"
for %%v in ("Library_!library!.extra_requires") do set "%%~v=!%%~v! quicktest"
call :LibBuild.build "!library!"
endlocal & cd /d "%build_dir%"
if not defined debug set "debug=1>&2"
call %*
exit /b


:scripts.run <library> [arguments]
@setlocal EnableDelayedExpansion EnableExtensions
@echo off
call :common_setup
set "library=%~1"
call :LibBuild.update "!library!"
endlocal & cd /d "%build_dir%"
if not defined debug set "debug=rem"
call %*
exit /b


:scripts.test <library>
@setlocal EnableDelayedExpansion EnableExtensions
@echo off
call :common_setup
call :run_lib_test %1
exit /b


:scripts.template <name>
@setlocal EnableDelayedExpansion EnableExtensions
@echo off
call :common_setup
call :make_template %1
exit /b


:common_setup
call :metadata SOFTWARE.
call :config
set "lib="

for %%p in (
    "!tmp_dir!"
    "!lib_dir!"
    "!build_dir!"
) do if not exist %%p md %%p

call :Library.unload_info
call :Library.read_names
call :Library.read_build_system
exit /b 0


rem ======================================== User Interfaces ========================================

:ui  # User Interfaces
exit /b 0


rem ================================ Main Menu ================================

:main_menu
set "user_input="
cls
echo !SOFTWARE.description! !SOFTWARE.version!
echo=
echo 1. Browse documentation
echo 2. Use command line
echo 3. Generate minified version
echo 4. Generate new script template
echo 5. Build/add dependencies to a script
echo=
echo B. Self Build
echo R. Reload Library
echo T. Test Libraries
echo A. About Script
echo C. Change Log
echo 0. Exit
echo=
echo What do you want to do?
set /p "user_input="
echo=
if "!user_input!" == "0" exit /b 0
if "!user_input!" == "1" call :browse_lib
if "!user_input!" == "2" call :conemu
if "!user_input!" == "3" call :new_template_menu "minified_script" "Minified Script"
if "!user_input!" == "4" call :new_template_menu "new_script" "New Script Template"
if "!user_input!" == "5" call :build_menu
if /i "!user_input!" == "B" (
    setlocal EnableDelayedExpansion
    set "lib=:lib.call "
    call :build_script "%~f0"
    endlocal
    pause
)
if /i "!user_input!" == "R" (
    call :Library.unload_info
    call :Library.read_names
    call :Library.read_build_system
    call :Library.read_args
    call :Category.load
    call :LibBuild.remove_orphans
)
if /i "!user_input!" == "T" (
    cls
    call :run_lib_test
    pause
    goto main_menu
)
if /i "!user_input!" == "A" (
    cls
    call :about
    echo=
    pause
    goto main_menu
)
if /i "!user_input!" == "C" call :show_changelog
goto main_menu


:show_changelog
cls
call :functions.range _range "%~f0" "changelog"
call :readline "%~f0" !_range! 1:-1 4
echo=
pause
exit /b 0


:browse_lib
set "selected.quit="
set "selected.category="
set "selected.function="
:browse_lib.loop
if defined selected.quit exit /b 2
if not defined selected.category (
    call :InputCategory selected.category || (
        set "selected.quit=true"
        goto browse_lib.loop
    )
)
if not defined selected.function (
    call :InputFunction selected.function !selected.category! || (
        set "selected.category="
        goto browse_lib.loop
    )
)
call :LibMenu !selected.function!
set "selected.function="
goto browse_lib.loop


:InputCategory <return_var>
set "_selected="
call :InputCategory.select_menu
set "%~1=!_selected!"
if not defined _selected exit /b 2
exit /b 0
#+++

:InputCategory.select_menu
set "user_input="
cls
call :InputCategory.get_item list
echo=
echo S. Search function
echo 0. Back
echo=
echo Which category do you want to choose?
set /p "user_input="
if "!user_input!" == "0" exit /b 2
if /i "!user_input!" == "S" (
    call :InputCategory.search_menu && exit /b 0
) else call :InputCategory.get_item "!user_input!" && exit /b 0
goto InputCategory.select_menu
#+++

:InputCategory.get_item <list|number>
set "_count=0"
for %%c in (!Category.all!) do (
    if not "!Category_%%c.item_count!" == "0" (
        set /a "_count+=1"
        if /i ^"%1^" == "list" (
            set "_count=   !_count!"
            echo !_count:~-3,3!. !Category_%%c.name! [!Category_%%c.item_count!]
        ) else if "%~1" == "!_count!" set "_selected=%%c"
    )
)
if not defined _selected exit /b 2
exit /b 0
#+++

:InputCategory.search_menu
set "user_input="
cls
echo 0. Back
echo=
echo Input search keyword:
set /p "user_input="
if "!user_input!" == "0" exit /b 2
call :Library.search Category_search.functions "!user_input!"
set "_selected=search"
set "Category_search.name=Search Result for '!user_input!'"
set "Category_search.item_count=0"
for %%f in (!Category_search.functions!) do set /a "Category_search.item_count+=1"
exit /b 0


:InputFunction <return_var> <category>
set "_category=%~2"
set "_selected="
call :InputFunction.select_menu
set "%~1=!_selected!"
if not defined _selected exit /b 2
exit /b 0
#+++

:InputFunction.select_menu
set "user_input="
cls
for %%c in (!_category!) do (
    echo=!Category_%%c.name!
)
echo=
set "_count=0"
for %%c in (!_category!) do ( rem
) & for %%f in (!Category_%%c.functions!) do (
    set /a "_count+=1"
    set "_count=   !_count!"
    echo !_count:~-3,3!. !Library_%%f.args!
)
echo=
echo 0. Back
echo=
echo Which function do you want to choose?
set /p "user_input="
if "!user_input!" == "0" exit /b 2
set "_count=0"
for %%c in (!_category!) do ( rem
) & for %%f in (!Category_%%c.functions!) do (
    set /a "_count+=1"
    if "!user_input!" == "!_count!" (
        set "_selected=%%f"
        exit /b 0
    )
)
goto InputFunction.select_menu
#+++

:InputFunction.get_item <list|number>
set "_count=0"
for %%c in (!_category!) do ( rem
) & for %%f in (!Category_%%c.functions!) do (
    set /a "_count+=1"
    if /i ^"%1^" == "list" (
        set "_count=   !_count!"
        echo !_count:~-3,3!. !Library_%%f.args!
    ) else if "%~1" == "!_count!" set "_selected=%%f"
)
if not defined _selected exit /b 2
exit /b 0


:LibMenu <function>
set "_library=%~1"
set "_library_source=!lib_dir!\!_library!.bat"
set "_library_build=!build_dir!\!_library!.bat"
call "!_library_source!" :lib.build_system "Library_!_library!." 2> nul
call :LibBuild.update "!_library!"
call :LibMenu.menu
exit /b 0
#+++

:LibMenu.menu
set "user_input="
cls
echo !Library_%_library%.args!
echo=
echo 1. Read manual
echo 2. Run demo
echo 3. Run tests
echo=
echo 0. Back
echo=
echo What do you want to do?
set /p "user_input="
echo=
if "!user_input!" == "0" exit /b 0
if "!user_input!" == "1" call :LibMenu.read_manual
if "!user_input!" == "2" call :LibMenu.run_demo
if "!user_input!" == "3" call :LibMenu.run_tests
goto LibMenu.menu


:LibMenu.read_manual
setlocal EnableDelayedExpansion
cls
call :functions.range _range "!_library_source!" "doc.man" && (
    call :readline "!_library_source!" !_range! 1:-1 4
)
echo=
pause
exit /b 0


:LibMenu.run_demo
setlocal EnableDelayedExpansion
cls
call :functions.range _range "!_library_source!" "doc.man" && (
    call :readline "!_library_source!" !_range! 1:-1 4
)
echo=
echo ================================================================================
echo=
call "!_library_build!" :doc.demo
echo=
pause
exit /b 0


:LibMenu.run_tests
call :run_lib_test !_library!
pause
exit /b 0


:new_template_menu <template> <description>
setlocal EnableDelayedExpansion
set "_template=%~1"
set "_description=%~2"
call :Input.path save_file --file ^
    ^ --message "Input new template file path: "
if exist "!save_file!" (
    call :Input.yesno _ ^
        ^ --message "File already exist. Overwrite file? Y/N? "
) || exit /b 0
echo=
echo !_description! path:
echo !save_file!
echo=
echo Generating...
set "start_time=!time!"
call :coderender "%~f0" "template.!_template!" > "!save_file!"
call :difftime time_taken "!time!" "!start_time!"
call :ftime time_taken !time_taken!
echo=
echo Done in !time_taken!
pause
exit /b 0


:build_menu
call :Input.path script_file --file --exist ^
    ^ --message "Input script path: "
call :Input.path save_file --file ^
    ^ --message "Input save path: "
if exist "!save_file!" (
    call :Input.yesno _ ^
        ^ --message "File already exist. Overwrite file? Y/N? "
) || exit /b 0
echo=
echo Generating...
set "start_time=!time!"
call :scripts.build "!script_file!" -c :lib.build_system > "!save_file!"
call :difftime time_taken "!time!" "!start_time!"
call :ftime time_taken !time_taken!
echo=
echo Done in !time_taken!
pause
exit /b 0


rem ======================================== Documentation ========================================

:doc.help
@setlocal EnableDelayedExpansion EnableExtensions
@echo off

echo usage:
echo    batchlib
echo        Run batchlib in interactive mode
echo=
echo    batchlib (-h^|--help^|/?)
echo        Show this help
echo=
echo    batchlib -c ^<:label^> [arguments]
echo        Call the specified label with arguments
echo=
echo    batchlib build ^<input_file^> [backup_name]
echo        Add dependency to a file
echo=
echo    batchlib (run^|debug) ^<library^> ^<:label^> [arguments]
echo        Run/debug a library
echo=
echo    batchlib test [library]
echo        Run unittest to a library
echo=
echo    batchlib template ^<name^>
echo        Create the specified template and output to STDOUT.
echo=
exit /b 0


:doc.man
::  NAME
::      batchlib - batch script library/utility
::
::  SYNOPSIS
::      batchlib
::      batchlib (-h|--help|/?)
::      batchlib -c <:label> [arguments]
::      batchlib build <input_file> [backup_name]
::      batchlib (run|debug) <library> <:label> [arguments]
::      batchlib test [library]
::      batchlib template <name>
::
::  CALL SUBCOMMAND
::          batchlib -c <:label> [arguments]
::
::      Make batchlib CALL the specified label with the following arguments.
::
::  BUILD SUBCOMMAND
::          batchlib build <input_file> [backup_name]
::
::      Build a script and add/update dependency to the file and do backup if the
::      backup path is specified. The procedures are:
::          - File is called with '-c :lib.build_system' parameter and dependencies
::            is set to the 'install_requires' variable.
::          - Codes between entry_point() and EOF() are persisted. The rest will
::            be lost (e.g. if you write notes above entry_point or below the EOF
::            label) so do backup if you are unsure.
::          - Add/update dependency listed in 'install_requires' variable to file,
::            below the EOF() label.
::          - Build is aborted if any steps above fails.
::
::      POSITIONAL ARGUMENTS
::          input_file
::              Path of the input file to build.
::
::          backup_name
::              Path of the backup file.
::
::  RUN and DEBUG SUBCOMMAND
::          batchlib (run|debug) <library> <:label> [arguments]
::
::      Run the (built) library and call :LABEL with the ARGUMENTS.
::      The DEBUG subcommand have some more addition to the RUN subcommand:
::      - quicktest() is also included in the 'extra_requires' dependency list
::      - If the 'debug' variable is not defined, then it is set to:
::          - '1>&2' in the DEBUG subcommand (output is redirected to STDERR)
::          - 'rem' in the RUN subcommand (command will not be executed)
::      - Library is always rebuilt before running, even if there is no changes
::
::  TEST SUBCOMMAND
::          batchlib test [library]
::
::      Run unittest to a library. If no library is given, it will
::      test all libraries instead.
::
::  TEMPLATE SUBCOMMAND
::          batchlib template <name>
::
::      Create the specified template and output to STDOUT.
::      Valid template names are: minified_script, new_script, new_library.
exit /b 0


:doc._guides
::  Variable names: [A-Za-Z_][A-Za-z0-9_.][A-Za-z0-9]
::  - Starts with an alphabet or underscore
::  - Only use alphabets, numbers, underscores, dashes, and dots
::  - Ends with an alphabet, underscore, or number
::  - Use variable names as a namespace
::
::  Note:
::  - Most functions assumes that the syntax is valid
::  - external: something that is stored in other files
exit /b 0


rem ========================================================================

rem ======================================== Core Functions ========================================

:core  # Core Functions
exit /b 0


:run_lib_test [library]
setlocal EnableDelayedExpansion
set "_library=%~1"
if defined _library (
    call :LibBuild.update "!_library!"
    set "target=!build_dir!\!_library!.bat"
) else (
    call :LibBuild.update
    set "target=!build_dir!\*.bat"
)
call :Library.unload_info
set test_reporter=call :utpy
cmd /q /e:on /v:on /c ""%~f0" -c :unittest "!target!" --target-args "" --output "test_reporter""
exit /b


:build_script <input_file> [backup_name]
setlocal EnableDelayedExpansion
set "_input_file=%~f1"
set "_backup_file=%~f2"
cd /d "!tmp_dir!" 2> nul || cd /d "!tmp!"
set "_minified="
call :scripts.minified 2> nul && set "_minified=true"
if defined _minified set "lib="
call "!_input_file!" -c :lib.build_system || exit /b 3
call :Library.depends _dep "!install_requires!" || exit /b 3
call :Library.unload_info
call %lib%:functions.range _range "!_input_file!" "entry_point EOF" || exit /b 3
for /f "tokens=1,3 delims=:" %%a in ("!_range!") do set "_range=%%a:%%b"
> "_build_script.tmp" (
    call %lib%:readline "!_input_file!" !_range! || exit /b 3
    echo=
    echo=
    echo :: Automatically Added on !date! !time!
    echo=
    if defined _minified (
        call :functions.range _ranges "%~f0" "!_dep!" || exit /b 3
        for %%r in (!_ranges!) do (
            call :readline "%~f0" %%r || exit /b 3
            echo=
            echo=
        )
    ) else (
        for %%l in (!_dep!) do (
            call %lib%:functions.range _range "!lib_dir!\%%l.bat" "%%l" || exit /b 3
            call %lib%:readline "!lib_dir!\%%l.bat" !_range! || exit /b 3
            echo=
            echo=
        )
    )
) || exit /b 3
if defined _backup_file (
    copy /b /v /y "!_input_file!" "!_backup_file!" > nul || exit /b 3
)
move /y "_build_script.tmp" "!_input_file!" > nul || exit /b 3
exit /b 0


:make_template <name>
setlocal EnableDelayedExpansion
set "template_name=%~1"
call :coderender "%~f0" "template.!template_name!"
exit /b


:self_extract_func <label>
call :functions.range _range "%~f0" "%~1" || exit /b 2
call :readline "%~f0" !_range!
echo=
echo=
exit /b 0


:Category.load
call :Category.load_names
call :Category.build
exit /b 0


:Category.load_names
set "Category.all= "
set "Category.default=none"
for %%a in (
    "all: All"
    "number: Number"
    "string: String"
    "time: Date and Time"
    "file: File and Folder"
    "net: Network"
    "env: Environment"
    "ui: User Interface"
    "console: Console"
    "packaging: Packaging"
    "devtools: Development Tools"
    "external: External"
    "none: Uncategorized"
    "search: Search Results"
) do for /f "tokens=1* delims=: " %%c in (%%a) do (
    set "Category.all=!Category.all!%%c "
    set "Category_%%c.name=%%d"
)
set "Category.valid_values=!Category.all!"
for %%c in (all none search) do (
    set "Category.valid_values=!Category.valid_values: %%c = !"
)
exit /b 0


:Category.build
set "Category_all.functions=!Library.all!"
for %%l in (!Library.all!) do (
    set "_category="
    for %%c in (!Library_%%l.category!) do (
        if defined Category_%%c.name (
            set "_category=!_category! %%c"
        ) else ( 1>&2 echo%0: unknown category '%%c' in %%l^(^) )
    )
    if not defined _category set "_category=!Category.default!"
    for %%c in (!_category!) do (
        set "Category_%%c.functions=!Category_%%c.functions! %%l"
    )
)
for %%c in (!Category.all!) do (
    set "_count=0"
    for %%l in (!Category_%%c.functions!) do set /a "_count+=1"
    set "Category_%%c.item_count=!_count!"
)
exit /b 0


:LibBuild.remove_orphans
for %%l in ("!build_dir!\*") do (
    if not exist "!lib_dir!\%%~nxl" (
        echo remove leftover build of %%~nl^(^)
        del /f /q "%%~fl"
    )
)
exit /b 0


:LibBuild.update [library [...]]
setlocal EnableDelayedExpansion
set "_library=%~1"
if not defined _library set "_library=!Library.all!"
call :LibBuild.find_outdated _to_build "!_library!"
if not defined _to_build exit /b 0
echo Updating: !_to_build!
for %%l in (!_to_build!) do (
    echo building %%l^(^)
    call :LibBuild.build "%%l"
)
exit /b 0


:LibBuild.find_outdated <return_var> <library [...]>
setlocal EnableDelayedExpansion
set "_return_var=%~1"
set "_library=%~2"
set "_result= "
for %%l in (!_library!) do (
    for %%f in ("!build_dir!\%%l.bat") do set "_btime=%%~tf"
    for %%v in (_btime) do (
        set "%%v=!%%v:~6,4!-!%%v:~0,2!-!%%v:~3,2!T!%%v:~17,2!!%%v:~11,2!:!%%v:~14,2!"
        set "%%v=!%%v:M12=M00!"
    )
    set "_is_outdated="
    call :Library.depends _dep "%%l" "install extra"
    for %%d in (!_dep!) do if not defined _is_outdated (
        for %%f in ("!lib_dir!\%%d.bat") do set "_mtime=%%~tf"
        for %%v in (_mtime) do (
            set "%%v=!%%v:~6,4!-!%%v:~0,2!-!%%v:~3,2!T!%%v:~17,2!!%%v:~11,2!:!%%v:~14,2!"
            set "%%v=!%%v:M12=M00!"
        )
        if "!_btime!" LEQ "!_mtime!" set "_is_outdated=true"
    )
    if defined _is_outdated set "_result=!_result!%%l "
)
for /f "tokens=1* delims=:" %%a in ("Q:!_result!") do (
    endlocal
    set "%_return_var%=%%b"
    if "!%_return_var%!" == " " set "%_return_var%="
)
exit /b 0


:LibBuild.build <library [...]>
setlocal EnableDelayedExpansion
set "_library=%~1"
cd /d "!tmp_dir!" 2> nul || cd /d "!tmp!"
if not exist "!build_dir!" mkdir "!build_dir!"
for %%l in (!_library!) do (
    set "_dep=!Library_%%l.install_requires!"
    for %%r in (install extra) do set "_dep=!_dep! !Library_%%l.%%r_requires!"
    call :LibBuild.build._template "!lib_dir!\%%l.bat" "!_dep!" > "%%l.bat.tmp" && (
        move /y "%%l.bat.tmp" "!build_dir!\%%l.bat" > nul
    ) || (
        1>&2 echo%0: could not build %%l^(^)
        del /f /q "%%l.bat.tmp"
    )
)
exit /b 0
#+++

:LibBuild.build._template <source> [dependency [...]]
setlocal EnableDelayedExpansion
set "_source=%~f1"
set "_dependencies=%~2"
cd /d "!tmp_dir!" 2> nul || cd /d "!tmp!"
echo :: Generated on !date! !time!
echo=
echo=
type "!_source!"
echo=
echo=
echo :: Automatically Added
echo=
call :Library.depends _dep "!_dependencies!" || exit /b 3
call :Library.unload_info
for %%l in (!_dep!) do (
    call %lib%:functions.range _range "!lib_dir!\%%l.bat" "%%l" || exit /b 3
    call %lib%:readline "!lib_dir!\%%l.bat" !_range! || exit /b 3
    echo=
    echo=
)
exit /b 0


:Library.unload_info
for %%p in ("Library." "Library_") do (
    for /f "usebackq tokens=1 delims==" %%v in (`set %%~p 2^> nul`) do (
        set "%%v="
    )
)
exit /b 0


:Library.read_names
setlocal EnableDelayedExpansion
set "_result= "
for %%f in ("!lib_dir!\*.bat") do (
    set "_filename=%%~nf"
) & if not "!_filename:~0,1!" == "_" (
    set "_tokens="
    for %%_ in (!_filename!) do set "_tokens=!_tokens!1"
) & if not "!_tokens!" == "1" (
    1>&2 echo%0: invalid function name: '%%~nf'
) else set "_result=!_result!!_filename! "
for /f "tokens=1* delims=:" %%a in ("Q:!_result!") do (
    endlocal
    set "Library.all=%%b"
)
exit /b 0


:Library.read_args
goto Library.read_args.from_lib_dir


:Library.read_args.from_lib_dir
for %%l in (!Library.all!) do (
    for /f "usebackq tokens=1*" %%a in ("!lib_dir!\%%l.bat") do ( rem
    ) & if /i "%%a" == ":%%l" (
        set "Library_%%l.args=%%l   %%b"
    )
    if not defined Library_%%l.args (
        1>&2 echo%0: could not read arguments for '%%l'
    )
)
exit /b 0


:Library.read_args.from_self
for /f "usebackq tokens=1*" %%a in ("%~f0") do ( rem
) & for /f "tokens=1 delims=:" %%l in ("%%a") do (
    if ":%%l" == "%%a" if not "!Library.all: %%l = !" == ":%%l" (
        set "Library_%%l.args=%%l   %%b"
    )
)
for %%l in (!Library.all!) do (
    if not defined Library_%%l.args (
        1>&2 echo%0: could not read arguments for '%%l'
    )
)
exit /b 0


:Library.read_build_system
for %%l in (!Library.all!) do (
    set "Library_%%l.install_requires=?"
    call "!lib_dir!\%%l.bat" :lib.build_system "Library_%%l." 2> nul || (
        1>&2 echo%0: failed to call lib.build_system^(^) in '%%l'
    )
)
exit /b 0


:Library.depends <return_var> <library [...]> [requires [...]]
setlocal EnableDelayedExpansion
set "_return_var=%~1"
set "_library=%~2"
set "_requires=%~3"
if not defined _requires set "_requires=install"
set "_search_list= "
for %%l in (!_library!) do (
    for %%r in (!_requires!) do (
        for /f "tokens=1-2 delims=[]" %%a in ("%%l[%%r]") do (
            set "_search_list=!_search_list!%%a[%%b] "
        )
    )
)
set "_result= "
set "_stack="
set "_bad="
set "_errorlevel=0"
call :Library.depends._visit "!_search_list!"
set "_result=!_result:[install] = !"
call :Library.remove_extras_pkg _result
for /f "tokens=1* delims=:" %%a in ("Q:!_result!") do (
    endlocal
    set "%_return_var%=%%b"
    if "%%b" == " " set "%_return_var%="
    exit /b %_errorlevel%
)
exit /b 1
#+++

:Library.depends._visit <library [...]>
set "_lib= "
for %%l in (%~1) do ( rem
) & for /f "tokens=1-2 delims=[]" %%a in ("%%l[install]") do (
    set "_lib= %%a[%%b]!_lib!"
    )
)
for %%l in (%_lib%) do ( rem
) & for /f "tokens=1-2 delims=[]" %%a in ("%%l") do (
    set "_stack=%%a[%%b] !_stack!"
    set "_visit=true"
    if not "!_stack: %%a[%%b] =!" == "!_stack!" (
        1>&2 echo%0: cyclic dependencies detected in stack: !_stack!
        set /a "_errorlevel|=0x4"
        set "_visit="
    )
    if not "!_result: %%a[%%b] =!" == "!_result!" set "_visit="
    if not defined Library_%%a.install_requires (
        1>&2 echo%0: failed to resolve dependency in stack: !_stack!
        set /a "_errorlevel|=0x2"
        set "_visit="
    )
    if defined _visit (
        call :Library.depends._visit "!Library_%%a.%%b_requires!"
    )
    if "!_result: %%a[%%b] =!" == "!_result!" set "_result= %%a[%%b]!_result!"
    for /f "tokens=1* delims= " %%r in ("!_stack!") do set "_stack=%%s"
)
exit /b 0


:Library.rdepends <return_var> <search_list> <library [...]> [requires [...]]
setlocal EnableDelayedExpansion
set "_return_var=%~1"
set "_search_list_raw=%~2"
set "_library=%~3"
set "_requires=%~4"
if not defined _requires set "_requires=install"
set "_search_list="
for %%l in (!_search_list_raw!) do (
    for %%r in (!_requires!) do (
        for /f "tokens=1-2 delims=[]" %%a in ("%%l[%%r]") do (
            set "_search_list=!_search_list! %%a[%%b]"
        )
    )
)
set "_match_list="
for %%l in (!_library!) do (
    for /f "tokens=1-2 delims=[]" %%a in ("%%l[install]") do (
        set "_match_list=!_match_list! %%a[%%b]"
    )
)
set "_result= "
set "_stack="
set "_visited= "
call :Library.rdepends._visit "!_search_list!"
set "_result=!_result:[install] = !"
call :Library.remove_extras_pkg _result
for /f "tokens=1* delims=:" %%a in ("Q:!_result!") do (
    endlocal
    set "%_return_var%=%%b"
    if "%%b" == " " set "%_return_var%="
)
exit /b 0
#+++

:Library.rdepends._visit <library [...]>
for %%l in (%~1) do ( rem
) & for /f "tokens=1-2 delims=[]" %%a in ("%%l[install]") do (
    set "_stack=%%a[%%b] !_stack!"
    set "_match="
    for %%m in (!_match_list!) do if "%%a[%%b]" == "%%m" set "_match=true"
    if defined _match (
        for %%s in (!_stack!) do (
            if "!_result: %%s =!" == "!_result!" set "_result= %%s!_result!"
        )
    ) else (
        set "_visit=true"
        if not "!_stack: %%a[%%b] =!" == "!_stack!" set "_visit="
        if not "!_visited: %%a[%%b] =!" == "!_visited!" set "_visit="
        if not defined Library_%%a.install_requires set "_visit="
        if defined _visit (
            set "_visited= %%a[%%b]!_visited!"
            call :Library.rdepends._visit "!Library_%%a.%%b_requires!"
        )
    )
    for /f "tokens=1* delims= " %%r in ("!_stack!") do set "_stack=%%s"
)
exit /b 0


:Library.remove_extras_pkg <variable>
setlocal EnableDelayedExpansion
set "_variable=%~1"
set "_value=!%~1!"
set "_result= "
for %%l in (!_value!) do ( rem
) & for /f "tokens=1-2 delims=[]" %%a in ("%%l") do (
    if "!_result: %%a =!" == "!_result!" set "_result=!_result!%%a "
)
for /f "tokens=1* delims=:" %%a in ("Q:!_result!") do (
    endlocal
    set "%_variable%=%%b"
    if "%%b" == " " set "%_return_var%="
)
exit /b 0


:Library.search <return_var> <keyword>
setlocal EnableDelayedExpansion
set "_return_var=%~1"
set "_keyword=%~2"
set "_result= "
for /f "tokens=* delims=" %%k in ("!_keyword!") do (
    for %%l in (!Library.all!) do (
        set "_temp= !Library_%%l.args!"
        if not "!_temp:%%k=!" == "!_temp!" (
            set "_result=!_result!%%l "
        )
    )
)
for /f "tokens=1* delims=:" %%a in ("Q:!_result!") do (
    endlocal
    set "%_return_var%=%%b"
    if "%%b" == " " set "%_return_var%="
    if not defined %_return_var% exit /b 2
)
exit /b 0


:legacy_support.updater
:module.entry_point   [-c command]
:__init__ > nul 2> nul
exit /b 0
:__metadata__   [return_prefix]
call :metadata %1
exit /b


rem ======================================== Library ========================================

:lib  # Functions/snippets from library
exit /b 0


:lib.build_system [return_prefix]
set %~1install_requires= ^
    ^ functions.range readline ^
    ^ true coderender unittest utpy ^
    ^ conemu Input.path Input.yesno Input.string ^
    ^ difftime ftime
exit /b 0


:lib.call <library> [args]
@for /f "tokens=1 delims=: " %%a in ("%~1") do @(
    goto 2> nul
    call "%lib_dir%\%%a.bat" %*
)
@exit /b 1


rem ======================================== Templates ========================================

:template.new_library
call :Category.load
::  :entry_point > nul 2> nul
::  call %*
::  exit /b
::
::
::  :your_library_name_here [--options] <args>
::  rem Library name should start with an alphablet. Library name should only
::  rem contain the characters A-Z, a-z, 0-9, dot '.', and/or dash '-'.
::  rem File name should be the same as the library name.
::
::  rem Library ends with an 'exit' or 'goto' statement, followed by an empty line.
::  exit /b 0
::
::
::  :lib.build_system [return_prefix]
::  rem If your libaray have dependencies, write it here. If there isn't any
::  rem dependencies, just put a space inside.
::  set "%~1install_requires= "
::
::  rem Libraries needed to run demo, tests, etc. If there isn't any, just empty it.
::  set "%~1extra_requires="
::
::  rem Category of the library. Choose ones that fit.
::  rem Multiple values are supported (each seperated by space)
echo set "%%~1category=!Category.valid_values!"
::  exit /b 0
::
::
::  :doc.man
::  ::  NAME
::  ::      your_library_name_here - a new library
::  ::
::  ::  SYNOPSIS
::  ::      your_library_name_here [--options] <args>
::  ::
::  ::  DESCRIPTION
::  ::      A good library should have a good documentation too!
::  exit /b 0
::
::
::  :doc.demo
::  rem A demo would help users understand how to use it
::  call :your_library_name_here && (
::      echo Success
::  ) || echo Failed...
::  exit /b 0
::
::
::  :tests.setup
::  rem Called before running tests
::  exit /b 0
::
::
::  :tests.teardown
::  rem Called after running tests
::  exit /b 0
::
::
::  :tests.test_something
::  rem Do some tests here...
::  exit /b 0
::
::
call :self_extract_func "EOF"
exit /b 0


:template.new_script
set "sep_line="
for /l %%n in (1,1,40) do set "sep_line=!sep_line!="

::  :entry_point > nul 2> nul
::  @goto main
::
::
echo rem !sep_line! Metadata !sep_line!
::
::  :metadata [return_prefix]
::  set "%~1name=__main__"
::  set "%~1version=0"
::  set "%~1author="
::  set "%~1license="
::  set "%~1description=%~nx0"
::  set "%~1release_date=05/18/2021"   :: mm/dd/YYYY
::  set "%~1url="
::  set "%~1download_url="
::  exit /b 0
::
::
echo rem !sep_line! Configurations !sep_line!
::
::  :config
::  call :config.default
::  call :config.preference
::  exit /b 0
::
::
::  :config.default
::  rem Default/common configurations
::  exit /b 0
::
::
::  :config.preference
::  rem Configurations to change/override
::  exit /b 0
::
::

echo rem !sep_line! Main !sep_line!
::
::  :main
::  @if ^"%1^" == "-c" @goto scripts.call
::  @goto scripts.main
::
::

echo rem !sep_line! Entry Points !sep_line!
echo=
call :self_extract_func "scripts.call"
::  :scripts.main
::  @setlocal EnableDelayedExpansion EnableExtensions
::  @echo off
::  rem TODO: start scripting...
::  @exit /b
::
::

echo rem !sep_line! Library !sep_line!
echo=
call :self_extract_func "lib"
::  :lib.build_system
::  set "%~1install_requires="
::  exit /b 0
::
::

echo rem !sep_line! Tests !sep_line!
echo=
call :self_extract_func "tests"
::  :tests.setup
::  exit /b 0
::
::
::  :tests.teardown
::  exit /b 0
::
::

echo rem !sep_line! End !sep_line!
echo=
call :self_extract_func "EOF"
exit /b 0


:template.minified_script
call :Library.unload_info
call :Library.read_names
call :Library.read_build_system
call :Category.load
set "sep_line="
for /l %%n in (1,1,40) do set "sep_line=!sep_line!="

call :self_extract_func "entry_point"

echo rem !sep_line! Metadata !sep_line!
echo=
for %%l in (
    metadata
    about
) do call :self_extract_func "%%l"

echo rem !sep_line! License !sep_line!
echo=
call :self_extract_func "license"

echo rem !sep_line! Configurations !sep_line!
echo=
call :self_extract_func "config"
call :self_extract_func "config.default"
call :self_extract_func "config.preference"

echo rem !sep_line! Main !sep_line!
echo=
call :self_extract_func "main"

echo rem !sep_line! Entry Points !sep_line!
echo=
call :self_extract_func "scripts.call"
::  :scripts.minified
::  rem Indicator that script is minified
::  exit /b 0
::
::
::  :scripts.main
::  @setlocal EnableDelayedExpansion EnableExtensions
::  @echo off
::  call :common_setup
::  cls
::  echo !SOFTWARE.description! !SOFTWARE.version!
::  echo=
::  call :conemu
::  exit /b 0
::
::
for %%l in (
    scripts.build
    scripts.template
    common_setup
) do call :self_extract_func "%%l"

echo rem !sep_line! Documentation !sep_line!
echo=
for %%l in (
    doc.help
    doc.man
) do call :self_extract_func "%%l"

echo rem !sep_line! Core Functions !sep_line!
echo=
for %%l in (
    core
    build_script
    make_template
    self_extract_func
    Library.unload_info
) do call :self_extract_func "%%l"

::  :Library.read_names
::  set Library.all= ^
set "_count=0"
set "_value="
for %%l in (!Library.all!) do (
    set /a "_count+=1"
    set "_value=!_value! %%l"
    if "!_count!" == "8" (
        echo     ^^^^ !_value:~1! ^^^^
        set "_count=0"
        set "_value="
    )
)
if defined _value echo     ^^^^ !_value:~1! ^^^^
echo     ^^^^ %%=END=%%!!
::  exit /b 0
::
::
::  :Library.read_build_system
for %%l in (!Library.all!) do (
    for %%a in (
        install_requires extra_requires
    ) do for %%v in (Library_%%l.%%a) do (
        if defined %%v echo set "%%v=!%%v!"
    )
)
::  exit /b 0
::
::
::  :Library.read_args
::  goto Library.read_args.from_self
::
::
for %%l in (
    Library.read_args.from_self
    Library.depends
    Library.rdepends
    Library.remove_extras_pkg
    Library.search
) do call :self_extract_func "%%l"

echo rem !sep_line! Templates !sep_line!
echo=
call :self_extract_func "template.new_script"

echo rem !sep_line! Tests !sep_line!
echo=
call :self_extract_func "tests"

echo rem !sep_line! Library !sep_line!
echo=
for %%l in (
    lib
    lib.build_system
    lib.call
) do call :self_extract_func "%%l"
call :Library.depends ordered_lib "!Library.all!"
for %%l in (!ordered_lib!) do (
    call :functions.range _range "!lib_dir!\%%l.bat" "%%l"
    call :readline "!lib_dir!\%%l.bat" !_range!
    echo=
    echo=
)

echo rem !sep_line! End !sep_line!
echo=
call :self_extract_func "EOF"
exit /b 0


rem ======================================== Tests ========================================

:tests  # Tests codes and data
exit /b 0


:test
@setlocal EnableDelayedExpansion
@echo off
set test_reporter=call :utpy
call :unittest --output test_reporter
exit /b 0


:tests.setup
exit /b 0


:tests.teardown
exit /b 0


:tests.Library.test_unload
set "Library.test=hello hi"
set "Library_hello.install_requires=hi"
set "Library_hello.args=hello   <name>"
call :Library.unload_info
set "success=true"
for %%v in (
    Library.test
    Library_hello.install_requires
    Library_hello.args
) do if defined %%v set "success="
if not defined success (
    call %unittest% fail
)
exit /b 0


:tests.Library.test_read_names
if exist "dummy_lib" rd /s /q "dummy_lib"
mkdir "dummy_lib"
for %%d in (dummy_lib) do set "lib_dir=%%~fd"
call 2> "!lib_dir!\_hidden.bat"
call 2> "!lib_dir!\hi.bat"
call 2> "!lib_dir!\hello.vbs"
call :Library.read_names
set "result=!Library.all!"
set "expected= hi "
if not "!result!" == "!expected!" (
    call %unittest% fail "expected '!expected!', got '!result!'"
)
exit /b 0


:tests.Library.test_read_args
if exist "dummy_lib" rd /s /q "dummy_lib"
mkdir "dummy_lib"
for %%d in (dummy_lib) do set "lib_dir=%%~fd"
> "!lib_dir!\hi.bat" (
    echo :hi ^<name^> [message]
)
set "Library.all=hi"
call :Library.read_args
set "result=!Library_hi.args!"
set "expected=hi   <name> [message]"
if not "!result!" == "!expected!" (
    call %unittest% fail "expected '!expected!', got '!result!'"
)
exit /b 0


:tests.Library.test_depends
set "Library.all=bed chair plank stick table wood wool"
set "Library_table.install_requires=plank stick"
set "Library_chair.install_requires=plank wool stick"
set "Library_bed.install_requires=plank wool"
set "Library_plank.install_requires= "
set "Library_stick.install_requires= "
set "Library_wood.install_requires= "
set "Library_wool.install_requires= "
set "given=table wool bed"
set "expected= table stick bed plank wool "
call :Library.depends result "!given!"
if not "!result!" == "!expected!" (
    call %unittest% fail "given '!given!', expected '!expected!', got '!result!'"
)
exit /b 0


:tests.Library.test_depends_extra
set "Library.all=plank stick table"
set "Library_table.install_requires=plank stick"
set "Library_plank.install_requires= "
set "Library_stick.install_requires= "
set "Library_stick.extra_requires=table"
set "given=stick stick[extra]"
set "expected= stick table plank "
call :Library.depends result "!given!"
if not "!result!" == "!expected!" (
    call %unittest% fail "given '!given!', expected '!expected!', got '!result!'"
)
exit /b 0


:tests.Library.test_depends_cyclic
set "Library.all=chichen egg"
set "Library_chicken.install_requires=egg"
set "Library_egg.install_requires=chicken"
set "given=chicken egg"
call :Library.depends result "!given!" 2> nul && (
    call %unittest% fail "given '!given!', expected failure, got '!result!'"
)
exit /b 0


:tests.Library.test_depends_unresolvable
set "Library.all=magic"
set "Library_magic.install_requires="
set "given=magic"
call :Library.depends result "!given!" 2> nul && (
    call %unittest% fail "given '!given!', expected failure, got '!result!'"
)
exit /b 0


:tests.Library.test_search
set "Library.all=plank stick table"
set "Library_plank.args=plank   <width> <height>"
set "Library_stick.args=stick   <length>"
set "Library_table.args=table   <length> <width> <height>"
set "given=eng"
call :Library.search result "eng"
set "expected= stick table "
if not "!result!" == "!expected!" (
    call %unittest% fail "expected '!expected!', got '!result!'"
)
exit /b 0


rem ======================================== End ========================================

:EOF  # End of File
exit /b
