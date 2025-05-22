extends Area2D

@export var bounce_strength: float = -400.0

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is Player and body.velocity.y >= 0:
		body.velocity.y = bounce_strength
		body.disable_gravity_timer = 0.1
		body.sm.switch(body.States.JUMP)
		$AnimatedSprite2D.play("bounce")
