#to get tables to go up (enter) 
#to get guests up (space)
extends Node

var coins = 200
var guests = 0
var time_left = 120
var guest_scene = preload("res://Guest.tscn")

var unseated_guest_list = []
var table_list = []

func _ready() -> void:
	$Hud.get_ready(coins)
	new_table()
	
func _input(event):
	if event.is_action_pressed("add_person"):
		new_guest()
	if event.is_action_pressed("add_table"):
		new_table()
	
func new_guest():
	var guest = guest_scene.instantiate()
	add_child(guest)
	guest.left_table.connect(seat_guest_at_table)
	
	unseated_guest_list.append(guest)
	guest.update_color()
	guest.name_guest(guests)
	guest.position = Vector2(50 * unseated_guest_list.size(), 400)

	guests += 1
	update_spawn_rate()
	seat_guest_at_table()
	
func pay_entry_fee(guest):
	coins += guest.ticket_price
	$Hud.check_sufficient_funds(coins)
	$Hud.update_coins_hud(coins)



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
		
		coins -= 180
		$cash.play()
		
	for guest in unseated_guest_list.duplicate():
		seat_guest_at_table()

	$Hud.check_sufficient_funds(coins)
	$Hud.update_coins_hud(coins)
	
func seat_guest_at_table():
	var iteration_list = unseated_guest_list.duplicate()
	for i in range (iteration_list.size()):
		for t in table_list:
			if t.sit_guest(iteration_list[i]):
				iteration_list[i].current_table = t
				unseated_guest_list.erase(iteration_list[i])
				pay_entry_fee(iteration_list[i])
				update_spawn_rate()



#GET ADD TABLE BUTTON TO WORK
func _on_add_table_pressed():
	print("on add")
	new_table()

func _on_guest_timer_timeout():
	new_guest()

func update_spawn_rate():
	var next_wait_time = max(0.5, unseated_guest_list.size() * 1.5)
	if next_wait_time > 0:
		$Hud/guest_timer.wait_time = next_wait_time

func _on_timer_timeout() -> void:
	time_left -= 1
	$Hud.display_time(time_left)
	if time_left == 0:
		game_over()

func game_over():
	$Hud/background_music.end_music()
	if coins >= 1000:
		$Hud/winner.visible = true
	else:
		$Hud/loser.visible = true
	get_tree().paused = true
	$Hud/playAgain.visible = true


func _on_play_again_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
	
	
