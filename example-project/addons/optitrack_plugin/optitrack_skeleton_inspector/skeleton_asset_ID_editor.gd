extends EditorProperty


# the OptionButton to be added to the inspector
var container : VBoxContainer = VBoxContainer.new()
var property_control : OptionButton = OptionButton.new()
var refresh_button : Button = Button.new()
var refresh_icon = preload("refresh.png")

var asset_dict : Dictionary

# internal variable for current value
var current_value = -1
# guard against internal changes while value is updating
var updating = false


func _init() -> void:
	# set up dropdown menu and refresh button
	refresh_asset_list()
	refresh_button.text = "Refresh Asset List"
	refresh_button.icon = refresh_icon
	refresh_button.expand_icon = true
	refresh_button.pressed.connect(_on_refresh_button_pressed)
	
	# add control elements to vertical box container
	container.add_child(property_control)
	container.add_child(refresh_button)
	
	# add container to inspector
	add_child(container)
	add_focusable(property_control)
	property_control.item_selected.connect(_on_item_selected)

# updates the value when an item is selected from the OptionList
func _on_item_selected(index : int):
	if updating:
		return
	
	current_value = property_control.get_item_id(index)
	emit_changed(get_edited_property(), current_value)


# handles changes to the data from the outside
func _update_property() -> void:
	var new_value = get_edited_object()[get_edited_property()]
	
	# nothing to update
	if (new_value == current_value):
		return
	
	updating = true
	current_value = new_value
	# make sure that current value is selected
	property_control.select(property_control.get_item_index(current_value))
	updating = false


func _on_refresh_button_pressed() -> void:
	refresh_asset_list()


func refresh_asset_list() -> void:
	# update asset dictionary
	if EditorInterface.is_plugin_enabled("optitrack_plugin"):
		asset_dict = OptiTrack.get_skeleton_assets()
	else:
		asset_dict = {-1 : "Check Motive connection"}
	
	property_control.clear()
	
	for streaming_ID in asset_dict:
		property_control.add_item(asset_dict[streaming_ID], streaming_ID)
	
	if asset_dict.has(-1):
		current_value = -1
	
	# make sure correct option is selected after list was cleared and repopulated
	var current_index = property_control.get_item_index(current_value)
	property_control.select(current_index)
