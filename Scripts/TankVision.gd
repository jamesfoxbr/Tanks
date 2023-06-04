extends RayCast2D

@onready var player_tank: Node2D = $".."

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	target_position = player_tank.player_tank.global_position
