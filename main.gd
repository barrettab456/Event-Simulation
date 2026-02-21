extends Node

var customers = 0
var table = 0
var coins = 0 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$head_count.text = "Head count:"
	$head_count.modulate = Color.AQUAMARINE
	
	$table_count.text = "Table count:"
	$table_count.modulate = Color.AQUAMARINE
	
	$coin_counter.start()
	
func _input(event):
	if event.is_action_pressed("add_person"):
		customers += 1
		coins = $coin_counter 
		$coin_count = "Coin count:" + str(coins)
		if customers > table*4:
			$head_count.modulate = Color.RED
		$head_count.text = "Head count:" + str(customers)
		
	if event.is_action_pressed("add_table"):
		table += 1
		$table_count.text = "Table count:" + str(table)
		if customers < table*4:
			$head_count.modulate = Color.AQUAMARINE
		
