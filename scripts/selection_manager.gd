extends Node

var selected_unit = null

func select(unit):
	selected_unit = unit

func command_move(position: Vector2):
	if selected_unit:
		selected_unit.move_to(position)
