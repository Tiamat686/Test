extends Node3D

@onready var camera = $Camera3D
@onready var peasant = $Peasant
@onready var mine = $GoldMine
@onready var town = $TownHall
@onready var footman = $Footman
@onready var grunt = $Grunt

func _ready():
	print("Stonecraft Game started (3D mode)")
	peasant.SetMine(mine)
	peasant.SetTownHall(town)

func _input(event):
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

				if collider.get_parent() == mine and selected.has_method("Gather"):
					selected.Gather()
				elif collider.get_parent() is CharacterBody3D:
					selected.AttackTarget(collider.get_parent())
				else:
					selected.MoveTo(result["position"])
