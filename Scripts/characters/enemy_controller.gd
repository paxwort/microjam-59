class_name EnemyController
extends CharacterBody3D

@onready var _healthComponent: HealthComponent = $HealthComponent
@onready var _movementComponent: MovementComponent = $MovementComponent
@onready var _detectionComponent: DetectionComponent = $DetectionComponent

var _target_player: Node3D
var _is_in_pursuit: bool = false

func _ready() -> void:
	_target_player = null
	_is_in_pursuit = false
	_detectionComponent.player_entered_area.connect(_start_pursuit)
	_detectionComponent.player_lost.connect(_end_pursuit)

func _process(delta: float) -> void:
	if _is_in_pursuit && _target_player:
		_movementComponent.move_to_location(_target_player.global_position)

func _start_pursuit(player: Node3D) -> void:
	if _target_player:
		pass
	_target_player = player
	_is_in_pursuit = true
	_movementComponent.move_to_location(_target_player.global_position)

func _end_pursuit() -> void:
	_target_player = null
	_is_in_pursuit = false
	_movementComponent.move_to_location(global_position)

func take_damage(damage: float) -> void:
	_healthComponent.remove_health(damage)
