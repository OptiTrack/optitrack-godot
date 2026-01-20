@tool
extends Button


func _pressed() -> void:
	MotiveAutoload.disconnect_from_motive()
