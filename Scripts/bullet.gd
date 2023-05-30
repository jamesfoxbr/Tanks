extends Area2D

var speed = 550
var max = 50


func _physics_process(delta):
	position += transform.x * speed * delta
	
	if not get_node("OnScreen").is_on_screen():
		queue_free()

func _on_Bullet_body_entered(body):
	if body.is_in_group("mobs"):
		body.queue_free()
	queue_free()
	
