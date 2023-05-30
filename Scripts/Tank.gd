extends CharacterBody2D

var speed = 0
@export var max_speed = 250

var angular_speed = PI

@export var acceleration = 100
@export var deceleration = 100

@export var max_handling: float = 1

var direction = 0

func _process(delta):
	movement(delta)
	speed_limits()
	decelerate(delta)
	collision()

func movement(delta):
	var handling: float = 1.5
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
	
func collision():
	if move_and_slide():
		speed = 0
		angular_speed = 0
	if !move_and_slide():
		angular_speed = PI

func decelerate(delta):
	if not Input.is_action_pressed("ui_up") and not Input.is_action_pressed("ui_down"):
		if speed > 0:
			speed -= deceleration * delta
		if speed < 0:
			speed += deceleration * delta

func handling_stabilization(delta):
	if not Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		if direction > 0:
			direction -= 0.5 * delta
		if direction < 0:
			direction += 0.5 * delta
		if direction > -0.0099 and direction < 0.0099:
			direction = 0

func speed_limits():
	if speed > max_speed:
		speed = max_speed



