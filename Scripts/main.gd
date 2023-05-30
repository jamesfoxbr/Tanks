extends Node2D

func _ready():
	set_process(true)

func _process(delta):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	if Input.is_action_pressed("reset"):
		get_tree().reload_current_scene()
