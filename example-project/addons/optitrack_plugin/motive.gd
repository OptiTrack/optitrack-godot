class_name Motive extends MotiveClient


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not Engine.is_editor_hint():
		# get configuration settings from the Autoload MotiveClient that has 
		# been set up in the editor
		set_server_address(MotiveAutoload.get_server_address())
		set_client_address(MotiveAutoload.get_client_address())
		set_multicast(MotiveAutoload.get_multicast())
	
	connect_to_motive()
