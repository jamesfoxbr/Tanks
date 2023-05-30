extends Camera2D

var zoom_increment: float = 2
var zoom_current: float = 1 
var zoom_target: float = 1

func _ready():
	pass

func _process(delta):
	if(Input.is_action_just_released("zoom_in")):
		zoom_target = zoom_current + zoom_increment

	if(Input.is_action_just_released("zoom_out")):
		zoom_target = zoom_current - zoom_increment

	zoom_current = lerp(zoom_current, zoom_target, zoom_increment * delta)
	
	if zoom_current < 1:
		zoom_current = 1
	if zoom_current > 4:
		zoom_current = 4
	
	set_zoom(Vector2(zoom_current, zoom_current))
	
	
