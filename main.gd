extends Node

var customers = 0
var table = 0
var coins = 90
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$head_count.text = "Head count:"
	$head_count.modulate = Color.AQUAMARINE
	
	$table_count.text = "Table count:"
	$table_count.modulate = Color.AQUAMARINE
	
	$coin_count.text = "Coin Count:" + str(coins)
	$coin_count.modulate = Color.RED
	
	
func _input(event):
	if event.is_action_pressed("add_person"):
		customers += 1
		if customers > table*4:
			coins += 15
		else:
			coins += 50
		$coin_count.text = "Coin Count:" + str(coins)
		if coins >= 100:
			$coin_count.modulate = Color.AQUAMARINE
		
		if customers > table*4:
			$head_count.modulate = Color.RED
		$head_count.text = "Head count:" + str(customers)
		
	if event.is_action_pressed("add_table"):
		if coins >= 100:
			table += 1
			$table_count.text = "Table count:" + str(table)
			coins -= 100
			$coin_count.text = "Coin Count:" + str(coins)
			if customers < table*4:
				$head_count.modulate = Color.AQUAMARINE
		else:
			$coin_count.modulate = Color.RED
			
		


func _on_add_person_pressed() -> void:
	customers += 1
	if customers > table*4:
		coins += 15
	else:
		coins += 50
	$coin_count.text = "Coin Count:" + str(coins)
	if coins >= 100:
		$coin_count.modulate = Color.AQUAMARINE
		
	if customers > table*4:
		$head_count.modulate = Color.RED
	$head_count.text = "Head count:" + str(customers)


func _on_add_table_pressed() -> void:
	if coins >= 100:
		table += 1
		$table_count.text = "Table count:" + str(table)
		coins -= 100
		$coin_count.text = "Coin Count:" + str(coins)
		if customers < table*4:
			$head_count.modulate = Color.AQUAMARINE

	if coins < 100:
		$coin_count.modulate = Color.RED
