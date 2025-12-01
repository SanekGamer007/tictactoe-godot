extends Control
class_name Cell

@onready var cellid = int(self.name.replace("Cell", ""))
var Cross: Texture = preload("res://objects/cell/cross.png")
var Circle: Texture = preload("res://objects/cell/circle.png")

var current_turn: main.types = main.PLAYER
var type: main.types
signal clicked(cellid: int)

func _on_mouse_entered() -> void:
	if type == main.types.NULL:
		$TextureRect.self_modulate = Color(1.0, 1.0, 1.0, 0.2)
		if current_turn == main.types.CIRCLE:
			$TextureRect.texture = Circle
		elif current_turn == main.types.CROSS:
			$TextureRect.texture = Cross

func _on_mouse_exited() -> void:
	if type == main.types.NULL:
		$TextureRect.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
		$TextureRect.texture = null

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			clicked.emit(cellid)

func set_move(newtype: main.types):
	$TextureRect.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
	if newtype == main.types.CROSS:
		$TextureRect.texture = Cross
	elif newtype == main.types.CIRCLE:
		$TextureRect.texture = Circle
	else:
		$TextureRect.texture = null
	type = newtype
