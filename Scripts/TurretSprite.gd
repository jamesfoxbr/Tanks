extends Sprite2D

func _physics_process(delta):
	var m = get_global_mouse_position()
	var aim_speed = deg_to_rad(2)			# controls the turret rotation/aim speed
	if get_angle_to(m) > 0:
		rotation += aim_speed
	else:
		rotation -= aim_speed

