#to get tables to go up (enter) 
#to get guests up (space)
extends Node

var coins = 200
var guests = 0
var time_left = 120
var cooldown_time = 13
var guest_scene = preload("res://Guest.tscn")

var unseated_guest_list = []
var table_list = []

func _ready() -> void:
	$Hud.get_ready(coins)
	new_table()
	
func _input(event):
	if event.is_action_pressed("add_table"):
		new_table()
	
func new_guest():
	var guest = guest_scene.instantiate()
	add_child(guest)
	guest.left_table.connect(seat_guest_at_table)
	guest.left_line.connect(on_guest_left_line)
	unseated_guest_list.append(guest)
	guest.update_color()
	guest.name_guest(guests)
	guest.position = Vector2(50 * unseated_guest_list.size(), 400)

	guests += 1
	seat_guest_at_table()
	
func pay_entry_fee(guest):
	coins += guest.ticket_price
	$Hud.check_sufficient_funds(coins)
	$Hud.update_coins_hud(coins)

func new_table():
	if $Hud.check_table_errors(table_list, coins):
		$Hud.update_add_table_button()
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
		
		coins -= 200
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



func _on_add_table_pressed():
	new_table()
	
func _on_guest_timer_timeout():
	new_guest()

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
	
func _on_table_cooldown_timeout() -> void:
	cooldown_time -= 1
	$Hud/add_table/new_table_block/gathering_table.text = "Gathering more tables..." + str(cooldown_time) + " MORE SECONDS!"
	if cooldown_time == 0:
		$Hud/add_table.disabled = false
		$Hud/add_table/new_table_block.visible = false
		cooldown_time = 13
		
func on_guest_left_line(guest):
	unseated_guest_list.erase(guest)
