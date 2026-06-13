class_name EnemyController
extends CharacterBody3D

@onready var _healthComponent: HealthComponent = $HealthComponent
@onready var _movementComponent: MovementComponent = $MovementComponent
@onready var _detectionComponent: DetectionComponent = $DetectionComponent

enum State { PATROLLING, HUNTING, ATTACKING }

var _targetPlayer: Node3D

var _state: State

var _patrolTargetLocation: Vector3


func _ready() -> void:
	_targetPlayer = null
	_state = State.PATROLLING
	
	_healthComponent.health_depleted.connect(_kill_unit)
	_detectionComponent.player_entered_area.connect(_start_pursuit)
	_detectionComponent.player_lost.connect(_end_pursuit)

func _process(_delta: float) -> void:
	if _state == State.HUNTING && _targetPlayer:
		# TODO: Change to have periodic updates to location chase, not every frame
		_movementComponent.move_to_location(_targetPlayer.global_position)
	if _state == State.PATROLLING && _movementComponent.is_at_target_location():
		_start_patrol()

func _start_pursuit(player: Node3D) -> void:
	if _targetPlayer:
		pass
	_targetPlayer = player
	_state = State.HUNTING
	_movementComponent.move_to_location(_targetPlayer.global_position)

func _end_pursuit() -> void:
	_targetPlayer = null
	_state = State.PATROLLING
	_start_patrol()
	
func _start_patrol() -> void:
	var xPos = randf_range(-18, 18)
	var zPos = randf_range(-18, 18)
	_patrolTargetLocation = Vector3(xPos, 0, zPos)
	_movementComponent.move_to_location(_patrolTargetLocation)
	

func take_damage(damage: float) -> void:
	_healthComponent.remove_health(damage)
	
func _kill_unit() -> void:
	get_parent().queue_free()
