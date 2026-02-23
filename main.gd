extends Node

var coins = 90
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$coin_count.text = "Coin Count:" + str(coins)
	$coin_count.modulate = Color.RED
	
	$add_guest.text = "Guest amount:"
	$add_guest.modulate = Color.AQUAMARINE
	
	$table_count.text = "Table count:"
	$table_count.modulate = Color.AQUAMARINE
	
func _input(event):
	if event.is_action_pressed("add_person"):
		$guests.new_guest()
	if event.is_action_pressed("add_table"):
		$tables.new_table()
	sufficent_funds()
		
func _on_add_person_pressed() -> void:
	$guests.new_guest()
	sufficent_funds()
	
func _on_add_table_pressed() -> void:
	$tables.new_table()
	sufficent_funds()
	
func sufficent_funds():	
	if $main.coins >= 100:
		$coin_count.modulate = Color.AQUAMARINE
	if $guests.guests > $tables.table*4:
		$guests/head_count.moducalte = Color.RED
