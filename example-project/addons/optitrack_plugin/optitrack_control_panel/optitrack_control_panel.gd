@tool
extends EditorPlugin

var dock


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	dock = preload("optitrack_control_panel.tscn").instantiate()
	# Add control panel next to FileSystem dock
	add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_BR, dock)


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	remove_control_from_docks(dock)
	dock.free()


# Nothing to do in _enable_plugin() or _disable_plugin()
# func _enable_plugin() -> void:
# func _disable_plugin() -> void:
