@tool
extends FoldableContainer

var icon : TextureRect = TextureRect.new()
var connected_icon = preload("../icons/connected.png")
var disconnected_icon = preload("../icons/disconnected.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_connection_icon()
	icon.expand_mode = TextureRect.EXPAND_KEEP_SIZE
	add_title_bar_control(icon)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _exit_tree() -> void:
	remove_title_bar_control(icon)


func update_connection_icon() -> void:
	if OptiTrack.is_connected_to_motive():
		icon.texture = connected_icon
	else:
		icon.texture = disconnected_icon


func _on_connect_button_motive_connect() -> void:
	update_connection_icon()


func _on_disconnect_button_motive_disconnect() -> void:
	update_connection_icon()
