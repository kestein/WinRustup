@echo off

REM Downloads the most recently nightly, uninstalls the old version, and installs the newest version

REM defaults to nightly 32-bit GNU abi
SET channel=rust-nightly
SET arch=i686
SET abi=gnu
SET dlpath=%UserProfile%\Downloads\
SET baseurl=https://static.rust-lang.org/dist/

REM http://stackoverflow.com/questions/3973824/windows-bat-file-optional-argument-parsing
:loop
IF NOT "%1"=="" (
    IF "%1"=="/c" (
        SET channel=rust-%2
        SHIFT
    )
    IF "%1"=="/a" (
        SET arch=%2
        SHIFT
    )
    IF "%1"=="/abi" (
        SET abi=%2
        SHIFT
    )
    IF "%1"=="/P" (
        SET dlpath=%2
        SHIFT
    )
    IF "%1"=="/h" (
        GOTO :help
    )
    SHIFT
    GOTO :loop
)

SET filename=%channel%-%arch%-pc-windows-%abi%.msi

SET dlurl=%baseurl%%filename%
echo %dlurl%
PowerShell Invoke-WebRequest %dlurl% -OutFile %dlpath%\%filename%
msiexec /passive /uninstall %dlpath%\%filename%
msiexec /passive /i %dlpath%\%filename%
:help
echo "Updates rust on the current Windows machine"
echo "Usage: rustup.bat [/c CHANNEL /a ARCHITECTURE /abi ABI /P PATH]"
echo "Defaults to 32 bit GNU nightly"
:end