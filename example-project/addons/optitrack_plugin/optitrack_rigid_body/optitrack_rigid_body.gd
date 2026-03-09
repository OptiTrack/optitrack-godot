@tool
extends Node3D

## ID corresponding to the Motive asset that this rigid body will track. 
## Defaults to "Unassigned". 
@export var rigid_body_asset_ID : int = 999
## When on, the rigid body will be animated in the Godot editor's 3D workspace.
## This setting only affects in-editor behavior. The rigid body will animate 
## when the scene is played whether this setting is on or off.
@export var animate_in_editor : bool = true

@export_group("Offset")
## Defines a translational transformation. The coordinates provided to this 
## property will correspond to the origin (0, 0, 0) in Motive's data.
@export var position_offset : Vector3 = Vector3.ZERO
## Defines a rotational transformation. The quaternion provided will rotate the
## data around the position offset coordinate.
@export var rotation_offset : Quaternion = Quaternion.IDENTITY
@export_group("")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		# in editor, don't animate if any of these conditions are false
		if animate_in_editor == false \
		or EditorInterface.is_plugin_enabled("optitrack_plugin") == false \
		or OptiTrack.is_connected_to_motive() == false:
			return
	else:
		# if not in editor, don't animate if the autoload is not present
		if get_node_or_null("/root/OptiTrack") == null:
			return
	
	# animate
	var new_pos = OptiTrack.get_rigid_body_pos(rigid_body_asset_ID) 
	new_pos = rotation_offset * new_pos
	position = new_pos + position_offset
	
	var new_rot = OptiTrack.get_rigid_body_rot(rigid_body_asset_ID) 
	new_rot  = rotation_offset * new_rot
	quaternion = new_rot
