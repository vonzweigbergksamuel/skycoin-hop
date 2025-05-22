class_name PlayerFall
extends State

func enter() -> void:
	entity.animated_sprite.play("fall")


func process(delta: float) -> void:
	var direction = handle_horizontal_movement(delta, true)

	entity.velocity.y += entity.fall_gravity * delta

	# Jump buffering + coyote logic
	if can_use_buffered_jump():
		entity.jump_buffer_timer = 0.0
		entity.coyote_timer = 0.0
		entity.can_use_coyote = false
		sm.switch(entity.States.JUMP)
	
	elif entity.is_on_floor():
		if direction != 0:
			sm.switch(entity.States.RUN)
		else:
			sm.switch(entity.States.IDLE)
	
	entity.move_and_slide()


func can_use_buffered_jump() -> bool:
	return (
		entity.jump_buffer_timer > 0.0
		and entity.can_use_coyote
		and entity.coyote_timer > 0.0
		and Input.is_action_just_pressed("jump")
	)
