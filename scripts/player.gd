class_name Player
extends CharacterBody2D

signal died

enum States { IDLE, RUN, RUN_STOP, JUMP, FALL, DASH, DEATH }

@export var animated_sprite: AnimatedSprite2D

@export_group("Movement Options")
@export var speed: float = 130.0
@export var ground_accel_speed: float = 6.0
@export var ground_decel_speed: float = 20.0
@export var air_accel_speed: float = 10.0
@export var air_decel_speed: float = 4.0
@export var jump_cut_speed: float = 120.0

@export_group("Jump Options")
@export var jump_height: float = 50.0
@export var time_to_peak: float = 0.4
@export var time_to_fall: float = 0.3

@export_group("Jump Feel Options")
@export var allow_variable_jump_height: bool = true
@export var variable_jump_gravity_multiplier: float = 5.0
@export var coyote_time: float = 0.1
@export var jump_buffer_time: float = 0.1

# --- Physics-calculated values ---
var jump_velocity: float
var jump_gravity: float
var fall_gravity: float
var variable_jump_gravity: float

# --- Runtime state ---
var jump_buffer_timer: float = 0.0
var coyote_timer: float = 0.0
var can_use_coyote: bool = true
var was_on_floor: bool = false
var disable_gravity_timer := 0.0
var spawn_position: Vector2

# --- State machine references ---
var idle_state: PlayerIdle
var run_state: PlayerRun
var jump_state: PlayerJump
var fall_state: PlayerFall
var dash_state: PlayerDash
var death_state: PlayerDeath
var sm: StateMachine

func _ready() -> void:
	spawn_position = global_position
	
	# Calculate physics values
	jump_velocity = -2.0 * jump_height / time_to_peak
	jump_gravity = 2.0 * jump_height / pow(time_to_peak, 2)
	fall_gravity = 2.0 * jump_height / pow(time_to_fall, 2)
	variable_jump_gravity = jump_gravity * variable_jump_gravity_multiplier

	# Init state machine
	sm = StateMachine.new({})
	
	idle_state = PlayerIdle.new(self, sm)
	run_state = PlayerRun.new(self, sm)
	jump_state = PlayerJump.new(self, sm)
	fall_state = PlayerFall.new(self, sm)
	dash_state = PlayerDash.new(self, sm)
	death_state = PlayerDeath.new(self, sm)
	
	sm.states = {
		States.IDLE: {
			StateMachine.PROCESS: idle_state.process,
			StateMachine.ENTER: idle_state.enter,
			StateMachine.EXIT: idle_state.exit
		},
		States.RUN: {
			StateMachine.PROCESS: run_state.process,
			StateMachine.ENTER: run_state.enter,
			StateMachine.EXIT: run_state.exit
		},
		States.JUMP: {
			StateMachine.PROCESS: jump_state.process,
			StateMachine.ENTER: jump_state.enter,
			StateMachine.EXIT: jump_state.exit
		},
		States.FALL: {
			StateMachine.PROCESS: fall_state.process,
			StateMachine.ENTER: fall_state.enter,
			StateMachine.EXIT: fall_state.exit
		},
		States.DASH: {
			StateMachine.PROCESS: dash_state.process,
			StateMachine.ENTER: dash_state.enter,
			StateMachine.EXIT: dash_state.exit
		},
		States.DEATH: {
			StateMachine.PROCESS: death_state.process,
			StateMachine.ENTER: death_state.enter,
			StateMachine.EXIT: death_state.exit
		}
	}
	
	sm.switch(States.IDLE)


func _physics_process(delta: float) -> void:
	sm.process(delta)

	# Update jump buffer + coyote timers
	if is_on_floor() and not was_on_floor:
		coyote_timer = coyote_time
		can_use_coyote = true
	
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer_time

	jump_buffer_timer = maxf(jump_buffer_timer - delta, 0.0)
	coyote_timer = maxf(coyote_timer - delta, 0.0)

	was_on_floor = is_on_floor()


func respawn() -> void:
	await get_tree().create_timer(1.0).timeout
	global_position = spawn_position
	velocity = Vector2.ZERO
	animated_sprite.rotation_degrees = 0
	sm.switch(States.IDLE)
	get_tree().reload_current_scene()


func die() -> void:
	if sm.current != sm.states[States.DEATH]:
		sm.switch(States.DEATH)
