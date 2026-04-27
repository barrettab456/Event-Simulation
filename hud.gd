extends Node

func get_ready(coins):
	$coin_count.text = "Earnings:" + str(coins)
	$coin_count.modulate = Color.RED

func update_coins_hud(coins):
	$coin_count.text = "Earnings:" + str(coins)

func check_table_errors(table_list, coins):
	if table_list.size() >= 8:
		display_no_space()
		return false
	if check_sufficient_funds(coins) == false:
		display_no_funds()
		return false
	return true
		

func display_no_space():
	$no_space.visible = true
	await get_tree().create_timer(1.0).timeout
	$no_space.visible = false

func display_no_funds():
		$no_funds.visible = true
		await get_tree().create_timer(1.0).timeout
		$no_funds.visible = false
		
func check_sufficient_funds(coins):
	if coins < 180:
		$coin_count.modulate = Color.MAROON
		return false
	else:
		$coin_count.modulate = Color.AQUAMARINE
		return true
		
func display_time(time_left):
	$Timer/time_timer.text = "Time left in event: " + str(time_left)
	if time_left <= 10:
		hurry_up()
		
func hurry_up():
	$Timer/time_timer.modulate = Color.MAROON
	$countdown_sound.play()
	
	
		
		
