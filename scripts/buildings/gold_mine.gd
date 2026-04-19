extends Node3D

var amount := 5000

func harvest(value: int) -> int:
	var taken = min(value, amount)
	amount -= taken
	return taken
