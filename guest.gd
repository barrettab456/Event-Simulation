extends Node
var satisfaction = 50
var is_seated = false 
var ticket_price = 30
var current_table = null
var has_left = false
@onready var guest_timer = $guest_leave_timer

@onready var circle_not_seated = $circle_not_seated
func update_color():
	if is_seated:
		circle_not_seated.modulate = Color(0, 1, 0)
	else:
		circle_not_seated.modulate = Color(1,0,0)
		
func name_guest(num_guests):
	$guest_name.text = str(num_guests)
		
func _on_guest_leave_timer_timeout():
	if has_left:
		has_left = true
	if is_instance_valid(current_table):
		current_table.remove_guest(self)
	print("timer off")
	queue_free()
	
func walk_to(new_pos:Vector2, callback=null):
	# compute distance to find speed of movement
	var distance:float = self.position.distance_to(new_pos)
	var tween = get_tree().create_tween()
	# move 150 pixels per second
	tween.tween_property(self, "position", new_pos, distance/600)
	if callback:
		tween.tween_callback(callback)
