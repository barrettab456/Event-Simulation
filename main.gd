#to get tables to go up (enter) 
#to get guests up (space)
extends Node

var coins = 480
var guests = 0
var time_left = 120
var cooldown_time = 7
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
	guest.position = Vector2(1143, 398)
	guest.left_table.connect(seat_guest_at_table)
	guest.left_line.connect(on_guest_left_line)
	unseated_guest_list.append(guest)
	guest.update_color()
	guest.name_guest(guests)
	
	guests += 1
	seat_guest_at_table()
	
	if not guest.is_seated:
		update_line_positions()
	
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
		
		coins -= 300
		$cash.play()

		for guest in unseated_guest_list.duplicate():
			seat_guest_at_table()

	$Hud.check_sufficient_funds(coins)
	$Hud.update_coins_hud(coins)
	
func seat_guest_at_table():
	for guest in unseated_guest_list.duplicate():
		for t in table_list:
			if t.sit_guest(guest):
				unseated_guest_list.erase(guest)
				
				pay_entry_fee(guest)
				break				
				



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
	if coins >= 1500:
		$Hud/winner.visible = true
	else:
		$Hud/loser.visible = true
		$Hud/loser/Label2.text = "You needed " + str(1500-coins) + " more dollars"
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
		cooldown_time = 7	
func on_guest_left_line(guest):
	unseated_guest_list.erase(guest)


func update_line_positions():
	var start_pos = Vector2(50, 400)
	var spacing = 50
	for i in range(unseated_guest_list.size()):
		var guest = unseated_guest_list[i]
		if not guest.is_seated:
			var target = start_pos + Vector2(i * spacing, 0)
			guest.walk_to(target)
