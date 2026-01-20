@tool
extends Button


func _pressed() -> void:
	MotiveAutoload.connect_to_motive()
