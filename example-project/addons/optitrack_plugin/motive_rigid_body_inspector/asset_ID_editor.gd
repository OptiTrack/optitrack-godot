extends EditorProperty


# the OptionButton to be added to the inspector
var container = VBoxContainer.new()
var property_control = OptionButton.new()
var refresh_button = Button.new()

# internal variable for current value
var current_value = 0
# guard against internal changes while value is updating
var updating = false


func _init() -> void:
	# set up dropdown menu and refresh button
	refresh_asset_list()
	refresh_button.text = "Refresh Asset List"
	refresh_button.pressed.connect(_on_refresh_button_pressed)
	
	# add control elements to vertical box container
	container.add_child(property_control)
	container.add_child(refresh_button)
	
	# add container to inspector
	add_child(container)
	add_focusable(property_control)
	property_control.item_selected.connect(_on_item_selected)


func _on_item_selected(index : int):
	if updating:
		return
	
	current_value = index
	emit_changed(get_edited_property(), current_value)


func _update_property() -> void:
	var new_value = get_edited_object()[get_edited_property()]
	if (new_value == current_value):
		return
	
	updating = true
	current_value = new_value
	updating = false


func _on_refresh_button_pressed() -> void:
	refresh_asset_list()


func refresh_asset_list() -> void:
	var asset_dict = MotiveAutoload.get_rigid_body_assets()
	property_control.clear()
	for streaming_ID in asset_dict:
		property_control.add_item(asset_dict[streaming_ID], streaming_ID)
