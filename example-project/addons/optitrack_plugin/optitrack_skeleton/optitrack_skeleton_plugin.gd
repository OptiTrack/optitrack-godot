@tool
extends EditorPlugin


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	# Add the new type with a name, a parent type, a script and an icon.
	add_custom_type("OptiTrackSkeleton", "Skeleton3D", preload("optitrack_skeleton.gd"), preload("motive-icon.png"))


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	remove_custom_type("OptiTrackSkeleton")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
