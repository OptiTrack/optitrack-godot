@tool
extends ItemList

var asset_dictionary : Dictionary


func update_list() -> void:
	clear()
	
	# get rigid body assets from MotiveClient
	asset_dictionary = OptiTrack.get_skeleton_assets()
	asset_dictionary.merge(OptiTrack.get_rigid_body_assets())
	
	# add each rigid body asset to list
	for id in asset_dictionary:
		var item_str = asset_dictionary[id]
		add_item(item_str)


# update list when refresh button is pressed
func _on_refresh_asset_list_button_pressed() -> void:
	update_list()


# update list when connect button pressed
func _on_connect_button_motive_connect() -> void:
	update_list()


# update list when disconnect button pressed
func _on_disconnect_button_motive_disconnect() -> void:
	update_list()
