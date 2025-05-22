class_name StateMachine

enum {ENTER, EXIT, PROCESS}

var states: Dictionary
var current

func _init(s: Dictionary) -> void:
	states = s


func switch(new: int) -> void:
	var old = current
	current = states[new] if states.has(new) else null
	
	if current != old:
		if old and old.has(EXIT): old[EXIT].call()
		if current and current.has(ENTER): current[ENTER].call()


func process(delta: float) -> void:
	if current and current.has(PROCESS): current[PROCESS].call(delta)
