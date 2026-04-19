extends CharacterBody2D

var speed := 100
var target_position := Vector2.ZERO

func _physics_process(delta):
	if position.distance_to(target_position) > 5:
		var dir = (target_position - position).normalized()
		velocity = dir * speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO

func move_to(pos: Vector2):
	target_position = pos
