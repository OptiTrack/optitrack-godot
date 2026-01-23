@tool
extends LineEdit


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = OptiTrack.get_server_address()


func _on_editing_toggled(toggled_on: bool) -> void:
	if not toggled_on:
		OptiTrack.set_server_address(text)
