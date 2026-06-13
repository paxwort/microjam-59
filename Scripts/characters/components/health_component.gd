class_name HealthComponent
extends Node

signal health_depleted

@export var _baseHealth:float = 1
var _currentHealth:float = 1

func _ready() -> void:
	reset_health()

func add_health(amountToAdd: float) -> void:
	_currentHealth += amountToAdd

func remove_health(amountToRemove: float) -> void:
	_currentHealth -= amountToRemove
	_check_if_dead()

func reset_health() -> void:
	_currentHealth = _baseHealth
	
func get_health() -> float:
	return _currentHealth

func _check_if_dead() -> void:
	if _currentHealth <= 0:
		_currentHealth = 0
		health_depleted.emit()
