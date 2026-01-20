@tool
extends Node3D

@export var rigid_body_asset_ID : int = 0
@export var animate_in_editor : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not Engine.is_editor_hint() or animate_in_editor:
		position = MotiveAutoload.get_rigid_body_pos(rigid_body_asset_ID)
		quaternion = MotiveAutoload.get_rigid_body_rot(rigid_body_asset_ID)
