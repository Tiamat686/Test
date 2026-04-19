extends Node

var is_selected := false

func set_selected(value: bool) -> void:
	is_selected = value
	if owner and owner.has_method("on_selection_changed"):
		owner.on_selection_changed(value)
