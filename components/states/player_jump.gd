class_name PlayerJump
extends State

func enter() -> void:
	entity.coyote_timer = 0.0
	entity.jump_buffer_timer = 0.0
	entity.can_use_coyote = false
	entity.velocity.y = entity.jump_velocity
	entity.animated_sprite.play("jump")


func process(delta: float) -> void:
	var direction = handle_horizontal_movement(delta, true)
	handle_variable_jump(delta)
	
	if entity.velocity.y >= 0:
		sm.switch(entity.States.FALL)
	
	entity.move_and_slide()


func handle_variable_jump(delta: float) -> void:
	if is_jump_released() and entity.velocity.y < 0 and entity.allow_variable_jump_height:
		entity.velocity.y = move_toward(entity.velocity.y, 0.0, entity.jump_cut_speed)
	elif entity.disable_gravity_timer > 0.0:
		entity.disable_gravity_timer -= delta
	else:
		entity.velocity.y += entity.jump_gravity * delta


func is_jump_released() -> bool:
	return Input.is_action_just_released("jump")
