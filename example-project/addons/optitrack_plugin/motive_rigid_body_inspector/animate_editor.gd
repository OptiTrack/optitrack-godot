extends EditorProperty


var property_control : CheckButton = CheckButton.new()
var updating = false
var current_value = false


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	property_control.button_pressed = current_value
	add_child(property_control)
	add_focusable(property_control)
	property_control.toggled.connect(_toggled)


func _toggled(toggled_on: bool) -> void:
	if updating:
		return
	
	current_value = toggled_on
	emit_changed(get_edited_property(), current_value)


func _update_property() -> void:
	var new_value = get_edited_object()[get_edited_property()]
	if (new_value == current_value):
		return
	
	updating = true
	current_value = new_value
	updating = false


func _on_toggled(toggled_on : bool):
	
	pass
