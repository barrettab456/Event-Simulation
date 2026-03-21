extends Node2D
var satisfaction = 50
var is_seated = false 
var ticket_price = 50

@onready var circle_not_seated = $circle_not_seated
func update_color():
	if is_seated:
		circle_not_seated.modulate = Color(0, 1, 0)
	else:
		circle_not_seated.modulate = Color(1,0,0)
