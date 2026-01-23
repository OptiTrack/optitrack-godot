@tool
extends Button

var asset_dictionary : Dictionary
var asset_list : ItemList


func _pressed() -> void:
	asset_dictionary = OptiTrack.get_rigid_body_assets()
	asset_list = get_node("../AssetList")
	asset_list.clear()
	for id in asset_dictionary:
		var item_str = asset_dictionary[id]
		asset_list.add_item(item_str)
