extends Node

var selected_units: Array = []

func select_single(unit: Node) -> void:
	clear_selection()
	if unit:
		selected_units.append(unit)
		if unit.has_method("on_selection_changed"):
			unit.on_selection_changed(true)

func clear_selection() -> void:
	for unit in selected_units:
		if unit and unit.has_method("on_selection_changed"):
			unit.on_selection_changed(false)
	selected_units.clear()

func get_primary_selection() -> Node:
	if selected_units.is_empty():
		return null
	return selected_units[0]
