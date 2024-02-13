@echo off
setlocal enabledelayedexpansion

set "osArchitecture=64-bit"

::via env-var
if not defined ProgramFiles(x86) set "osArchitecture=32-bit"

::via file-system
if not exist "%systemdrive%\Program Files (x86)" set "osArchitecture=32-bit"


:: Set the appropriate download URL based on the architecture
if "!osArchitecture!"=="32-bit" (
    set "moduleURL=https://github.com/fluffy-servers/gmod-discord-rpc/releases/download/1.2.1/gmcl_gdiscord_win32.dll"
    set "moduleName=gmcl_gdiscord_win32.dll"
) else if "!osArchitecture!"=="64-bit" (
    set "moduleURL=https://github.com/fluffy-servers/gmod-discord-rpc/releases/download/1.2.1/gmcl_gdiscord_win64.dll"
    set "moduleName=gmcl_gdiscord_win64.dll"
) else (
    echo Error: Unable to determine OS architecture.
    exit /b 1
)

:: Download the binary module
:: echo Downloading module from: !moduleURL!
:: curl -o "!moduleName!" "!moduleURL!"
:github
git init
git clone https://github.com/colt7994/discord-gmod-rpc



:: If still not found, search all connected drives
if not defined steamPath (
    for %%d in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
        if exist "%%d:\Program Files (x86)\Steam\steamapps\common\GarrysMod" (
            set "steamPath=%%d:\Program Files (x86)\Steam\steamapps\common\GarrysMod"
            goto :found
        )
    )
)

if not defined steamPath (
    for %%d in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
        if exist "%%d:\SteamLibrary\steamapps\common\GarrysMod" (
            set "steamPath=%%d:\SteamLibrary\steamapps\common\GarrysMod"
            goto :found
        )
    )
)

:found
:: Move the binary module to the lua/bin folder
set "binaryModulePath=discord-gmod-rpc\!moduleName!"
set "destinationFolder=!steamPath!\garrysmod\lua\bin"

if exist "!destinationFolder!\!moduleName!" (
            echo Binary module already installed!
            goto:end
        )

if exist !binaryModulePath! (
    echo Found Binary Module!
    goto:checkdestination
) else (
    echo No Binary Module Found! Retrying Download...
    cd discord-gmod-rpc
    rmdir -rf discord-gmod-rpc
    goto:
)

:checkdestination
if exist !destinationFolder! (
    echo Found Destination Folder!
    goto:exist
) else (
    echo No Destination Folder, Creating One...
    cd !steamPath!\garrysmod\lua
    mkdir bin
    goto:checkdestination
)

:exist
echo Moving !binaryModulePath! to !destinationFolder!
move "!binaryModulePath!" "!destinationFolder!"

if exist "!destinationFolder!\!moduleName!" (
            echo Binary module moved successfully!
        ) else ( 
            echo FAILED to move Binary Module
            exit /b 1
        )
:end
pause