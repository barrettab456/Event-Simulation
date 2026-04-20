extends Node2D

var max_capacity = 4
const seat_loc_array = [
	Vector2(-7, 10),
	Vector2(70, 10),
	Vector2(-7, 75),
	Vector2(70, 75)
]

var chairs = [null, null, null, null]

func sit_guest(guest):
	for i in range(chairs.size()):
		if chairs[i] == null:
			chairs[i] = guest
			chairs[i].is_seated = true
			chairs[i].current_table = self
			chairs[i].update_color()

			var target_pos = global_position + seat_loc_array[i]
			guest.walk_to(target_pos)

			return true
	return false

func remove_guest(guest):
	var index := chairs.find(guest)
	if index != -1:
		chairs[index] = null
		guest.is_seated = false
		guest.current_table = null
		guest.update_color()
