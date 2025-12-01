extends Button



func _on_pressed() -> void:
	if main.peer == null:
		main.peer = ENetMultiplayerPeer.new()
	main.peer.create_client($ip.text, int($port.text))
	multiplayer.multiplayer_peer = main.peer
	main.gamemode = main.gamemodes.MULTIPLAYER
	get_tree().change_scene_to_file("res://levels/game.tscn")
