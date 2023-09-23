extends Tank

func _ready():
	# setting up tank variables
	acceleration = 30
	deceleration = 20
	max_handling = 1
	max_speed = 40
	shot_time = 10
	rate_of_fire = 15
	

func _process(delta):
	
	movement(delta)
	decelerate(delta)
	collision()
	speed_limits()
	move_and_slide()
	
	tank_die()
	shooting(delta) 
	
#	$TankUI/Speed.text = "HP: " + str(HP) + "
#	WASD to move / mouse to aim and shot
#	Esc close the game 
#	F5 restart the game"



