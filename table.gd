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
			seat_pos = Vector2(-7, 10)
		elif seated_guests == 2:
			seat_pos = Vector2(70,10)
		elif seated_guests == 3:
			seat_pos = Vector2(-7, 75)
		elif seated_guests == 4:
			seat_pos = Vector2(70, 75)
			
		guest.is_seated = true
		guest.update_color()
		guest.current_table = self
		guest.global_position = global_position + seat_pos
		
func remove_guest(guest):
	if guest in sat_guest_list:
			sat_guest_list.erase(guest)
			seated_guests -= 1
			guest.is_seated = false
			guest.current_table = null
			guest.update_color()
