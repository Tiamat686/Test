extends "res://scripts/units/unit.gd"

var carrying := 0
var max_capacity := 100

func gather(resource):
	if carrying < max_capacity:
		carrying += 10

func deposit():
	ResourceManager.add_gold(carrying)
	carrying = 0
