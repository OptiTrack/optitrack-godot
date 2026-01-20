@tool
extends EditorPlugin

const AUTOLOAD_NAME = "MotiveAutoload"
const PLUGIN_FOLDER = "optitrack_plugin"

func _enable_plugin() -> void:
	# Add autoloads here.
	add_autoload_singleton(AUTOLOAD_NAME, "res://addons/optitrack_plugin/motive.gd")
	
	# Enable sub-plugins
	EditorInterface.set_plugin_enabled(PLUGIN_FOLDER + "/motive_control_panel", true)
	EditorInterface.set_plugin_enabled(PLUGIN_FOLDER + "/motive_rigid_body", true)
	EditorInterface.set_plugin_enabled(PLUGIN_FOLDER + "/motive_rigid_body_inspector", true)


func _disable_plugin() -> void:
	# Remove autoloads here.
	remove_autoload_singleton(AUTOLOAD_NAME)
	
	# Disable sub-plugins
	EditorInterface.set_plugin_enabled(PLUGIN_FOLDER + "/motive_control_panel", false)
	EditorInterface.set_plugin_enabled(PLUGIN_FOLDER + "/motive_rigid_body", false)
	EditorInterface.set_plugin_enabled(PLUGIN_FOLDER + "/motive_rigid_body_inspector", false)


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	pass


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	pass
