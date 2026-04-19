extends Node2D

var selection_manager = preload("res://scripts/selection_manager.gd").new()

var worker
var gold_mine
var town_hall

func _ready():
	add_child(selection_manager)

	print("AIcraft RTS Prototype started")

	var worker_scene = preload("res://scenes/units/worker.tscn")
	worker = worker_scene.instantiate()
	worker.position = Vector2(200, 200)
	add_child(worker)

	var town_scene = preload("res://scenes/buildings/town_hall.tscn")
	town_hall = town_scene.instantiate()
	town_hall.position = Vector2(100, 200)
	add_child(town_hall)

	worker.set_town_hall(town_hall)

	selection_manager.select(worker)

	var res_scene = preload("res://scenes/resources/gold_mine.tscn")
	gold_mine = res_scene.instantiate()
	gold_mine.position = Vector2(400, 200)
	add_child(gold_mine)

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var click_pos = get_global_mouse_position()

		if event.button_index == MOUSE_BUTTON_LEFT:
			if worker.position.distance_to(click_pos) < 20:
				selection_manager.select(worker)
			else:
				selection_manager.clear_selection()

		if event.button_index == MOUSE_BUTTON_RIGHT:
			if gold_mine.position.distance_to(click_pos) < 30:
				selection_manager.command_gather(gold_mine)
			else:
				selection_manager.command_move(click_pos)
