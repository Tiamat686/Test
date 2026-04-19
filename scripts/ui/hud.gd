extends CanvasLayer

@onready var res_label = $Resources
@onready var sel_label = $SelectedUnit

func _process(delta):
	update_resources()
	update_selection()

func update_resources():
	if Engine.has_singleton("ResourceManager"):
		var rm = ResourceManager
		res_label.text = "Gold: %d  Wood: %d" % [rm.gold, rm.wood]

func update_selection():
	if Engine.has_singleton("SelectionManager"):
		var sel = SelectionManager.get_primary_selection()
		if sel:
			sel_label.text = "Selected: %s (HP: %.0f)" % [sel.UnitName, sel.GetCurrentHp()]
		else:
			sel_label.text = "Selected: None"
