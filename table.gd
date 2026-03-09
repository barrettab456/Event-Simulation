extends Node

var max_capacity = 4
var seated_guests = 0

func has_space():
	return seated_guests < max_capacity

func sit_guest():
	if has_space():
		seated_guests+=1
