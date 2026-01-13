extends Node3D

var rigid_body_asset_ID : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rigid_body_asset_ID = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = Motive.get_rigid_body_pos(rigid_body_asset_ID)
	quaternion = Motive.get_rigid_body_rot(rigid_body_asset_ID)


func _enter_tree() -> void:
	pass
