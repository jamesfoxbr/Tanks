extends CharacterBody2D

@onready var player_tank: Node2D = $"../Tank"

var HP = 100	#total tank hitpoints

@onready var particles = $TankExplosion
@onready var Bullet = preload("res://Scenes/EnemyBullet.tscn")
@onready var turret_sprite = $TurretSprite
@onready var body_sprite = $EnemyTankSprite

# variables of the navigation/pathfinding code
@export var movement_speed: float = 60.0			# pathfinding speed
@export var movement_target: Node2D
@export var navigation_agent: NavigationAgent2D

# variabes for shooting
var time_between_shots: float = 10
var rate_of_fire: float = 5
var shot_cooldown_time: float = 2
var time_shooting: float = 2

func _ready():	
	enemy_active(false)
	
	# this is part of the navigation/pathfinding code
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	
	call_deferred("actor_setup")

func _process(delta):
	tank_die()
	face_to_enemy(delta)
	tank_shoot(delta, 2)
	
	# code below is part of the pathfinding code
	if navigation_agent.is_navigation_finished():
		return
	
	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	
	var new_velocity: Vector2 = next_path_position - current_agent_position
	new_velocity = new_velocity.normalized()
	new_velocity = new_velocity * movement_speed
	
	velocity = new_velocity
	move_and_slide()

func enemy_active(b):
	set_physics_process(b)
	set_process(b)
	turret_sprite.set_physics_process(b)
	turret_sprite.set_process(b)

# setups this entity to use the pathfinding
func actor_setup():
	await get_tree().physics_frame
	set_movement_target(movement_target.position)

func set_movement_target(target_point: Vector2):	
	navigation_agent.target_position = target_point

# variable used in the tank_shoot function below
var t = 0 
func tank_shoot(delta, time):
	if t >= shot_cooldown_time:
		if time_between_shots >= 1 and $TurretSprite/TankVision.is_colliding():
			shoot(delta)
			time_between_shots = 0
		if time_between_shots < 1:
			time_between_shots += rate_of_fire * delta
			call_deferred("actor_setup")
		await get_tree().create_timer(time_shooting).timeout
		t = 0
	t += delta

func face_to_enemy(delta):
	rotation = velocity.angle()

func shoot(delta):	
	var b = Bullet.instantiate()
	owner.add_child(b)

	b.transform = $TurretSprite/Muzzle.global_transform
	b.position += transform.y * delta

func tank_die():
	if HP <= 0:
		particles.emitting = true
		enemy_active(false)
		await get_tree().create_timer(3).timeout
		queue_free()

func take_damage(d):
	HP -= d
	turret_sprite.use_parent_material = true
	body_sprite.use_parent_material = true
	await get_tree().create_timer(0.1).timeout
	turret_sprite.use_parent_material = false
	body_sprite.use_parent_material = false

func _on_detection_area_body_entered(body):
	enemy_active(true)
