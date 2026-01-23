@tool
extends Button

signal motive_disconnect

func _pressed() -> void:
	OptiTrack.disconnect_from_motive()
	motive_disconnect.emit()
