#!/usr/bin/env python
import os
import sys

from methods import print_error


libname = "OptiTrack-plugin"
projectdir = "example-project"

localEnv = Environment(tools=["default"], PLATFORM="")


customs = ["custom.py"]
customs = [os.path.abspath(path) for path in customs]

opts = Variables(customs, ARGUMENTS)
opts.Update(localEnv)

Help(opts.GenerateHelpText(localEnv))

env = localEnv.Clone()

if not (os.path.isdir("godot-cpp") and os.listdir("godot-cpp")):
    print_error("""godot-cpp is not available within this folder, as Git submodules haven't been initialized.
Run the following command to download godot-cpp:

    git submodule update --init --recursive""")
    sys.exit(1)

env = SConscript("godot-cpp/SConstruct", {"env": env, "customs": customs})

env.Append(CPPPATH=["src/"])
sources = Glob("src/*.cpp")

# Both platforms share a single set of NatNet headers in include/. These are the
# NatNet 4.5 headers, which are an append-only superset of the 4.4 headers: all
# structs the plugin uses keep the same field offsets, and the 4.5 additions
# (IMU/GPIO/Anchor) only append members. That makes them binary-compatible with
# the Windows 4.4 runtime while still matching the shipped Linux 4.5 libNatNet.so.
env.Append(CPPPATH=["include/"])

# The NatNet SDK ships a different runtime binary per platform, so select the
# matching link library based on the target platform.
if env["platform"] == "linux":
    # Ubuntu NatNet SDK (libNatNet.so).
    env.Append(LIBS=["NatNet"])
    env.Append(LIBPATH=["lib/NatNet/"])
    # Let the loader find libNatNet.so sitting next to the plugin (addons/.../bin/)
    # at runtime without requiring the user to set LD_LIBRARY_PATH.
    env.Append(LINKFLAGS=["-Wl,-rpath,'$$ORIGIN'"])
else:
    # Windows NatNet SDK (NatNetLib.dll / NatNetLib.lib).
    env.Append(LIBS=["NatNetLib"])
    env.Append(LIBPATH=["lib/NatNet/"])

if env["target"] in ["editor", "template_debug"]:
    try:
        doc_data = env.GodotCPPDocData("src/gen/doc_data.gen.cpp", source=Glob("doc_classes/*.xml"))
        sources.append(doc_data)
    except AttributeError:
        print("Not including class reference as we're targeting a pre-4.3 baseline.")

# .dev doesn't inhibit compatibility, so we don't need to key it.
# .universal just means "compatible with all relevant arches" so we don't need to key it.
suffix = env['suffix'].replace(".dev", "").replace(".universal", "")

lib_filename = "{}{}{}{}".format(env.subst('$SHLIBPREFIX'), libname, suffix, env.subst('$SHLIBSUFFIX'))

# put compiled binaries in bin/
library = env.SharedLibrary(
    "bin/{}".format(lib_filename),
    source=sources,
)


# copy the compiled plugin binary into the addons/ folder
addons_bin = "{}/addons/optitrack_plugin/{}/".format(projectdir, "bin")
copy = env.Install(addons_bin, library)

default_args = [library, copy]

# On Linux, also stage the NatNet runtime library (libNatNet.so) alongside the
# plugin so the shipped addon is self-contained. On Windows the equivalent
# NatNetLib.dll is already present in the addons bin/ folder.
if env["platform"] == "linux":
    copy_natnet = env.Install(addons_bin, "lib/NatNet/libNatNet.so")
    default_args.append(copy_natnet)

Default(*default_args)
