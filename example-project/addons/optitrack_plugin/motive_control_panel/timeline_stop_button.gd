@tool
extends Button


func _pressed() -> void:
	pass
	#Motive.timeline_stop()
	MotiveAutoload.timeline_stop()
	#MotiveClientSingleton.timeline_stop()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
