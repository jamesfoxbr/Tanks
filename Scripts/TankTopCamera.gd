extends Camera2D

@export var zoom_increment: float = 1
@export var zoom_current: float = 1 
@export var zoom_target: float = 1

func _ready():
	pass

func _process(delta):
	if(Input.is_action_just_released("zoom_in")):
		zoom_target = zoom_current + zoom_increment

	if(Input.is_action_just_released("zoom_out")):
		zoom_target = zoom_current - zoom_increment

	zoom_current = lerp(zoom_current, zoom_target, zoom_increment * delta)
	
	if zoom_current < 1.5:	# control maximum zoom
		zoom_current = 1.5
	if zoom_current > 4:	# control minimum zoom
		zoom_current = 4
	
	set_zoom(Vector2(zoom_current, zoom_current))
	
	# Makes the camera follow the mouse position
	var mouse_camera = Vector2(get_local_mouse_position())
	position = mouse_camera / 4
