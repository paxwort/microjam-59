class_name CharacterController
extends CharacterBody3D

@onready var _healthComponent: HealthComponent = $HealthComponent
@onready var _movementComponent: MovementComponent = $MovementComponent

func _ready() -> void:
	var target = Vector3(10, 0, 5)
	_movementComponent.move_to_location(target)
	print_debug("Current health: %s" % _healthComponent.get_health())
	

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print_debug("Click detected")
		var camera: Camera3D = get_viewport().get_camera_3d() 
		if not camera:
			push_warning("Point and Click failed: No active Camera3D found in the viewport.")
			return
		
		var mouse_pos: Vector2 = event.position
		var ray_origin: Vector3 = camera.project_ray_origin(mouse_pos)
		var ray_direction: Vector3 = camera.project_ray_normal(mouse_pos)
		var ray_end: Vector3 = ray_origin + ray_direction * 1000.0 
		
		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
		query.exclude = [self.get_rid()]

		var result = space_state.intersect_ray(query)
		if result:
			_movementComponent.move_to_location(result.position)
