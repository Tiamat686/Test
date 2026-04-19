extends Node3D

@onready var camera = $Camera3D
@onready var peasant = $Peasant
@onready var mine = $GoldMine
@onready var town = $TownHall
@onready var footman = $Footman
@onready var wizard = $Wizard
@onready var ai = $AIController

var ability_mode = false

func _ready():
	print("Stonecraft Game started (3D mode)")
	peasant.SetMine(mine)
	peasant.SetTownHall(town)

	ai.setup(self, footman)

func _process(delta):
	check_game_state()

func check_game_state():
	var player_units_alive = false
	var enemies_alive = false

	for child in get_children():
		if child is CharacterBody3D:
			if child.Faction == "Human":
				player_units_alive = true
			if child.Faction == "Orc":
				enemies_alive = true

	if not player_units_alive:
		GameState.lose()

	if not enemies_alive:
		GameState.win()

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.is_action_pressed("ability_primary"):
			ability_mode = true

	if event is InputEventMouseButton and event.pressed:
		var ray_origin = camera.project_ray_origin(event.position)
		var ray_dir = camera.project_ray_normal(event.position)
		var space = get_world_3d().direct_space_state

		var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_origin + ray_dir * 1000)
		var result = space.intersect_ray(query)

		if result:
			var collider = result["collider"]

			if event.button_index == MOUSE_BUTTON_LEFT:
				if collider.get_parent() is CharacterBody3D:
					SelectionManager.select_single(collider.get_parent())
				else:
					SelectionManager.clear_selection()

			if event.button_index == MOUSE_BUTTON_RIGHT:
				var selected = SelectionManager.get_primary_selection()
				if not selected:
					return

				if ability_mode and collider.get_parent() is CharacterBody3D:
					selected.CastPrimaryAbilityOn(collider.get_parent())
					ability_mode = false
					return

				if collider.get_parent() == mine and selected.has_method("Gather"):
					selected.Gather()
				elif collider.get_parent() is CharacterBody3D:
					selected.AttackTarget(collider.get_parent())
				else:
					selected.MoveTo(result["position"])
