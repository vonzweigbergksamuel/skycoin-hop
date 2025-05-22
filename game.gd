class_name Game
extends Node2D

signal all_coins_collected

@onready var hud := $HUD

var levels := [
	"res://levels/level_1.tscn",
	"res://levels/level_2.tscn"
]

var current_level_index := 0
var level: Node2D
var player: Player

var total_lives := 5
var current_lives := total_lives

var total_coins := 0
var coins_collected := 0

func _ready():
	current_lives = total_lives
	load_level(current_level_index)


func load_level(index: int):
	# Cleanup old level
	if level:
		remove_child(level)
		level.queue_free()
		# Wait for old level to get cleanup up. Not having this caused me a bug before :(
		await get_tree().process_frame

	# Load new level
	var scene = load(levels[index])
	level = scene.instantiate()
	add_child(level)
	level.name = "Level"

	# Get player
	player = level.get_node("Player")
	player.died.connect(on_player_died)

	# Setup portal
	var portal = level.get_node("Portal")
	portal.level_exit_triggered.connect(on_level_complete)
	portal.visible = false
	portal.monitoring = false

	# Setup coins
	total_coins = 0
	coins_collected = 0
	for coin in level.get_tree().get_nodes_in_group("coins"):
		register_coin(coin)

	# Update HUD
	hud.set_lives(current_lives)
	hud.set_level(current_level_index + 1)


func register_coin(coin: Node):
	total_coins += 1
	coin.connect("collected", _on_coin_collected)


func _on_coin_collected():
	coins_collected += 1
	
	if coins_collected == total_coins:
		emit_signal("all_coins_collected")
		show_portal()


func show_portal():
	if level.has_node("Portal"):
		var portal = level.get_node("Portal")
		portal.visible = true
		portal.monitoring = true
	else:
		print("🚫 No portal found!")



func on_level_complete():
	current_level_index += 1

	if current_level_index < levels.size():
		load_level(current_level_index)
	else:
		print("🎉 You won!")
		get_tree().change_scene_to_file("res://win_screen.tscn")


func on_player_died():
	current_lives -= 1
	print("💀 Player died. Lives left: ", current_lives)
	hud.set_lives(current_lives)
	
	if current_lives > 0:
		load_level(current_level_index)
	else:
		print("Game Over")
		get_tree().change_scene_to_file("res://menu.tscn")


func _unhandled_input(event):
	if event.is_action_pressed("escape"):
		get_tree().change_scene_to_file("res://menu.tscn")
