extends CharacterBody2D

@onready var player_tank: Node2D = $"../Tank"

var HP = 100	#total tank hitpoints

@onready var particles = $GPUParticles2D
@onready var Bullet = preload("res://Scenes/EnemyBullet.tscn")

# variables of the navigation/pathfinding code
@export var movement_speed: float = 60.0			# pathfinding speed
@export var movement_target: Node2D
@export var navigation_agent: NavigationAgent2D

var shot_time: float = 10				# used to control shot cooldown
var rate_of_fire: float = 5				# how many shots per second

func _ready():	
	# this is part of the navigation/pathfinding code
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	
	call_deferred("actor_setup")

func actor_setup():
	await get_tree().physics_frame
	set_movement_target(movement_target.position)
	await get_tree().create_timer(4).timeout 

func set_movement_target(target_point: Vector2):	
	navigation_agent.target_position = target_point

func _physics_process(delta):
	call_deferred("actor_setup")
	tank_die()
	face_to_enemy()
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

func tank_shoot(delta, time):
	# tank shoting on player
	if shot_time >= 1:
		shoot(delta)
		shot_time = 0
	if shot_time < 1:
		shot_time += rate_of_fire * delta

func face_to_enemy():
	rotation = atan2(velocity.y, velocity.x)

func shoot(delta):	
	var b = Bullet.instantiate()
	owner.add_child(b)

	b.transform = $TurretSprite/Muzzle.global_transform
	b.position += transform.y * delta

func tank_die():
	if HP <= 0:
		set_physics_process(false)
		set_process(false)
		particles.emitting = true
		get_node("TurretSprite").set_physics_process(false)
		get_node("TurretSprite").set_process(false)
		await get_tree().create_timer(3).timeout
		queue_free()

func take_damage(d):
	HP -= d
	modulate = Color.BLACK
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE
	

