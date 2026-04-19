extends Node2D

var selection_manager = preload("res://scripts/selection_manager.gd").new()

func _ready():
	add_child(selection_manager)

	print("AIcraft RTS Prototype started")

	var worker_scene = preload("res://scenes/units/worker.tscn")
	var worker = worker_scene.instantiate()
	worker.position = Vector2(200, 200)
	add_child(worker)

	selection_manager.select(worker)

	var res_scene = preload("res://scenes/resources/gold_mine.tscn")
	var res = res_scene.instantiate()
	res.position = Vector2(400, 200)
	add_child(res)

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			selection_manager.command_move(get_global_mouse_position())
