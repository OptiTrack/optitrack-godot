@tool
extends EditorPlugin

var dock


func _enable_plugin() -> void:
	# Add autoloads here.
	pass


func _disable_plugin() -> void:
	# Remove autoloads here.
	pass


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	dock = preload("motive-control-panel.tscn").instantiate()
	add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_UR, dock)


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	remove_control_from_docks(dock)
	dock.free()
