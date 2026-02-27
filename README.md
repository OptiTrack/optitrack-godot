# OptiTrack Plugin for Godot

This plugin provides support for streaming rigid body and skeleton data to the Godot game engine in real time from Motive, OptiTrack's motion capture software.

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

After configuring the settings, you can start a connection by pressing the **Start Connection** button in the **Connection** section of the panel. When connected the connection indicator icon at the top of the connection section will turn green. The **Asset List** will show the rigid bodies and skeletons that are being streamed from Motive. The list will update automatically when connecting or disconnecting from Motive, but you can also use the **Refresh Asset List** button to update the list if it might have changed since connecting.

You can stop the connection at any time by pressing the **Stop Connection** button. Note that changing connection settings while connected will cause a disconnection. Reconnect with the new settings by pressing the **Start Connection** button. The **Motive Timeline Play** and **Motive Timeline Pause** buttons can be used to control the playback of a pre-recorded take in Motive.

Lastly, the **Info** section provides a link to OptiTrack's documentation website and version information.

### Animate a Rigid Body

To animate a rigid body in Godot, add an OptiTrackRigidBody node into the scene tree, for example, by pressing the **+** button in the top right of the **Scene** dock. Find the OptiTrackRigidBody node type under Node3D or by searching, and then click **Create**. Add the node or scene that you want to be animated to scene tree as a child of the OptiTrackRigidBody node.

Select the OptiTrackRigidBody node in the scene tree. In the **Inspector** tab on the right side of the editor, there are two properties you can edit. 
1. **Rigid Body Asset ID:** The dropdown menu will show the rigid body assets that are being streamed from Motive. This property defaults to "Unassigned", which means the skeleton is not associated with an asset and will not animate. If no assests are listed, make sure that you have started a connection with Motive through the OptiTrack dock then press the **Refresh Asset List** button. If the selected asset says "Unlisted", the skeleton has been assigned to an asset, but that asset is not currently being streamed from Motive.
2. **Animate in Editor:** Checking this box will cause the rigid body to animate in the editor in the 3D workspace. When the box is not checked, the rigid body will not be animated in the editor, but will still animate when the scene is played.

Once you have assigned a rigid body asset to the OptiTrackRigidBody Node (#1 above) you can play the scene and the rigid body will be animated to match that rigid body. 

If the OptiTrackRigidBody does not animate:
1. Double check your connection settings. Make sure they match the streaming settings in Motive. If you are animating in the editor, restart the connection after changing the settings. If playing a scene, restart the scene after adjusting the settings.
2. If using pre-recorded data, check that Motive is playing the take.

### Animate a Skeleton

This plugin provides several 3D models to get skeletons animating as fast as possible. You can also import your own 3D models and animate them using this plugin with a few extra steps.

#### Using the Provided 3D Models

1. In the **FileSystem** dock navigate to the `res://addons/optitrack-plugin/models` directory. 
2. Find the packed scene (.tscn file) corresponding to the structure of the skeleton you want to animate. Motive streams skeletons with either three or seven spine bones, and the plugin provides a male and female model for each of these options. For example, choose `MotiveAvatarMale3.tscn` for a male model with three spine bones.
3. Instantiate the scene by clicking and dragging it into the **Scene Tree**.
4. Select the OptiTrackSkeleton scene. In the **Inspector**, assign an asset to the skeleton by selecting one from the **Skeleton Asset ID** dropdown menu. If no assets are listed, check that you are connected to Motive (see Configure the Connection with Motive section above) and click the **Refresh Asset List** button.

The 3D model should animate according to the data streamed from Motive.

#### Importing a 3D Model

1. Add your 3D model (e.g., .fbx file) into your project folder so that it appears in the **FileSystem**.
2. Double click the 3D model file in the **FileSystem** to open the Advanced Import Menu.
3. In the scene tree on the left side of the window, select the Skeleton3D node. In the inspector panel on the right side of the window click the **BoneMap** property under the **Retargeting** section.
4. Click the arrow on the right side of the **Profile** property.  Select **Load**, navigate to the `res://addons/optitrack-plugin/` folder and select the SkeletonProfile corresponding to the structure of the skeleton you want to animate: `SkeletonProfile3.tres` for a three spine bone skeleton or `SkeletonProfile7.tres` for a seven spine bone skeleton.
5. Select each bone in the bone map and use the bone picker tool (the icon to the right of the bone name) to assign a bone from your imported model to a bone in the skeleton profile. If you are animating hand bones, be sure to assign bones for each hand bone by switching to the LeftHand and RightHand groups as well.
6. Once all bones have been assigned, click the **Reimport** button at the bottom of the window.
7. Add the model into the scene tree by clicking and dragging it from the **FileSystem** dock into the scene tree.
8. Right click the node it creates and select **Make Local**. This should expand the node into a hierarchy of three nodes: a container Node3D, a Skeleton3D node and a MeshInstance3D node.
9. Add an OptiTrackSkeleton node into the scene tree.
10. Add a RetargetModifier3D node as a child of the OptiTrackSkeleton node. In the **Inspector**, set the **Profile** to the same profile you used in step 4 and check the box labeled **Use Global Pose**.
11. Reparent the Skeleton3D node from the imported model as a child of the RetargetModifier3D node. Keep the 3D mesh node as a child of the Skeleton3D node. The Skeleton3D's previous parent can be deleted.

The OptiTrackSkeleton node's children should look similar to this:
```
OptiTrackSkeleton
┖╴RetargetModifier3D
  ┖╴Skeleton3D
    ┖╴MeshInstance3D
```

The mesh model should move to the skeleton, and it will animate with the data streamed from Motive.

## Other Features

### Offset
Both the OptiTrackRigidBody and OptiTrackSkeleton nodes have a section in the **Inspector** labeled **Offset**.  These provide controls over where in the Godot game space the nodes animate.

**Position Offset** defines a translational transformation. The coordinates provided to this property will correspond to the origin (0, 0, 0) in Motive's data.

**Rotation Offset** defines a rotational transformation. The quaternion provided will rotate the data around the position offset coordinate. Note that clicking the pencil icon to the right of the x, y, z, and w values allows you to set the rotation with Euler angles (pitch, yaw, and roll).

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
4. The OptiTrackRigidBody custom node. This sub-plugin registers a new type of Node with the Godot editor. When connected to Motive, the OptiTrackRigidBody can be animated with real-time rigid body data streaming from Motive. This custom node is written in GDScript and its files can be found in the `example-project/addons/optitrack_plugin/optitrack_rigid_body/` folder.
5. The OptiTrackRigidBody custom inspector sub-plugin. This sub-plugin defines custom behavior for the OptiTrackRigidBody in Godot's inspector. It is written in GDScript and it can be found in the `example-project/addons/optitrack_plugin/optitrack_rigid_body_inspector/` directory.
6. The OptiTrackSkeleton custom node. This sub-plugin registers a new type of Node with the Godot editor. When connected to Motive, the OptiTrackSkelton can be animated with real-time skeleton data streaming from Motive. This custom node is written in GDScript and its files can be found in the `example-project/addons/optitrack_plugin/optitrack_skeleton/` folder.
7. The OptiTrackSkeleton custom inspector plugin. This sub-plugin defines custom behavior for the OptiTrackSkeleton in Godot's inspector. It is written in GDScript and it can be found in the `example-project/addons/optitrack_plugin/optitrack_skeleton_inspector/` directory.

The `include/` and `lib/` directories are for external libraries, i.e., the headers and binaries from the NatNet SDK. The compiled binaries are copied into the `example-project/addons/optitrack_plugin/bin/` directory and must be present in a project's `/addons/optitrack_plugin/bin/` folder for the plugin to work.

The `example-project/addons/optitrack_plugin/models/` directory contains 3D models for use with the OptiTrackSkeleton. It provides ready-to-use packed scenes as well as the original FBX files for the 3D models used in the scenes.

The `godot-cpp/` is a submodule that contains all the code for Godot. It is necessary for compiling the GDExtension code (see the [GDExtension C++ tutorial](https://docs.godotengine.org/en/stable/tutorials/scripting/cpp/gdextension_cpp_example.html)).

### Resources

Godot has a lot of helpful documentation and tutorials for developing plugins. The following pages are especially useful for working on this plugin:
- [GDExtention C++](https://docs.godotengine.org/en/stable/tutorials/scripting/cpp/gdextension_cpp_example.html)
- [Making Plugins](https://docs.godotengine.org/en/stable/tutorials/plugins/editor/making_plugins.html)
- [Inspector Plugins](https://docs.godotengine.org/en/stable/tutorials/plugins/editor/inspector_plugins.html)
- [GDScript Reference](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html)

## Legal

Copyright (c) 2025 NaturalPoint Inc. DBA OptiTrack. All Rights Reserved.
