extends Node2D

var amount := 10000

func harvest(value: int) -> int:
	var taken = min(value, amount)
	amount -= taken
	return taken
