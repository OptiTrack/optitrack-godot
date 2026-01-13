@tool
extends EditorPlugin


func _enable_plugin() -> void:
	# Add autoloads here.
	pass


func _disable_plugin() -> void:
	# Remove autoloads here.
	pass


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	# Add the new type with a name, a parent type, a script and an icon.
	add_custom_type("MotiveRigidBody", "Node3D", preload("res://addons/optitrack_plugin/motive_rigid_body/motiverigidbody.gd"), preload("res://addons/optitrack_plugin/motive_rigid_body/motive-icon.png"))


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	remove_custom_type("MotiveRigidBody")
