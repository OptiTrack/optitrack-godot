@tool
extends Skeleton3D

## ID corresponding to the Motive asset that this skeleton will track.
## Defaults to "Unassigned". 
@export var skeleton_asset_ID : int = 999
## When on, the skeleton will be animated in the Godot editor's 3D workspace.
## This setting only affects in-editor behavior. The skeleton will animate 
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
		# if not in editor, check that the autoload is present
		if get_node_or_null("/root/OptiTrack") == null:
			return
	
	update_pose()



func update_pose() -> void:
	if get_bone_count() == 0 or not OptiTrack.is_connected_to_motive():
		return
	
	var bone_data = OptiTrack.get_skeleton_bone_data(skeleton_asset_ID)
	
	for bone in bone_data:
		var bone_index = find_bone(bone)
		
		var bone_position = bone_data[bone].get(2)
		var bone_rotation = bone_data[bone].get(3)
		
		# modify position/rotation of root bone by offset
		if get_bone_parent(bone_index) == -1:
			bone_position = rotation_offset * bone_position
			bone_position = bone_position + position_offset
			bone_rotation = rotation_offset * bone_rotation
		
		set_bone_pose_position(bone_index, bone_position)
		set_bone_pose_rotation(bone_index, bone_rotation)



func update_bones() -> void:
	clear_bones()
	
	if OptiTrack.is_connected_to_motive() == false:
		return
	
	var bones = OptiTrack.get_skeleton_bone_data(skeleton_asset_ID)
	
	if bones.is_empty():
		# unable to retrieve skeleton description/data
		return
	
	# loops through all bones in the Dictionary
	# bone is a string containing the name of the bone
	# bones[bone] is an array containing
	# 0. the bone's id (int)
	# 1. the bone's parent's id (int)
	# 2. the bone's position (Vector3D)
	# 3. the bone's rotation (Quaternion)
	
	for bone_name in bones:
		# parse bone data
		var bone_id = bones[bone_name].get(0)
		var parent_id = bones[bone_name].get(1)
		var bone_position = bones[bone_name].get(2)
		var bone_rotation = bones[bone_name].get(3)
		
		# add bone to skeleton
		var bone_index = add_bone(bone_name)
		
		# set bone parent
		# need bone index of bone that matches the parent's bone ID (bones[bone].get(0))
		var parent_index = -1
		for i in range(bone_index):
			if bones[get_bone_name(i)].get(0) == parent_id:
				parent_index = i
		
		set_bone_parent(bone_index, parent_index)
		set_bone_pose_position(bone_index, bone_position)
		set_bone_pose_rotation(bone_index, bone_rotation)


## Prints the bone hierarchy to the console. Useful for debugging.
func print_bone_tree(bones : Dictionary, root_index : int, depth : int):
	print(" ".repeat(depth) + get_bone_name(root_index))
	
	for index in range(get_bone_count()):
		if get_bone_parent(index) == root_index:
			print_bone_tree(bones, index, depth + 1)
