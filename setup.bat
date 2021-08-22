rem If setup is already done before, proceed to testing
call batchlib.bat -c :true && goto test_all


:setup
rem Convert linux EOL to windows EOL
for %%l in (lib\* batchlib.bat) do (
    type "%%l" | more /t4 > "%%l.tmp" && (
        move "%%l.tmp" "%%l" > nul
    )
)
rem Add dependencies to batchlib
cmd /c batchlib.bat build batchlib.bat
pause
exit /b 0


:test_all
rem Test the Batchlib core
cmd /c batchlib.bat -c :tests
rem Test all library functions
cmd /c batchlib.bat test
pause
exit /b 0
