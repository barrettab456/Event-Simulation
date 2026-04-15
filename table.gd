extends Node2D

var max_capacity = 4
const seat_loc:Array[Vector2] = [
	Vector2(-7, 10),
	Vector2(70, 10),
	Vector2(-7, 75),
	Vector2(70, 75)
]

var chairs:Array = [null, null, null, null]

func sit_guest(guest):
	for i in range(chairs.size()):
		if chairs[i] == null:
			chairs[i] = guest
			guest.is_seated = true
			guest.current_table = self
			guest.update_color()

			var target_pos = global_position + seat_loc[i]
			guest.walk_to(target_pos)

			return

func remove_guest(guest):
	var index := chairs.find(guest)
	if index != -1:
		chairs[index] = null
		guest.is_seated = false
		guest.current_table = null
		guest.update_color()
