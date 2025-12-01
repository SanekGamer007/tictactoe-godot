extends ItemList

func _on_item_selected(index: int) -> void:
	main.gamemode = index as main.gamemodes
