extends Node2D

func _ready():
	set_process(true)

@warning_ignore("unused_parameter")
func _process(delta):
	game_control()


func game_control():
	if Input.is_action_pressed("ui_cancel"):	# Quit the game when press Esc
		get_tree().quit()
	if Input.is_action_pressed("reset"):		# Restart the current scene when press F5
		get_tree().reload_current_scene()
