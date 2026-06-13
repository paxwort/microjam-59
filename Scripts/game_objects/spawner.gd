class_name Spawner
extends Node3D

@export var SpawnDelay: float = 5
@export var SpawnCharacters: Array[PackedScene]
@export var SpawnPoint: Node3D

var _spawnTimer: Timer

func _ready() -> void:
	_spawnTimer = Timer.new()
	add_child(_spawnTimer)
	_spawnTimer.start(SpawnDelay)
	_spawnTimer.timeout.connect(_spawn_unit)

func _spawn_unit() -> void:
	if not _can_spawn():
		return
	var to_spawn = SpawnCharacters.pick_random()
	var new_character = to_spawn.instantiate()
	get_tree().current_scene.add_child(new_character)
	new_character.global_position = SpawnPoint.global_position

func _can_spawn() -> bool:
	# TODO: Make sure we don't spawn too many
	return true
