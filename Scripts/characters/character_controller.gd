class_name CharacterController
extends Node3D

@onready var _healthComponent: HealthComponent = $HealthComponent

func _ready() -> void:
	print_debug("Current health: %s" % _healthComponent.get_health())
