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

env.Append(CPPPATH=["src/", "include/"])
sources = Glob("src/*.cpp")

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

library = env.SharedLibrary(
    "bin/OptiTrack Plugin/{}/{}".format(env['platform'], lib_filename),
    source=sources,
)


# copy .dll files etc. into addons/ folder
copy = env.Install("{}/addons/OptiTrack Plugin/{}/".format(projectdir, env["platform"]), library)

default_args = [library, copy]
Default(*default_args)
