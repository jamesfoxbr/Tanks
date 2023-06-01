extends CharacterBody2D

@onready var player_tank: Node2D = $"../Tank"

var HP = 100

@onready var Bullet = preload("res://Scenes/bullet.tscn")
@onready var HPText = $HPText

var speed = 0
@export var max_speed = 40

var angular_speed = PI

@export var acceleration = 30
@export var deceleration = 20

@export var max_handling: float = 1

var direction = 0

var shot_time: float = 10
var rate_of_fire: float = 1


func _ready():
	pass

func _physics_process(delta):
	
#	movement(delta)
	decelerate(delta)
	collision()
	speed_limits()
	move_and_slide()
	
	# Displays HP above the tank
	HPText.text = str(HP)
	HPText.rotation = -rotation
	
	# tank shoting on player
	if shot_time >= 1:
		shoot(delta)
		shot_time = 0
	if shot_time < 1:
		shot_time += rate_of_fire * delta


func shoot(delta):	
	var b = Bullet.instantiate()
	owner.add_child(b)

	b.transform = $TurretSprite/Muzzle.global_transform
	b.position += transform.y * randf_range(-300,300) * delta


func movement(delta):
	var handling: float = 2.5
	if Input.is_action_pressed("ui_left"):
		direction -= handling * delta
	if Input.is_action_pressed("ui_right"):
		direction += handling * delta
	
	direction = clamp(direction, -1 , 1)
	
	rotation += angular_speed * direction * delta
	handling_stabilization(delta)
	
	if Input.is_action_pressed("ui_up"):
		speed += acceleration * delta
	if Input.is_action_pressed("ui_down"):
		speed -= acceleration * delta
	
	velocity = Vector2.UP.rotated(rotation) * speed 
	position += velocity * delta
	

# Make the tank react better when colliding against something.
func collision():	
	if move_and_slide():
		speed *= 0.8
		angular_speed = PI / 2
		HP -= floor(abs(speed / 20))

	if !move_and_slide():
		angular_speed = PI
	
	tank_die()

func tank_die():
	if HP <= 0:
		set_physics_process(false)
		set_process(false)
		modulate = Color.BLACK
		get_node("TurretSprite").set_physics_process(false)
		get_node("TurretSprite").set_process(false)
		await get_tree().create_timer(3).timeout
		queue_free()

# decelerate the tank speed not accelerating front or to rear
func decelerate(delta):
	if not Input.is_action_pressed("ui_up") and not Input.is_action_pressed("ui_down"):
		if speed > 0:
			speed -= deceleration * delta
		if speed < 0:
			speed += deceleration * delta
		if speed <= 0.9 and speed >= 0:
			speed = 0


# make the tank handling looks more natural e take some time to recover after stop handling
func handling_stabilization(delta):
	var handling_stabilize = 2
	if not Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
		if direction > 0:
			direction -= handling_stabilize * delta
		if direction < 0:
			direction += handling_stabilize * delta
		if direction > -0.0099 and direction < 0.0099:
			direction = 0


# determines the maximum tank speed limit.
func speed_limits():
	if speed > max_speed:
		speed = max_speed

func take_damage(d):
	HP -= d
