#to get tables to go up (enter) 
#to get guests up (space)
extends Node

var coins = 0
var guests = 0
var time_left = 120

var unseated_guest_list = []
var table_list = []

func _ready() -> void:
	$Hud.get_ready(coins)
	print("hi")
	
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
	
	guest.name_guest(guests)
	$Hud.check_sufficient_funds(coins)
	$Hud.update_coins_hud(coins)
	
	
	#seat_guest_at_table(guest)


func new_table():
	if $Hud.check_table_errors(table_list, coins):
		var table = preload("res://Table.tscn").instantiate()
		add_child(table)
		
		var cols = 4
		var spacing_x = 250
		var spacing_y = 250
		var index = table_list.size()
		@warning_ignore("integer_division")
		var row = int(index / cols)
		var col = index % cols
		table.position = Vector2(col * spacing_x, row * spacing_y)

		table_list.append(table)
		
		coins -= 100
		
	for guest in unseated_guest_list.duplicate():
		seat_guest_at_table(guest)

	$Hud.check_sufficient_funds(coins)
	$Hud.update_coins_hud(coins)
	
func seat_guest_at_table(guest):
	for t in table_list:
		t.sit_guest(guest)
		guest.current_table = t
		guest.guest_timer.start()
		if guest in unseated_guest_list:
			unseated_guest_list.erase(guest)
			update_spawn_rate()
		return		


#GET ADD TABLE BUTTON TO WORK
func _on_add_table_pressed():
	print("on add")
	new_table()

func _on_guest_timer_timeout():
	new_guest()

func update_spawn_rate():
	var next_wait_time = unseated_guest_list.size()*2
	$Hud/guest_timer.wait_time = next_wait_time

func _on_timer_timeout() -> void:
	time_left -= 1
	$Hud/Timer/time_timer.text = "Time left in event: " + str(time_left)
	if time_left == 0:
		game_over()
		
func game_over():
	if coins >= 1000:
		$Hud/winner.visible = true
	else:
		$Hud/loser.visible = true
