class_name DamageArea
extends Area3D

@export var DamageDealt: float = 1
@export var TimeBetweenDamage: float = 2
@export var GroupsToAttack: Array[String] = []

var _damageTimer: Timer
var _canAttack: bool = false

var _enemies_in_area: Array[CharacterBody3D] = []


func _ready() -> void:
	_damageTimer = Timer.new()
	add_child(_damageTimer)
	
	_damageTimer.wait_time = TimeBetweenDamage
	_damageTimer.one_shot = true
	_damageTimer.timeout.connect(_resetAttack)
	_damageTimer.start()
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(_delta: float) -> void:
	if _canAttack && _enemies_in_area.size() > 0:
		_attack()
		
func _resetAttack() -> void:
	_canAttack = true

func _attack() -> void:
	if _enemies_in_area.size() > 0:
		var target = _enemies_in_area[0]
		target.take_damage(DamageDealt)
		_canAttack = false
		_damageTimer.start()
	
func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D && _body_is_target(body):
		var healthComponent = body.get_node_or_null("HealthComponent")
		if healthComponent:
			_enemies_in_area.append(body) 

func _on_body_exited(body: Node3D) -> void:
	if body is CharacterBody3D and _enemies_in_area.has(body):
		_enemies_in_area.erase(body)
		
func _body_is_target(body: Node3D) -> bool:
	for group in GroupsToAttack:
		if body.is_in_group(group):
			return true
	return false
