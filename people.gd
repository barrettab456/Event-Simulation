extends Node2D
var guests = 0 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$add_guest.text = "Guest amount:"
	$add_guest.modulate = Color.AQUAMARINE

func new_guest():
	guests += 1
	$main.coins += 50
	$coin_count.text = "Coin Count:" + str($main.coins)
	$head_count.text = "Head count:" + str(guests)
