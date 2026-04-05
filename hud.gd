extends Node

func get_ready(coins):
	$coin_count.text = "Coin Count:" + str(coins)
	$coin_count.modulate = Color.RED

func update_coins_hud(coins):
	$coin_count.text = "Coin Count:" + str(coins)

func check_table_errors(table_list, coins):
	if table_list.size() == 8:
		display_no_space()
	if check_sufficient_funds(coins) == false:
		display_no_funds()
	
func display_no_space():
		$no_space.visible = true
		await get_tree().create_timer(1.0).timeout
		$no_space.visible = false

func display_no_funds():
		$no_funds.visible = true
		await get_tree().create_timer(1.0).timeout
		$no_funds.visible = false
		
func check_sufficient_funds(coins):
	if coins < 100:
		$coin_count.modulate = Color.RED
		return false
	else:
		$coin_count.modulate = Color.AQUAMARINE
		return true
		
		
