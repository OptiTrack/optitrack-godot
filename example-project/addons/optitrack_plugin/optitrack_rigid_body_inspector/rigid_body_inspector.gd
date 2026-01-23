extends EditorInspectorPlugin

var AssetIDEditor = preload("asset_ID_editor.gd")

func _can_handle(object: Object) -> bool:
	return true


func _parse_property(object: Object, type: Variant.Type, name: String, hint_type: PropertyHint, hint_string: String, usage_flags: int, wide: bool) -> bool:
		# replace property editor for rigid_body_asset_ID
		if name == "rigid_body_asset_ID":
			add_property_editor(name, AssetIDEditor.new(), false, "Rigid Body Asset ID")
			return true
		else:
			return false
