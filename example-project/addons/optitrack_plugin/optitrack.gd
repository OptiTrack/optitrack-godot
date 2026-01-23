extends MotiveClient


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not Engine.is_editor_hint():
		# get configuration settings from the Autoload MotiveClient that has 
		# been set up in the editor
		set_server_address(OptiTrack.get_server_address())
		set_client_address(OptiTrack.get_client_address())
		set_multicast(OptiTrack.get_multicast())
	
	connect_to_motive()


func _exit_tree() -> void:
	disconnect_from_motive()
