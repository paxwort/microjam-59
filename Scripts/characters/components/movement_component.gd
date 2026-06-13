class_name MovementComponent
extends Node3D

@onready var _navAgent: NavigationAgent3D = $"NavigationAgent3D"

@export var speed: float = 5.0
@export var parent: CharacterBody3D

func _ready() -> void:
	parent = get_parent()
	print_debug(_navAgent.radius)

func _physics_process(_delta: float) -> void:
	if not parent is CharacterBody3D:
		return
		
	if _navAgent.is_navigation_finished():
		parent.velocity = Vector3.ZERO
		parent.move_and_slide()
		return
	
	var current_pos = parent.global_position
	var target_pos = _navAgent.get_next_path_position()
	
	var direction = current_pos.direction_to(target_pos)
	direction.y = 0
	direction = direction.normalized()
	
	parent.velocity = direction * speed
	parent.move_and_slide()
	
func move_to_location(target_position: Vector3) -> void:
	_navAgent.target_position = target_position
