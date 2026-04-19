extends GutTest

var MainScene = preload("res://main.tscn")
var main = MainScene.instantiate()

func after_each():
	main.queue_free()
	main.coins = 0
	
func test_new_guest():
	add_child(main)
	main.new_guest()
	main.new_guest()
	assert_eq(main.unseated_guest_list.size(), 2, "guest amount")
	assert_eq(main.coins, 60, "guest coins")
	
func test_new_table():
	main.new_table()
	main.coins = 100
	main.new_table()
	assert_eq(main.table_list.size(), 1, "table amount")
	assert_eq(main.coins, 0, "table coins")

func test_seat_guest_at_table():	

	var table1 = main.new_table()
	var table2 = main.new_table()
	
	var guest = main.new_guest()
	
	main.seat_guest_at_table(guest)

	assert_eq(guest.current_table, table1, "Guest should be assigned to first table")
	assert_true(guest not in main.unseated_guest_list, "Guest should be removed from unseated list")
	assert_eq(table1.sat_guests.size(), 1, "Table1 should have exactly one guest")
	assert_eq(table2.sat_guests.size(), 0, "Table2 should have no guests")
