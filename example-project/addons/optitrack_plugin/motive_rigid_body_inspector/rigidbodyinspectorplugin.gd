@tool
extends EditorPlugin

var plugin

func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	plugin = preload("res://addons/optitrack_plugin/motive_rigid_body_inspector/rigidbodyinspector.gd").new()
	add_inspector_plugin(plugin)


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	remove_inspector_plugin(plugin)






func _enable_plugin() -> void:
	# Add autoloads here.
	pass


func _disable_plugin() -> void:
	# Remove autoloads here.
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass 
	# Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
