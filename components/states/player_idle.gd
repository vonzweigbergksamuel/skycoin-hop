class_name PlayerIdle
extends State

func enter() -> void:
	entity.animated_sprite.play("idle")


func process(delta: float) -> void:
	entity.velocity.x = move_toward(entity.velocity.x, 0, entity.speed)
	
	if not entity.is_on_floor():
		sm.switch(entity.States.FALL)
	
	if Input.is_action_just_pressed("jump") and entity.is_on_floor():
		sm.switch(entity.States.JUMP)
	elif abs(Input.get_axis("move_left", "move_right")) > 0:
		sm.switch(entity.States.RUN)
