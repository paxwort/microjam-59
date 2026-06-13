class_name CharacterController
extends CharacterBody3D

@onready var _healthComponent: HealthComponent = $HealthComponent
@onready var _movementComponent: MovementComponent = $MovementComponent

func _ready() -> void:
	print_debug("Current health: %s" % _healthComponent.get_health())
	var target = Vector3(10, 0, -5)
	_movementComponent.move_to_location(target)
	
