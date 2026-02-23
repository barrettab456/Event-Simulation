extends Node
var table = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$table_count.text = "Table count:"
	$table_count.modulate = Color.AQUAMARINE

func _input(event):	
	if event.is_action_pressed("add_table"):
		new_table()

func _on_add_table_pressed() -> void:
	new_table()
		
func new_table():
	if $main.coins >= 100:
			table += 1
			$table_count.text = "Table count:" + str(table)
			$main.coins -= 100
			$main.coin_count.text = "Coin Count:" + str($main.coins)
