extends GutTest

var MainScene = preload("res://main.tscn")
var main 

func before_each():
	main = MainScene.instantiate()
	add_child(main)
	
func after_each():
	main.queue_free()
	main = null
	
func test_new_guest():
	main.new_guest()
	var guest = main.new_guest()
	assert_eq(main.unseated_guest_list.size(), 2, "guest amount")
	assert_eq(main.coins, 60, "guest coins")
	assert_true(guest in main.unseated_guest_list, "guest in list")
	
func test_new_table():
	main.new_table()
	main.coins = 100
	main.new_table()
	assert_eq(main.table_list.size(), 1, "table amount")
	assert_eq(main.coins, 0, "table coins")

func test_seat_guest_at_table():	
	var table1 = main.new_table()
	
	var guest = main.new_guest()
	
	main.seat_guest_at_table(guest)
	
	assert_eq(guest.current_table, table1, "gust at table")
