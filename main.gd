extends Node

var coins = 0
var guests = 0
var tables = 0 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$coin_count.text = "Coin Count:" + str(coins)
	$coin_count.modulate = Color.RED
	
	$head_count.text = "Head amount:"
	$head_count.modulate = Color.AQUAMARINE
	
	$table_count.text = "Table count:"
	$table_count.modulate = Color.AQUAMARINE
	
func _input(event):
	if event.is_action_pressed("add_person"):
		new_guest()
	if event.is_action_pressed("add_table"):
		new_table()
	
func new_guest():
	guests += 1
	coins += 50
	update_hud()
	
func new_table():
	if coins >= 100:
			tables += 1
			coins -= 100
	update_hud()
			
func update_hud():
	$coin_count.text = "Coin Count:" + str(coins)
	if coins < 100: 
		$coin_count.modulate = Color.RED
	else: 
		$coin_count.modulate = Color.AQUAMARINE
	$head_count.text = "Head count:" + str(guests)
	$table_count.text = "Table count:" + str(tables)
	if tables < guests*4: 
		$table_count.modulate = Color.RED
	else: 
		$table_count.modulate = Color.AQUAMARINE
		
func _on_add_person_pressed() -> void:
	new_guest()
	
func _on_add_table_pressed() -> void:
	new_table()
