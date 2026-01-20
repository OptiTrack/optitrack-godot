@tool
extends Button


func _pressed() -> void:
	pass
	#Motive.timeline_play()
	MotiveAutoload.timeline_play()
	#MotiveClientSingleton.timeline_play()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
