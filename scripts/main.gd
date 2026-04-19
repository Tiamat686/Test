extends Node2D

func _ready():
	print("AIcraft RTS Prototype started")

	# spawn test worker
	var worker_scene = preload("res://scenes/units/worker.tscn")
	var worker = worker_scene.instantiate()
	worker.position = Vector2(200, 200)
	add_child(worker)

	# spawn test resource
	var res_scene = preload("res://scenes/resources/gold_mine.tscn")
	var res = res_scene.instantiate()
	res.position = Vector2(400, 200)
	add_child(res)
