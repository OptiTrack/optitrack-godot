@tool
extends CheckBox


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_pressed = OptiTrack.get_multicast()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _toggled(toggled_on: bool) -> void:
	OptiTrack.set_multicast(toggled_on)
