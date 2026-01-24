extends MotiveClient

var settings : OptiTrackSettings

# Called when the node enters the scene tree for the first time.
func _init() -> void:
	settings = ResourceLoader.load("res://addons/optitrack_plugin/optitrack_settings.tres", "", ResourceLoader.CACHE_MODE_REPLACE)
	
	# load settings from settings resource
	set_server_address(settings.server_address)
	set_client_address(settings.client_address)
	set_multicast(settings.multicast)
	
	connect_to_motive()
