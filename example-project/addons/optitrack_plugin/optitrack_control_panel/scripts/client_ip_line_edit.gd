@tool
extends LineEdit

var settings : OptiTrackSettings = preload("res://addons/optitrack_plugin/optitrack_settings.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = settings.client_address


func _on_editing_toggled(toggled_on: bool) -> void:
	if not toggled_on:
		OptiTrack.set_client_address(text)
		settings.client_address = OptiTrack.get_client_address()
		text = OptiTrack.get_client_address()
		ResourceSaver.save(settings, "res://addons/optitrack_plugin/optitrack_settings.tres")
