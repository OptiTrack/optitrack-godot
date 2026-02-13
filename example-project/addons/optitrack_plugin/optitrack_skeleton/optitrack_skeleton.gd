@tool
extends Skeleton3D


@export var skeleton_asset_ID : int = -1
@export var animate_in_editor : bool = true



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		# in editor, check that the plugin is enabled and animate_in_editor is true
		if EditorInterface.is_plugin_enabled("optitrack_plugin") and animate_in_editor:
			if OptiTrack.is_connected_to_motive():
				update_pose()
	else:
		# if not in editor, check that the autoload is present
		if get_node_or_null("/root/OptiTrack") != null:
			update_pose()


func print_bone_tree(bones : Dictionary, root_index : int, depth : int):
	print(" ".repeat(depth) + get_bone_name(root_index))
	
	for index in range(get_bone_count()):
		if get_bone_parent(index) == root_index:
			print_bone_tree(bones, index, depth + 1)



func update_pose() -> void:
	if get_bone_count() == 0 or not OptiTrack.is_connected_to_motive():
		return
	
	var bone_data = OptiTrack.get_skeleton_bone_data(skeleton_asset_ID)
	
	for bone in bone_data:
		var bone_index = find_bone(bone)
		
		set_bone_pose_position(bone_index, bone_data[bone].get(2))
		set_bone_pose_rotation(bone_index, bone_data[bone].get(3))



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
		
		#var parent_index = bones[bone].get(0) - 1
		set_bone_parent(bone_index, parent_index)
		#print("bone parent: %d" % parent_index)
		set_bone_pose_position(bone_index, bone_position)
		set_bone_pose_rotation(bone_index, bone_rotation)
