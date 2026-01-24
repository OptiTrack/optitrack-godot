@tool
extends LineEdit

var settings : OptiTrackSettings = preload("res://addons/optitrack_plugin/optitrack_settings.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = settings.server_address


func _on_editing_toggled(toggled_on: bool) -> void:
	if not toggled_on:
		OptiTrack.set_server_address(text)
		settings.server_address = OptiTrack.get_server_address()
		text = OptiTrack.get_server_address()
		ResourceSaver.save(settings, "res://addons/optitrack_plugin/optitrack_settings.tres")
