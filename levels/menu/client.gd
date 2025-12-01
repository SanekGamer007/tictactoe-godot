extends Button



func _on_pressed() -> void:
	if main.peer == null:
		main.peer = ENetMultiplayerPeer.new()
	main.peer.create_client($ip.text, int($port.text))
	multiplayer.multiplayer_peer = main.peer
