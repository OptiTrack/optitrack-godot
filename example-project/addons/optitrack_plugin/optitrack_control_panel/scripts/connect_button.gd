@tool
extends Button

signal motive_connect

func _pressed() -> void:
	OptiTrack.connect_to_motive()
	motive_connect.emit()
