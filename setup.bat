rem If setup is already done before, proceed to testing
cmd /c batchlib.bat -c :true && goto test_all

rem Convert linux EOL to windows EOL
for %%l in (lib\*) do (
    type "%%l" > "%%l.tmp"
    move /y "%%l.tmp" "%%l"
)
type batchlib.bat > batchlib.bat.tmp
move /y batchlib.bat.tmp batchlib.bat

rem Add dependencies to batchlib
cmd /c batchlib.bat build batchlib.bat


:test_all
rem Test the Batchlib core
cmd /c batchlib.bat -c :test

rem Test all library functions
cmd /c batchlib.bat test

pause
