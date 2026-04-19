extends Node

@export var grunt_scene: PackedScene
@export var warlock_scene: PackedScene
@export var spawn_position := Vector3(10, 0, 0)
@export var wave_interval := 20.0

var game_root: Node3D
var target_unit = null
var timer := 0.0

func setup(root: Node3D, primary_target) -> void:
	game_root = root
	target_unit = primary_target

func _process(delta: float) -> void:
	timer += delta
	if timer >= wave_interval:
		timer = 0.0
		spawn_attack_wave()

func spawn_attack_wave() -> void:
	if game_root == null or target_unit == null:
		return
	if not is_instance_valid(target_unit):
		return

	if grunt_scene:
		var grunt = grunt_scene.instantiate()
		grunt.position = spawn_position
		game_root.add_child(grunt)
		grunt.AttackTarget(target_unit)

	if warlock_scene:
		var warlock = warlock_scene.instantiate()
		warlock.position = spawn_position + Vector3(1.5, 0, 0)
		game_root.add_child(warlock)
		warlock.AttackTarget(target_unit)
