class_name PlayerRunStop
extends State

func enter() -> void:
	entity.animated_sprite.play("run_stop")


func process(delta: float) -> void:
	entity.velocity.x = move_toward(entity.velocity.x, 0, entity.ground_decel_speed)
	
	if abs(entity.velocity.x) < 10:
		sm.switch(entity.States.IDLE)
	elif not entity.is_on_floor():
		sm.switch(entity.States.FALL)
	elif Input.is_action_just_pressed("jump") and entity.is_on_floor():
		sm.switch(entity.States.JUMP)
	
	entity.move_and_slide()
