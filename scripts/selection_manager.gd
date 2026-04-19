extends Node

var selected_unit = null

func select(unit):
	if selected_unit and selected_unit.has_method("on_selection_changed"):
		selected_unit.on_selection_changed(false)
	selected_unit = unit
	if selected_unit and selected_unit.has_method("on_selection_changed"):
		selected_unit.on_selection_changed(true)

func clear_selection():
	if selected_unit and selected_unit.has_method("on_selection_changed"):
		selected_unit.on_selection_changed(false)
	selected_unit = null

func command_move(position: Vector2):
	if selected_unit:
		selected_unit.move_to(position)

func command_gather(resource):
	if selected_unit and selected_unit.has_method("gather_from"):
		selected_unit.gather_from(resource)
