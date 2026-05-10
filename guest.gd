extends Node

signal left_table
signal left_line(guest)

var satisfaction = 1
var is_seated = false 
var ticket_price = 40
var current_table = null
var guest_leave_count = 15
var has_left = false

@onready var guest_leave_timer = $guest_leave_timer

@onready var circle_not_seated = $circle_not_seated

func _ready():
	guest_leave_timer.start(1.00)

func update_color():
	if self.satisfaction == 2:
		circle_not_seated.modulate = Color(0, 1, 0)
	elif self.satisfaction == 0 and self.is_seated == false:
		circle_not_seated.modulate = Color(1,0,0)
	elif self.is_seated == false: 
		circle_not_seated.modulate = Color(0.751, 0.682, 0.231, 1.0)
		
func name_guest(num_guests):
	$guest_name.text = str(num_guests)
		
func _on_guest_leave_timer_timeout():
	guest_leave_count -= 1
	print(guest_leave_count)
	if guest_leave_count <= 0:
		has_left = true
		if is_instance_valid(current_table):
			current_table.remove_guest(self)
			left_table.emit()
		else:
			left_line.emit(self)
		queue_free()	
	elif guest_leave_count < 10:
		self.satisfaction = 0
		update_color()
	
func walk_to(new_pos:Vector2, callback=null):
	var distance:float = self.position.distance_to(new_pos)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", new_pos, distance/600)
	if callback:
		tween.tween_callback(callback)
