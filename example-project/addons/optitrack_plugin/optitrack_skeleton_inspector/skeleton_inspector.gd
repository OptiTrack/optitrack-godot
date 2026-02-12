extends EditorInspectorPlugin

var AssetIDEditor = preload("skeleton_asset_ID_editor.gd")
var update_bone_button : Button


#func _init() -> void:
	#print("init")
	#update_bone_button = Button.new()
	#update_bone_button.text = "Update Bones"


func _can_handle(object: Object) -> bool:
	return true


func _parse_property(object: Object, type: Variant.Type, name: String, hint_type: PropertyHint, hint_string: String, usage_flags: int, wide: bool) -> bool:
		# replace property editor for rigid_body_asset_ID
		if name == "skeleton_asset_ID":
			#print(object.get_property_list())
			add_property_editor(name, AssetIDEditor.new(), false, "Skeleton Asset ID")
			return true
		else:
			return false


func _parse_category(object: Object, category: String) -> void:
	if category == "optitrack_skeleton.gd":
		update_bone_button = Button.new()
		update_bone_button.text = "Update Bones"
		update_bone_button.pressed.connect(_on_update_bones_button_pressed)
		add_custom_control(update_bone_button)



func _on_update_bones_button_pressed() -> void:
	var skeleton = EditorInterface.get_inspector().get_edited_object()
	skeleton.update_bones()


#func _parse_group(object: Object, group: String) -> void:
	#if group == "Update Bone Button":
		#print("Update Bone Button group found")
		#if update_bone_button == null:
			#print("null")
		#add_custom_control(update_bone_button)
