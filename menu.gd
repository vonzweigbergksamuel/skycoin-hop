extends Control

func _ready():
	$PlayButton.pressed.connect(_on_play_button_pressed)
	
	var tween = create_tween().set_loops()
	tween.tween_property($PlayButton, "scale", Vector2(1.03, 1.03), 0.8)
	tween.tween_property($PlayButton, "scale", Vector2(1, 1), 0.8)

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://game.tscn")
