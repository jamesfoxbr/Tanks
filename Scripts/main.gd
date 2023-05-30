extends Node2D

func _ready():
	set_process(true)

func _process(delta):
	if Input.is_action_pressed("ui_cancel"):	# Quit the game when press Esc
		get_tree().quit()
	if Input.is_action_pressed("reset"):		# Restart the current scene when press F5
		get_tree().reload_current_scene()
