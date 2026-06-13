class_name DetectionComponent
extends Area3D

signal player_entered_area(player: Node3D)
signal player_lost()

var current_target: Node3D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Chickens"):
		player_entered_area.emit(body)

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("Chickens"):
		player_lost.emit()
