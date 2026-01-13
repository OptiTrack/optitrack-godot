@tool
extends EditorPlugin

const AUTOLOAD_NAME = "Motive"
const PLUGIN_FOLDER = "optitrack_plugin"

func _enable_plugin() -> void:
	# Add autoloads here.
	# motive_client.tscn is a scene with just a MotiveClient as its root node
	add_autoload_singleton(AUTOLOAD_NAME, "res://addons/optitrack_plugin/motive_client.tscn")
	
	# Enable sub-plugins
	EditorInterface.set_plugin_enabled(PLUGIN_FOLDER + "/motive_control_panel", true)
	EditorInterface.set_plugin_enabled(PLUGIN_FOLDER + "/motive_rigid_body", true)


func _disable_plugin() -> void:
	# Remove autoloads here.
	remove_autoload_singleton(AUTOLOAD_NAME)
	
	# Disable sub-plugins
	EditorInterface.set_plugin_enabled(PLUGIN_FOLDER + "/motive_control_panel", false)
	EditorInterface.set_plugin_enabled(PLUGIN_FOLDER + "/motive_rigid_body", false)


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	pass


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	pass
