extends Node2D
var satisfaction = 50
var is_seated = false 
var ticket_price = 30
var current_table = null

@onready var circle_not_seated = $circle_not_seated
func update_color():
	if is_seated:
		circle_not_seated.modulate = Color(0, 1, 0)
	else:
		circle_not_seated.modulate = Color(1,0,0)
		
func _on_guest_leave_timer_timeout() -> void:
	if current_table:
		current_table.remove_guest(self)
	queue_free()
