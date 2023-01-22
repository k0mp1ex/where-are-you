# Where Are You?

Skyrim mod to lookup NPCs in game.
Access the [modpage](https://www.nexusmods.com/skyrimspecialedition/mods/76063) for the full description.

## Project Requirements

- [Visual Studio 2022](https://visualstudio.microsoft.com/) (_the free Community edition is fine!_)
- [`vcpkg`](https://github.com/microsoft/vcpkg)
  - 1. Clone the repository using git OR [download it as a .zip](https://github.com/microsoft/vcpkg/archive/refs/heads/master.zip)
  - 2. Go into the `vcpkg` folder and double-click on `bootstrap-vcpkg.bat`
  - 3. Edit your system or user Environment Variables and add a new one:
    - Name: `VCPKG_ROOT`  
      Value: `C:\path\to\wherever\your\vcpkg\folder\is`

Once you have Visual Studio 2022 installed, you can open this folder in basically any C++ editor, e.g. [VS Code](https://code.visualstudio.com/) or [CLion](https://www.jetbrains.com/clion/) or [Visual Studio](https://visualstudio.microsoft.com/)
- > _for VS Code, if you are not automatically prompted to install the [C++](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools) and [CMake Tools](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cmake-tools) extensions, please install those and then close VS Code and then open this project as a folder in VS Code_

You may need to click `OK` on a few windows, but the project should automatically run CMake!

It will _automatically_ download [CommonLibSSE NG](https://github.com/CharmedBaryon/CommonLibSSE-NG) and everything you need to get started making your new plugin!

## Project Structure

By default, when this project compiles it will output a `.dll` for your SKSE plugin into the `build/` folder.

But you probably want to put the `.dll` into your Skyrim mods folder, e.g. the mods folder used by Mod Organizer 2 or Vortex.

You can configure this project to _automatically_ output the SKSE plugin `.dll` into:
- `<your mods folder>\<name you give this project>\SKSE\Plugins\<your mod>.dll`  
  if you set the `SKYRIM_MODS_FOLDER` environment variable to the **root of your mods folder** (i.e. `<your mods folder>`)

- **Example:**
    - Name: `SKYRIM_MODS_FOLDER`  
      Value: `C:\path\to\wherever\your\Skyrim\mods\are`

Thanks [mrowrpr](https://github.com/mrowrpurr) for the lovely [template](https://github.com/SkyrimScripting/SKSE_Template_HelloWorld).

> 📜 other templates available at https://github.com/SkyrimScripting/SKSE_Templates

**PLEASE DO NOT RELEASE YOUR SKSE PLUGIN ON NEXUS/ETC WITHOUT MAKING THE SOURCE CODE AVAILABLE**
