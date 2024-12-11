# Installation pack
- Visual Studio Code portable
- Git portable
- MinGW
- JKD
- Maven
- Python

## Visual Studio Code portable mode installation

### About

This mode enables all data created and maintained by VS Code to live near itself, so it can be moved around across environments.
This mode also provides a way to set the installation folder location for VS Code extensions, useful for corporate environments that prevent extensions from being installed in the Windows AppData folder.

### Data folder

See the [Download page](https://code.visualstudio.com/download) to find the correct .zip file for your platform.
After unzipping the VS Code download, create a **data** folder within VS Code's folder.
From then on, that folder will be used to contain all VS Code data, including session state, preferences, extensions, etc.
The ***data*** folder can be moved to other VS Code installations. This is useful for updating your portable VS Code version, in which case you can move the data folder to a newer unzipped version of VS Code.
On Windows and Linux, you can update VS Code by copying the data folder to a new version of VS Code.

### Subfolders

Make ***user-data*** and ***extensions*** subfolders within your ***data*** folder

#### TMP directory

By default, the default TMP directory is still the system one even in Portable Mode, since no state is kept there.
If you wish to also have your TMP directory within your portable directory, you can create an empty ***tmp*** directory inside the data folder.
As long as a ***tmp*** directory exists, it will be used for TMP data.

Folder structure sample on Windows:

```|- VSCode-win32-x64-1.25.0-insider
|   |- Code.exe (or code executable)
|   |- data
|   |   |- user-data
|   |   |   |- ...
|   |   |- extensions
|   |   |   |- ...
|   |   |- tmp
|   |- ...
```

> Note: .NET Framework 4.5.2 or higher is required for VS Code. If you are using Windows 7, make sure you have at least .NET Framework 4.5.2 installed. You can check your version of .NET Framework using this command, reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\full" /v version from a command prompt.

### Environment variables

1. Press ==Win+R==, type `cmd`
2. In terminal window type `rundll32.exe sysdm.cpl,EditEnvironmentVariables`
3. In User variables dubleclick Path, enter path for VSCode bin for instance: `\%USERPROFILE%\Desktop\Coding\Work\VSCode-win32-x64-1.42.1\bin`


# Uninstall in Windows

To uninstall Visual Studio Code - Delete %APPDATA%\Code and %USERPROFILE%\.vscode.

# Network

Visual Studio Code is built on top of Electron and benefits from all the networking stack capabilities of Chromium. This also means that VS Code users get much of the networking support available in Google Chrome

## Common hostnames

A handful of features within VS Code require network communication to work, such as the auto-update mechanism, querying and installing extensions, and telemetry. For these features to work properly in a proxy environment, you must have the product correctly configured.

If you are behind a firewall that needs to allow specific domains used by VS Code, here's the list of hostnames you should allow communication to go through:

    -update.code.visualstudio.com - Visual Studio Code download and update server
    -code.visualstudio.com - Visual Studio Code documentation
    -go.microsoft.com - Microsoft link forwarding service
    -vscode.blob.core.windows.net - Visual Studio Code blob storage, used for remote server
    -marketplace.visualstudio.com - Visual Studio Marketplace
    -*.gallery.vsassets.io - Visual Studio Marketplace
    -*.gallerycdn.vsassets.io - Visual Studio Marketplace
    -rink.hockeyapp.net - Crash reporting service
    -bingsettingssearch.trafficmanager.net - In-product settings search
    -vscode.search.windows.net - In-product settings search
    -raw.githubusercontent.com - GitHub repository raw file access
    -vsmarketplacebadge.apphb.com - Visual Studio Marketplace badge service
    -az764295.vo.msecnd.net - Visual Studio Code download CDN
    -download.visualstudio.microsoft.com - Visual Studio download server, provides dependencies for some VS Code extensions (C++, C#)
    -vscode-sync.trafficmanager.net - Visual Studio Code Settings Sync service
    -vscode-sync-insiders.trafficmanager.net - Visual Studio Code Settings Sync service (Insiders)
    -default.exp-tas.com - Visual Studio Code Experiment Service, used to provide experimental user experiences

## Proxy server support

VS Code has exactly the same proxy server support as Google Chromium. Here's a snippet from [Chromium's documentation] (<https://www.chromium.org/developers/design-documents/network-settings>)

# Command line extension management

When identifying an extension, provide the full name of the form **publisher.extension**, for example ms-python.python.

```code --extensions-dir <dir>
    Set the root path for extensions.
code --list-extensions
    List the installed extensions.
code --show-versions
    Show versions of installed extensions, when using --list-extension.
code --install-extension (<extension-id> | <extension-vsix-path>)
    Installs an extension.
code --uninstall-extension (<extension-id> | <extension-vsix-path>)
    Uninstalls an extension.
code --enable-proposed-api (<extension-id>)
    Enables proposed API features for extensions. Can receive one or more extension IDs to enable individually.
```

## C\C++ MinGW installation

### Prerequisites

1. Install Visual Studio Code.
2. [Install the C/C++ extension] (<https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools>.). Yoyu can search in the Extensions view ==press Ctrl+Shift+X==.
3. nstall Mingw-w64 via the SourceForge website. Click Mingw-w64 to begin downloading the compressed archive file. Extract the tools from the compressed file to a folder that has **no spaces** in its path.
4. Add the path to your Mingw-w64 ***bin*** folder to the Windows PATH environment variable:

  >In the Windows search bar, type 'settings' to open your Windows Settings.
  Search for Edit environment variables for your account.
  Choose the Path variable and then select Edit.
  Select New and add the Mingw-w64 path to the system path. The exact path depends on which version of Mingw-w64 you have installed and where you installed it. Here is an example: c:\mingw-w64\x86_64-8.1.0-win32-seh-rt_v6-rev0\mingw64\bin.
  Select OK to save the Path update. You will need to reopen any console windows for the new PATH location to be available.

### Check MinGW installation

Open comand prompt (press `Win+R`, run `cmd`) check that your Mingw-w64 tools are correctly installed and available, type:

```gcc --version
g++ --version
gdb --version
```

If you don't see the expected output or g++ or gdb is not a recognized command, check your installation (Windows Control Panel > Programs) and make sure your PATH entry matches the Mingw-w64 location.

## Git Portable installation

`gitmail.txt` file in source installation folder keeps e-mail for git settings (commit owner e-mail). It is better to put your GitHub.com "no reply public" e-mail here. GitHub security settings could be set to block your push with your private personal info i.e. your private e-mail.

