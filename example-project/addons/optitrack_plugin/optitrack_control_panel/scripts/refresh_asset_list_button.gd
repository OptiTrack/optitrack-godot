@tool
extends Button

var asset_dictionary : Dictionary
var asset_list : ItemList


func _pressed() -> void:
	# get rigid body assets from MotiveClient
	asset_dictionary = OptiTrack.get_rigid_body_assets()
	
	# clear asset list in OptiTrack control panel
	asset_list = get_node("../AssetList")
	asset_list.clear()
	
	# add each rigid body asset to list in OptiTrack control panel
	for id in asset_dictionary:
		var item_str = asset_dictionary[id]
		asset_list.add_item(item_str)
