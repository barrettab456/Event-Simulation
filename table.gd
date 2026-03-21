extends Node

var max_capacity = 4
var seated_guests = 0
var sat_guest_list = []

func has_space():
	return seated_guests < max_capacity

func sit_guest(guest):
	if has_space():
		seated_guests+=1
		sat_guest_list.append(guest)
		if seated_guests == 1:
			guest.position = Vector2(-4,5)
		if seated_guests == 2:
			guest.position = Vector2(94,5)
		if seated_guests == 3:
			guest.position = Vector2(-4,190)
		if seated_guests == 4:
			guest.position = Vector2(94,190)
