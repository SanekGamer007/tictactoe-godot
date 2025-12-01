extends Button



func _on_pressed() -> void:
	if main.peer == null:
		main.peer = ENetMultiplayerPeer.new()
	main.peer.create_server(int($LineEdit.text), 2)
	multiplayer.multiplayer_peer = main.peer
