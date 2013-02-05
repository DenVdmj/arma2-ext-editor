setlocal

set Z7=%ProgramFiles%\7-Zip\7z.exe
set Z7param= -m0=PPMd

set DistribDir=%ThisPath%..\..\distrib\ext-editor (revision %RevisionNumber%)
set DistribDir_modDir=%DistribDir%\ArmA2\@\ext-editor

:MakeDistrib

    echo ------------------------------------
    echo -- START CREATE DISTRIBUTION PACK --
    echo ------------------------------------

    if exist "%DistribDir%" rmdir /S /Q "%DistribDir%"
    if exist "%DistribDir%" call :Die "die: error!"

    if not exist "%DistribDir%\ArmA2" mkdir "%DistribDir%\ArmA2"
    if not exist "%DistribDir_modDir%\addons" mkdir "%DistribDir_modDir%\addons"

    echo xcopy addons files:
    xcopy /E /Y "%TargetAddonDir%" "%DistribDir_modDir%\addons"

    if exist "%DistribDir_modDir%\addons\log" rmdir /S /Q "%DistribDir_modDir%\addons\log"

    if exist "mod.cpp" copy "mod.cpp" "%DistribDir_modDir%\mod.cpp"
    if exist "readme*.txt" copy "readme*.txt" "%DistribDir_modDir%\*"

    xcopy /E /Y "arma-gamer-profile" "%DistribDir%\arma-gamer-profile\\*"

    if exist "%DistribDir%.7z" del "%DistribDir%.7z"
    if exist "%DistribDir%.7z" call :Die "die: error!"

    "%Z7%" a -r0 -t7z -mx9 %Z7param% -scsDOS -- "%DistribDir%.7z" "%DistribDir%\*"

    if not exist "%DistribDir%.7z" call :Die "die: error creating '%DistribDir%.7z'!"

goto :eof

:Die
    echo %~1
    exit
goto :eof
