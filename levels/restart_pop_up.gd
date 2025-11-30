extends BoxContainer
var circleswho: String = "AI"
var crosseswho: String = "YOU"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().gameend.connect(_on_gameend)
	if main.twoplayers:
		circleswho = "PLAYER TWO"
		crosseswho = "PLAYER ONE"


func _on_gameend(whowon: int) -> void:
	match whowon:
		0:
			$Panel/VBoxContainer/Label.text = "DRAW"
		1:
			$Panel/VBoxContainer/Label.text = circleswho + " WON"
		2:
			$Panel/VBoxContainer/Label.text = crosseswho + " WON"
	self.visible = true
