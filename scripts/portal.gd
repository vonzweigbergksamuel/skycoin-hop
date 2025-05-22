extends Area2D

signal level_exit_triggered

func _ready():
	monitoring = false

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		emit_signal("level_exit_triggered")
