class_name PlayerRun
extends State

func enter() -> void:
	entity.animated_sprite.play("run")


func process(delta: float) -> void:
	var direction = handle_horizontal_movement(delta, false)
	
	if not entity.is_on_floor():
		sm.switch(entity.States.FALL)
	elif direction == 0 and abs(entity.velocity.x) < 10:
		sm.switch(entity.States.IDLE)
	elif Input.is_action_just_pressed("jump") and entity.is_on_floor():
		sm.switch(entity.States.JUMP)
	
	entity.move_and_slide()
