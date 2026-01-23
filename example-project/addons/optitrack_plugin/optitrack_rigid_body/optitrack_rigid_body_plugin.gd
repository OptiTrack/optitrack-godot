@tool
extends EditorPlugin


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	# Add the new type with a name, a parent type, a script and an icon.
	add_custom_type("OptiTrackRigidBody", "Node3D", preload("optitrack_rigid_body.gd"), preload("motive-icon.png"))


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	remove_custom_type("OptiTrackRigidBody")


func _enable_plugin() -> void:
	# Add autoloads here.
	pass


func _disable_plugin() -> void:
	# Remove autoloads here.
	pass
