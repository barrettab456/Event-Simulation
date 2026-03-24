#to get tables to go up (enter) 
#to get guests up (space)
extends Node

var coins = 0
var guests = 0

## ! this variable seems redundant, can't you just check tht length of the tables list?
var tables = 0 

## ! see sufficient_funds functions: this variable is a scary to me in terms of stale state, what if it doesn't get updated at the right time? I would say delete this call the functin where necessary
var enough_funds = false 

var unseated_guest_list = []
var table_list = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	## ! Agreed that the stuff below belongs in it's own HUD script and scene
	$coin_count.text = "Coin Count:" + str(coins)
	$coin_count.modulate = Color.RED
	
func _input(event):
	if event.is_action_pressed("add_person"):
		new_guest()
	if event.is_action_pressed("add_table"):
		new_table()
	
func new_guest():
	var guest = preload("res://Guest.tscn").instantiate()
	add_child(guest)
	unseated_guest_list.append(guest)
	guest.update_color()
	guest.position = Vector2(50 * unseated_guest_list.size(), 400)

	guests += 1
	coins += guest.ticket_price
	
	## ! functions should generally be phrased as actions, maybe check_if_winner, display_if_winner? Also, this should be part of HUD
	winner()
	
	#$UI/guest_circles.add_child(guest.circle)
	
	## ! this name is great, direct clear action
	seat_guest_at_table(guest)
	
	## ! this one again should indicate what is being done
	sufficient_funds()
	update_hud()

func winner():
	if coins >= 1000:
		$winner.visible = true
		
func new_table():
	if enough_funds and tables < 8 :
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
	elif tables == 8:
		display_no_space()
	elif not enough_funds:
		display_no_funds()
		
	for guest in unseated_guest_list.duplicate():
		seat_guest_at_table(guest)

		
	sufficient_funds()
	update_hud()

## ! both of these seem like HUD
func display_no_space():
		$no_space.visible = true
		await get_tree().create_timer(1.0).timeout
		$no_space.visible = false

func display_no_funds():
		$no_funds.visible = true
		await get_tree().create_timer(1.0).timeout
		$no_funds.visible = false
	

## ! this should be like check_for_table_funds or something, should just return true/false
## ! there should be a HUD function that sets color
## ! Where this is called should be an if statement that calls this and then calls appropriate HUD function
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
			## ! sit_guest might not seat someone, it has an if statement (especially when game gets complicated)
			t.sit_guest(guest)
			
			## ! can't this part be in Table.sit_guest so it only happens if they are seated?
			guest.is_seated = true
			guest.update_color()
			
			## ! Why this if statement? Shouldn't you know whether they are in the guest_list or not?
			if guest in unseated_guest_list:
				unseated_guest_list.erase(guest)
			return		
	
func update_hud():
	$coin_count.text = "Coin Count:" + str(coins)


#GET ADD TABLE BUTTON TO WORK
func _on_add_table_pressed():
	new_table()
