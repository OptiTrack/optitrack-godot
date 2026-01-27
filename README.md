# OptiTrack Plugin for Godot

This plugin provides support for streaming rigid body data to the Godot game engine in real time from Motive, OptiTrack's motion capture software.

## How to install the Plugin

In order to the install the Plugin:

1. Download the latest version of Godot.
2. Create a Godot project. In the root directory of the project create an `addons/` folder.
3. Download the OptiTrack Plugin from GitHub. Follow the link to the latest release under the "Releases" section of the right sidebar. From the list of assets download the `optitrack_plugin.zip` archive.
4. Extract the zip archive and copy it into the `addons/` folder of your Godot project.
5. When you add these files into your project the Godot editor will report errors as it parses the files. This is because the plugin has not yet been enabled.
6. Open the project's settings by selecting **Project** > **Project Settings** from the main menu.  Switch to the **Plugins** tab. The OptiTrack plugin should be listed under **Installed Plugins**. Enable it by checking the box to the left of its name.
7. Reload the project by selecting **Project** > **Reload Current Project** from the menu.

## How to Use the Plugin

### Configure the Connection with Motive

With the plugin installed, the OptiTrack control dock is located in the lower right of the Godot editor, next to the **FileSystems** dock. The **Settings** section allows you to configure the connection settings. In the **Server IP** field put the IP address of the computer on which Motive is running. In the **Client IP** field put the IP address of the machine running Godot. Finally, make sure that the **Multicast** setting matches the **Transmission Type** in Motive's streaming settings (checked for multicast, unchecked for unicast).

After configuring the settings, you can start a connection by pressing the **Start Connection** button in the **Connection** section of the panel. When connected the connection indicator icon at the top of the connection section will turn green. Use the **Refresh Asset List** button to get a list of the rigid body assets that Motive is streaming.

You can stop the connection at any time by pressing the **Stop Connection** button. Note that changing connection settings while connected will cause a disconnection. Reconnect with the new settings by pressing the **Start Connection** button. The **Motive Timeline Play** and **Motive Timeline Pause** buttons can be used to control the playback of a pre-recorded take in Motive.

Lastly, the **Info** section provides a link to OptiTrack's documentation website and version information.

### Animate a Rigid Body

To animate a rigid body in Godot, add an OptiTrackRigidBody node into the scene tree, for example, by pressing the **+** button in the top right of the **Scene** dock. Find the OptiTrackRigidBody node type under Node3D or by searching, and then click **Create**. Add the node or scene that you want to be animated to scene tree as a child of the OptiTrackRigidBody node.

Select the OptiTrackRigidBody node in the scene tree. In the **Inspector** tab on the right side of the editor, there are two properties you can edit. 
1. **Rigid Body Asset ID:** The dropdown menu will show the rigid body assets that are being streamed from Motive. If it says "Check Motive connection" instead, make sure that you have started a connection with Motive through the OptiTrack dock then press the **Refresh Asset List** button.
2. **Animate in Editor:** Checking this box will cause the rigid body to animate in the editor in the 3D workspace. When the box is not checked, the rigid body will not be animated in the editor, but will still animate when the scene is played.

Once you have assigned a rigid body asset to the OptiTrackRigidBody Node (#1 above) you can play the scene and the rigid body will be animated to match that rigid body. 

If the OptiTrackRigidBody does not animate:
1. Double check your connection settings. Make sure they match the streaming settings in Motive. If you are animating in the editor, restart the connection after changing the settings. If playing a scene, restart the scene after adjusting the settings.
2. If using pre-recorded data, check that Motive is playing the take.

## How to Start Developing

To start developing this plugin:

1. Download the latest version of Godot.
2. Obtain a copy of the source code from this repository (see GitHub's guide to [cloning a repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository) for help).
3. If you intend to edit the the C++ source code of the plugin, you will need a C++ compiler and SCons, a Python-based build tool (for instructions for installing Scons refer to the [Scons GitHub repository](https://github.com/SCons/scons?tab=readme-ov-file#installation))

### Project Organization

The OptiTrack plugin has several parts to it:

1. The MotiveClient class. This class is written in C++ using [GDExtension](https://docs.godotengine.org/en/stable/tutorials/scripting/cpp/gdextension_cpp_example.html). It handles the connection to Motive using OptiTrack's [NatNet SDK](https://optitrack.com/software/natnet-sdk). The code for this class is located in the `src/` directory.
2. The main OptiTrack plugin. This plugin autoloads an instance of the MotiveClient class into the project and automatically enables the other sub-plugins. It is written in GDScript and its files are located in the `example-project/addons/optitrack_plugin/` folder.
3. The OptiTrack Control Panel. This sub-plugin adds a dock to the Godot editor that configures and controls the connection to Motive. The plugin is written in GDScript and its files are located in the `example-project/addons/optitrack_plugin/optitrack_control_panel/` directory.
4. The OptiTrackRigidBody custom node. This sub-plugin registers a new type of Node with the Godot editor. When connected to Motive, the OptiTrackRigidBody can be animated with real-time rigid body data streaming from Motive. This custom node is writted in GDScript and its files can be found in the `example-project/addons/optitrack_plugin/optitrack_rigid_body/` folder.
5. The OptiTrackRigidBody custom inspector sub-plugin. This sub-plugin defines custom behavior for the OptiTrackRigidBody in Godot's inspector. It is writted in GDScript and it can be found in the `example-project/addons/optitrack_plugin/optitrack_rigid_body_inspector/` directory.

The `include/` and `lib/` directories are for external libraries, i.e., the headers and binaries from the NatNet SDK.

The `godot-cpp/` is a submodule that contains all the code for Godot. It is necessary for compiling the GDExtension code (see the [GDExtension C++ tutorial](https://docs.godotengine.org/en/stable/tutorials/scripting/cpp/gdextension_cpp_example.html)).

### Resources

Godot has a lot of helpful documentation and tutorials for developing plugins. The following pages are especially useful for working on this plugin:
- [GDExtention C++](https://docs.godotengine.org/en/stable/tutorials/scripting/cpp/gdextension_cpp_example.html)
- [Making Plugins](https://docs.godotengine.org/en/stable/tutorials/plugins/editor/making_plugins.html)
- [Inspector Plugins](https://docs.godotengine.org/en/stable/tutorials/plugins/editor/inspector_plugins.html)
- [GDScript Reference](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html)

## Legal

Copyright (c) 2025 NaturalPoint Inc. DBA OptiTrack. All Rights Reserved.
