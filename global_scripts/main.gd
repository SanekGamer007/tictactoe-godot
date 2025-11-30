extends Node
var twoplayers: bool = false
var localcoop: bool = false
var beatable_ai: bool = false
var PLAYER = main.types.CROSS
var PLAYER2
var AI = main.types.CIRCLE


enum types {
	NULL,
	CIRCLE,
	CROSS,
}

func _ready() -> void:
	get_tree().scene_changed.connect(_on_scene_changed)


func _on_scene_changed() -> void:
	if twoplayers:
		PLAYER2 = main.types.CIRCLE
	if localcoop and !twoplayers:
		printerr("Invalid game configuration. Fixing...")
		localcoop = false

func print_warn(message: String) -> void:
	print_rich("[color=yellow]", "WARN: ", message)
