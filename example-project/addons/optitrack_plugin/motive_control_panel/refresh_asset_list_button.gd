@tool
extends Button

var asset_dictionary : Dictionary
var asset_list : ItemList

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _pressed() -> void:
	asset_dictionary = MotiveAutoload.get_rigid_body_assets()
	asset_list = get_node("../AssetList")
	asset_list.clear()
	for id in asset_dictionary:
		var item_str = asset_dictionary[id]
		asset_list.add_item(item_str)
