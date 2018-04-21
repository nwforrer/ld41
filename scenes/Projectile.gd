extends KinematicBody2D

export (int) var speed
var direction

const MOB_BIT = 1

func spawn(initial_velocity):
	direction = initial_velocity.normalized()

func _physics_process(delta):
	var collision_info = move_and_collide(direction*speed*delta)
	if collision_info:
		print('collided:', collision_info.collider.get_name())
		var collider = collision_info.collider
		var collider_layers = collision_info.collider.collision_layer
		if collider_layers & MOB_BIT:
			collider.get_parent().queue_free()
		
		queue_free()

	
func _on_LifeTimer_timeout():
	queue_free()
