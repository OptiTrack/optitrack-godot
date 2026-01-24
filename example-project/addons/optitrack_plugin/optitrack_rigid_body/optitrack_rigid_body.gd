@tool
extends Node3D

@export var rigid_body_asset_ID : int = 0
@export var animate_in_editor : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		# in editor, check that the plugin is enabled and animate_in_editor is true
		if EditorInterface.is_plugin_enabled("optitrack_plugin") and animate_in_editor:
			position = OptiTrack.get_rigid_body_pos(rigid_body_asset_ID)
			quaternion = OptiTrack.get_rigid_body_rot(rigid_body_asset_ID)
	else:
		# if not in editor, check that the autoload is present
		if get_node_or_null("/root/OptiTrack") != null:
			position = OptiTrack.get_rigid_body_pos(rigid_body_asset_ID)
			quaternion = OptiTrack.get_rigid_body_rot(rigid_body_asset_ID)
