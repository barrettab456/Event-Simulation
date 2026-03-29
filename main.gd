#to get tables to go up (enter) 
#to get guests up (space)
#WHAT GOES HERE VS HUD?
#MAKE FLOW OF HOW GUESTS MOVE BETTER

extends Node

var coins = 0
var guests = 0
var time_left = 120

var unseated_guest_list = []
var table_list = []

func _ready() -> void:
	$coin_count.text = "Coin Count:" + str(coins)
	$coin_count.modulate = Color.RED
	
func _input(event):
	if event.is_action_pressed("add_person"):
		new_guest()
	if event.is_action_pressed("add_table"):
		new_table()
	
func new_guest():
#PUT ON TIMER
	var guest = preload("res://Guest.tscn").instantiate()
	add_child(guest)
	unseated_guest_list.append(guest)
	update_spawn_rate()
	guest.update_color()
	guest.position = Vector2(50 * unseated_guest_list.size(), 400)

	guests += 1
	coins += guest.ticket_price
	
	seat_guest_at_table(guest)
	check_sufficient_funds()
	update_hud()
		
func new_table():
	print("new_table")
	if check_sufficient_funds() and table_list.size() < 8 :
		var table = preload("res://Table.tscn").instantiate()
		add_child(table)
		
		var cols = 4
		var spacing_x = 250
		var spacing_y = 250
		var index = table_list.size()
		var row = index / cols
		var col = index % cols
		table.position = Vector2(col * spacing_x, row * spacing_y)

		table_list.append(table)
		
		coins -= 100
	elif table_list.size() == 8:
		display_no_space()
	elif check_sufficient_funds() == false:
		display_no_funds()
		
	for guest in unseated_guest_list.duplicate():
		seat_guest_at_table(guest)

		
	check_sufficient_funds()
	update_hud()

func display_no_space():
		$no_space.visible = true
		await get_tree().create_timer(1.0).timeout
		$no_space.visible = false

func display_no_funds():
		$no_funds.visible = true
		await get_tree().create_timer(1.0).timeout
		$no_funds.visible = false
	

func check_sufficient_funds():
	if coins < 100:
		$coin_count.modulate = Color.RED
		return false
	else:
		$coin_count.modulate = Color.AQUAMARINE
		return true
		
		
func seat_guest_at_table(guest):
	for t in table_list:
		if t.has_space():
			t.sit_guest(guest)
			guest.current_table = t
			guest.is_seated = true
			guest.update_color()
			if guest in unseated_guest_list:
				unseated_guest_list.erase(guest)
				update_spawn_rate()
			return		
	
func update_hud():
	$coin_count.text = "Coin Count:" + str(coins)


#GET ADD TABLE BUTTON TO WORK
func _on_add_table_pressed():
	print("on add")
	new_table()


func _on_guest_timer_timeout() -> void:
	new_guest()
	

func update_spawn_rate():
	var next_wait_time = unseated_guest_list.size()*2
	$guest_timer.wait_time = next_wait_time
	print(next_wait_time)


func _on_timer_timeout() -> void:
	time_left -= 1
	$Timer/time_timer.text = "Time left in event: " + str(time_left)
	if time_left == 0:
		game_over()

func game_over():
	if coins >= 1000:
		$winner.visible = true
	else:
		$loser.visible = true
#MAKE A NEW GAME BUTTON
