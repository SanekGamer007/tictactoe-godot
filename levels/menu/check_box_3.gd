extends CheckBox



func _on_check_box_2_pressed() -> void:
	disabled = !disabled
	if !disabled == false:
		button_pressed = false
		main.localcoop = false



func _on_pressed() -> void:
	main.localcoop = !main.localcoop
