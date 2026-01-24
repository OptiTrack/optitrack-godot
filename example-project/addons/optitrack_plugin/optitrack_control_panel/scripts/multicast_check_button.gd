@tool
extends CheckBox

var settings : OptiTrackSettings = preload("res://addons/optitrack_plugin/optitrack_settings.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_pressed = settings.multicast


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _toggled(toggled_on: bool) -> void:
	OptiTrack.set_multicast(toggled_on)
	settings.multicast = OptiTrack.get_multicast()
	button_pressed = OptiTrack.get_multicast()
	ResourceSaver.save(settings, "res://addons/optitrack_plugin/optitrack_settings.tres")
