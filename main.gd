#to get tables to go up (enter) 
#to get guests up (space)
extends Node

var coins = 0
var guests = 0
var tables = 0 
var enough_funds = false 
var unseated_guest_list = []
var table_list = []

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
	var guest = preload("res://Guest.tscn").instantiate()
	add_child(guest)
	unseated_guest_list.append(guest)
	guest.position = Vector2(50 * unseated_guest_list.size(), 400)

	guests += 1
	coins += guest.ticket_price
	
	#$UI/guest_circles.add_child(guest.circle)
	
	seat_guest_at_table(guest)
	sufficient_funds()
	update_hud()
	
func new_table():
	if enough_funds:
		var table = preload("res://Table.tscn").instantiate()
		add_child(table)
		
		var cols = 4
		var spacing_x = 250
		var spacing_y = 250
		var index = tables  
		var row = index / cols
		var col = index % cols
		table.position = Vector2(col * spacing_x, row * spacing_y)

		table_list.append(table)
		
		tables += 1
		coins -= 100
	
	for guest in unseated_guest_list.duplicate():
		seat_guest_at_table(guest)

		
	sufficient_funds()
	update_hud()

func sufficient_funds():
	if coins < 100:
		$coin_count.modulate = Color.RED
		enough_funds = false
	else:
		$coin_count.modulate = Color.AQUAMARINE
		enough_funds = true
		
func seat_guest_at_table(guest):
	for t in table_list:
		if t.has_space():
			t.sit_guest(guest)
			guest.is_seated = true
			if guest in unseated_guest_list:
				unseated_guest_list.erase(guest)
			return		
	
func update_hud():
	$coin_count.text = "Coin Count:" + str(coins)
	$head_count.text = "Head count:" + str(guests)
	$table_count.text = "Table count:" + str(tables)
	if tables * 4 < guests: 
		$table_count.modulate = Color.RED
	else: 
		$table_count.modulate = Color.AQUAMARINE
