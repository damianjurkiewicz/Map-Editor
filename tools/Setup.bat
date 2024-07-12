@echo off
set "projectdir=%CD%"
set "PLUGIN_NAME="MapEditorSA""

:find_vs_path
set "vs_path="
for %%d in (Community Preview Professional) do (
    for /d %%e in ("C:\Program Files\Microsoft Visual Studio\2022\%%d") do (
        if exist "%%e\Common7\Tools\VsDevCmd.bat" (
            set "vs_path=%%e"
            goto :check_game_path
        )
    )
)
goto :eof

:check_game_path
if "%GTA_SA_DIR%"=="" (
    echo Error: GTA_SA_DIR environment variable is not set.
    exit /b 1
)

:vs_install_found
if not defined vs_path (
    echo Error: Visual Studio installation not found.
    exit /b 1
)

:psdk_install_found
if "%PLUGIN_SDK_DIR%"=="" (
    echo Error: PLUGIN_SDK_DIR environment variable is not set.
    exit /b 1
)

:run_premake
cd "%projectdir%\tools"
premake5.exe vs2022

:run_dev
cd "%projectdir%\build"
call %vs_path%"\Common7\Tools\VsDevCmd.bat"