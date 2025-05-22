extends CanvasLayer

func set_lives(lives: int):
	$MarginContainer/VBoxContainer/LivesLabel.text = "x%d ❤️" % lives


func set_level(level_number: int):
	$MarginContainer/VBoxContainer/LevelLabel.text = "Level %d" % level_number
