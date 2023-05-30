extends CharacterBody2D

@onready var Bullet = preload("res://Scenes/bullet.tscn")

var speed = 0
@export var max_speed = 40

var angular_speed = PI

@export var acceleration = 30
@export var deceleration = 20

@export var max_handling: float = 1

var direction = 0


func _process(delta):
	movement(delta)
	decelerate(delta)
	collision()
	speed_limits()
	move_and_slide()
	
	if Input.is_action_pressed("shoot"):
		shoot(delta)


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
	
	debug_panel(direction)


func collision():	
	if move_and_slide():
		speed *= 0.8
		angular_speed = PI / 2
	if !move_and_slide():
		angular_speed = PI


func decelerate(delta):
	if not Input.is_action_pressed("ui_up") and not Input.is_action_pressed("ui_down"):
		if speed > 0:
			speed -= deceleration * delta
		if speed < 0:
			speed += deceleration * delta
		if speed <= 0.9 and speed >= 0:
			speed = 0


func handling_stabilization(delta):
	var handling_stabilize = 2
	if not Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
		if direction > 0:
			direction -= handling_stabilize * delta
		if direction < 0:
			direction += handling_stabilize * delta
		if direction > -0.0099 and direction < 0.0099:
			direction = 0


func speed_limits():
	if speed > max_speed:
		speed = max_speed


func debug_panel(handling):
	$TankUI/Speed.text = "Debug 
	Speed: " + str(speed) + "
	Direction: " + str(handling)

