extends CharacterBody2D
class_name Tank

var HP: int = 100

@onready var particles = $TankExplosion
@onready var turret_sprite = $TurretSprite
@onready var body_sprite = $BodySprite
@onready var Bullet = preload("res://Scenes/bullet.tscn")
@onready var shot = $ShotAudio

var speed = 0
var max_speed: float

var  angular_speed = PI

var acceleration: float
var deceleration: float

var max_handling: float

var direction = 0

var shot_time: float
var rate_of_fire: float

func shooting(delta):
	if Input.is_action_pressed("shoot") and shot_time >= 1:
		shoot(delta)
		shot_time = 0
	if shot_time < 1:
		shot_time += rate_of_fire * delta

func shoot(delta):	
	var b = Bullet.instantiate()
	owner.add_child(b)
	
	b.transform = $TurretSprite/Muzzle.global_transform
	b.position += transform.y * delta
	shot.play()

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
		particles.emitting = true
		get_node("TurretSprite").set_physics_process(false)
		get_node("TurretSprite").set_process(false)
		await get_tree().create_timer(3).timeout
		get_tree().reload_current_scene()

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

func take_damage(d):
	HP -= d
	turret_sprite.use_parent_material = true
	body_sprite.use_parent_material = true
	await get_tree().create_timer(0.1).timeout
	turret_sprite.use_parent_material = false
	body_sprite.use_parent_material = false

# determines the maximum tank speed limit.
func speed_limits():
	if speed > max_speed:
		speed = max_speed


