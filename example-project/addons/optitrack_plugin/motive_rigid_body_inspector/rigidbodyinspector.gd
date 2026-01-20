extends EditorInspectorPlugin

var AssetIDEditor = preload("res://addons/optitrack_plugin/motive_rigid_body_inspector/asset_ID_editor.gd")
var AnimateEditor = preload("res://addons/optitrack_plugin/motive_rigid_body_inspector/animate_editor.gd")

func _can_handle(object: Object) -> bool:
	return true
	# handle all objects
	# eventually this could change to only handle MotiveRigidBody objects
	#if object.get_class() == "MotiveRigidBody":
		#return true
	#else:
		#return false


func _parse_property(object: Object, type: Variant.Type, name: String, hint_type: PropertyHint, hint_string: String, usage_flags: int, wide: bool) -> bool:
		# only replace property editor for rigid_body_asset_ID
		if name == "rigid_body_asset_ID":
			add_property_editor(name, AssetIDEditor.new(), false, "Rigid Body Asset ID")
			return true
		elif name == "animate_in_editor":
			add_property_editor(name, AnimateEditor.new(), false, "Animate in Editor")
			return true
		else:
			return false
