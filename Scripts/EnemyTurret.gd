extends Sprite2D
#@export var player_tank: Node2D
@onready var player_tank: Node2D = $".."

func _ready():
	pass

func _physics_process(delta):
#	print(player_tank.player_tank.position)
	var m = player_tank.player_tank.position
	var aim_speed = deg_to_rad(2)			# controls the turret rotation/aim speed
	if get_angle_to(m) > 0:
		rotation += aim_speed
	else:
		rotation -= aim_speed
