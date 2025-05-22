class_name PlayerDeath
extends State

func enter() -> void:
	entity.velocity = Vector2.ZERO
	entity.set_physics_process(false)
	entity.animated_sprite.play("death")

	await entity.animated_sprite.animation_finished

	entity.set_physics_process(true)
	entity.emit_signal("died")
