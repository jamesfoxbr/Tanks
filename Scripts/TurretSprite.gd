@tool
extends Sprite2D
@export var turret_speed: int = 10

func _ready():
	pass

func _physics_process(delta):
	var m = get_global_mouse_position()
	var aim_speed = deg_to_rad(turret_speed)			# controls the turret rotation/aim speed
	if get_angle_to(m) > 0:
		rotation += aim_speed
	else:
		rotation -= aim_speed

