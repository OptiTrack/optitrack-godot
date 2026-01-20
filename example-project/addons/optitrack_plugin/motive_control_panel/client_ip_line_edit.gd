@tool
extends LineEdit


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = MotiveAutoload.get_client_address()


func _on_editing_toggled(toggled_on: bool) -> void:
	if not toggled_on:
		MotiveAutoload.set_client_address(text)
