extends Node2D

var max_capacity = 4
var seated_guests = 0
var sat_guest_list = []

func has_space():
	return seated_guests < max_capacity

func sit_guest(guest):
	if has_space():
		seated_guests += 1
		sat_guest_list.append(guest)

		var seat_pos := Vector2.ZERO

		if seated_guests == 1:
			seat_pos = Vector2(-4, 5)
		elif seated_guests == 2:
			seat_pos = Vector2(94, 5)
		elif seated_guests == 3:
			seat_pos = Vector2(-4, 190)
		elif seated_guests == 4:
			seat_pos = Vector2(94, 190)

		guest.global_position = global_position + seat_pos
