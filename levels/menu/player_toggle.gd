extends CheckBox


func _on_pressed() -> void:
	if main.PLAYER == main.types.CROSS:
		main.PLAYER = main.types.CIRCLE
		main.PLAYER2 = main.types.CROSS
	else:
		main.PLAYER = main.types.CROSS
		main.PLAYER2 = main.types.CIRCLE
