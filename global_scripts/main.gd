extends Node
var PLAYER: types = main.types.CROSS
var PLAYER2: types = main.types.CIRCLE
var peer: ENetMultiplayerPeer
var beatableai: bool = false

enum gamemodes {
	AI,
	MULTIPLAYER,
	LOCALMULTIPLAYER,
}
var gamemode: gamemodes

enum types {
	NULL,
	CIRCLE,
	CROSS,
}

enum WINTYPES {
	NULL,
	CIRCLE,
	CROSS,
	DRAW,
}

func _ready() -> void:
	get_tree().scene_changed.connect(_on_scene_changed)

func _on_scene_changed() -> void:
	if gamemode == gamemodes.MULTIPLAYER:
		PLAYER2 = main.types.CIRCLE

func print_warn(message: String) -> void:
	print_rich("[color=yellow]", "WARN: ", message)
