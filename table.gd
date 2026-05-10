extends Node2D

var max_capacity = 4
const seat_loc_array = [
	Vector2(-7, -30),
	Vector2(70, -30),
	Vector2(-7, 70),
	Vector2(70, 70)
]

var chairs = [null, null, null, null]


func sit_guest(guest):
	for i in range(chairs.size()):
		if chairs[i] == null:
			#guest.guest_leave_timer.stop()
			chairs[i] = guest
			chairs[i].is_seated = true
			chairs[i].current_table = self
			chairs[i].update_color()

			var target_pos = global_position + seat_loc_array[i]
			guest.walk_to(target_pos)
			guest.guest_leave_count = 25
			guest.guest_leave_timer.start(1.00)
			guest.satisfaction = 2
			guest.update_color()
			return true
	return false

func remove_guest(guest):
	var index := chairs.find(guest)
	if index != -1:
		guest.is_seated = false
		guest.current_table = null
		guest.update_color()
		chairs[index] = null
