extends CanvasLayer

@onready var panel = $Panel
@onready var title = $Panel/Title
@onready var button = $Panel/RestartButton

func _ready():
	panel.visible = false
	button.pressed.connect(_on_restart)

func show_victory():
	panel.visible = true
	title.text = "VICTORY"

func show_defeat():
	panel.visible = true
	title.text = "DEFEAT"

func _on_restart():
	get_tree().reload_current_scene()
