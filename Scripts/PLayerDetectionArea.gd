extends Area2D

@onready var tank = get_node(".") 
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if body_entered:
		tank.set_physics_process(false)
		tank.set_process(false)
#	set_physics_process(false)
#	set_process(false)
