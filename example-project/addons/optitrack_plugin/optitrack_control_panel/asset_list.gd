@tool
extends ItemList

var rigid_body_assets : Dictionary
var skeleton_assets : Dictionary

func update_list() -> void:
	clear()
	
	if not OptiTrack.is_connected_to_motive():
		add_item("Could not retrieve asset list", null, false)
	else:
		var index = add_item("Rigid Body Assets", null, false)
		set_item_custom_bg_color(index, Color(0.212, 0.239, 0.29, 1.0))
		
		# get rigid body assets from Motive
		rigid_body_assets = OptiTrack.get_rigid_body_assets()
		
		# add each rigid body asset to list
		for id in rigid_body_assets:
			var item_str = rigid_body_assets[id]
			add_item(item_str, null, false)
		
		index = add_item("Skeleton Assets", null, false)
		set_item_custom_bg_color(index, Color(0.212, 0.239, 0.29, 1.0))
		
		# get skeleton assets from MotiveClient
		skeleton_assets = OptiTrack.get_skeleton_assets()
		
		# add each skeleton asset to list
		for id in skeleton_assets:
			var item_str = skeleton_assets[id]
			add_item(item_str, null, false)


# update list when refresh button is pressed
func _on_refresh_asset_list_button_pressed() -> void:
	update_list()


# update list when connect button pressed
func _on_connect_button_motive_connect() -> void:
	update_list()


# update list when disconnect button pressed
func _on_disconnect_button_motive_disconnect() -> void:
	update_list()
