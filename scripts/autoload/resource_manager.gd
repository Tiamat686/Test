extends Node

var gold: int = 500
var lumber: int = 200
var oil: int = 0

func add_gold(value: int) -> void:
	gold += value
	print("Gold:", gold)

func spend_gold(value: int) -> bool:
	if gold >= value:
		gold -= value
		return true
	return false
