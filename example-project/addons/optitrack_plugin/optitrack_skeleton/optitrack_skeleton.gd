@tool
extends Skeleton3D


@export var skeleton_asset_ID : int = 0
@export var animate_in_editor : bool = false
#@export_group("Update Bone Button")
#@export var placeholder : int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		# in editor, check that the plugin is enabled and animate_in_editor is true
		if EditorInterface.is_plugin_enabled("optitrack_plugin") and animate_in_editor:
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
	
	# using bones dictionary
	#for bone in bones:
		#var parent_index = bones[bone].get(0) - 1
		#if parent_index == root_index:
			#print_bone_tree(bones, bones[bone].get(3), depth + 1)


func update_pose() -> void:
	if get_bone_count() == 0:
		return
	
	var bone_data = OptiTrack.get_skeleton_bone_data(skeleton_asset_ID)
	
	for bone in bone_data:
		var bone_index = find_bone(bone)
		
		set_bone_pose_position(bone_index, bone_data[bone].get(1))
		set_bone_pose_rotation(bone_index, bone_data[bone].get(2))



func update_bones() -> void:
	if OptiTrack.is_connected_to_motive() == false:
		return
	
	var skel_assets = OptiTrack.get_skeleton_assets()
	#print(skel_assets)
	var bones = OptiTrack.get_skeleton_bone_data(0)
	#print(bones)
	
	if bones.is_empty():
		# unable to retrieve skeleton description/data
		return
	
	clear_bones()
	
	# loops through all bones in the Dictionary
	# bone is a string containing the name of the bone
	# bones[bone] is an array containing
	# 0. the bone's parent's index (int)
	# 1. the bone's position (Vector3D)
	# 2. the bone's rotation (Quaternion)
	for bone in bones:
		var bone_index = add_bone(bone)
		# add bone index to end of bone data array
		bones[bone].append(bone_index)
		#print("bone name:   %s" % bone)
		#print("bone index:  %d" % bone_index)
		
		var parent_index = bones[bone].get(0) - 1
		set_bone_parent(bone_index, parent_index)
		#print("bone parent: %d" % parent_index)
		set_bone_pose_position(bone_index, bones[bone].get(1))
		set_bone_pose_rotation(bone_index, bones[bone].get(2))
	
	#print_bone_tree(bones, 0, 0)
