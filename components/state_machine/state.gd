class_name State
extends RefCounted

var entity: Player
var sm: StateMachine

func _init(e: CharacterBody2D, s: StateMachine) -> void:
	entity = e
	sm = s


func enter():
	pass


func exit():
	pass


func process(delta: float):
	pass


func handle_horizontal_movement(delta: float, is_airborne: bool = false) -> int:
	var direction = Input.get_axis("move_left", "move_right")
	var velocity_change_speed: float = 0.0
	
	if direction != 0:
		# Flip sprite based on direction
		var current_scale = abs(entity.animated_sprite.scale.x)
		entity.animated_sprite.scale.x = current_scale * (-1 if direction < 0 else 1)
		
		# Select appropriate acceleration
		velocity_change_speed = entity.air_accel_speed if is_airborne else entity.ground_accel_speed
	else:
		# Select appropriate deceleration
		velocity_change_speed = entity.air_decel_speed if is_airborne else entity.ground_decel_speed
	
	entity.velocity.x = move_toward(entity.velocity.x, direction * entity.speed, velocity_change_speed)
	
	# Return direction for states that need it
	return direction
