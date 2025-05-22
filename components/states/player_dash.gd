class_name PlayerDash
extends State

var dash_timer := 0.0
const DASH_DURATION := 0.2
const DASH_SPEED := 500.0
var dash_direction := 1

func enter() -> void:
	print("Entering DASH state")
	entity.animated_sprite.play("dash")

	dash_timer = 0.0

	# Determine facing direction
	if abs(entity.velocity.x) > 0:
		dash_direction = sign(entity.velocity.x)
	else:
		dash_direction = 1 if entity.animated_sprite.scale.x > 0 else -1

	# Set dash velocity
	entity.velocity = Vector2(DASH_SPEED * dash_direction, 0)

func exit() -> void:
	print("Exiting DASH state")

func process(delta: float) -> void:
	dash_timer += delta

	# Continue moving in dash direction
	entity.velocity = Vector2(DASH_SPEED * dash_direction, 0)

	entity.move_and_slide()

	if dash_timer >= DASH_DURATION:
		if entity.is_on_floor():
			sm.switch(entity.States.IDLE)
		else:
			sm.switch(entity.States.FALL)
