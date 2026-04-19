extends "res://scripts/units/unit.gd"

enum State { IDLE, MOVING_TO_RESOURCE, GATHERING, RETURNING }

var state = State.IDLE
var carrying := 0
var max_capacity := 100

var target_resource = null
var town_hall = null

var gather_timer := 0.0
var gather_interval := 1.0

func set_town_hall(th):
	town_hall = th

func gather_from(resource):
	target_resource = resource
	state = State.MOVING_TO_RESOURCE
	move_to(resource.global_position)

func on_selection_changed(selected: bool):
	pass

func _physics_process(delta):
	super._physics_process(delta)

	match state:
		State.MOVING_TO_RESOURCE:
			if position.distance_to(target_resource.global_position) < 10:
				state = State.GATHERING
				gather_timer = 0

		State.GATHERING:
			gather_timer += delta
			if gather_timer >= gather_interval:
				gather_timer = 0
				if carrying < max_capacity:
					var mined = target_resource.harvest(10)
					carrying += mined
				else:
					state = State.RETURNING
					move_to(town_hall.global_position)

		State.RETURNING:
			if position.distance_to(town_hall.global_position) < 10:
				town_hall.deposit(self)
				state = State.IDLE
