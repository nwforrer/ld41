extends Area2D

signal base_destroyed

const MOB_BIT = 1

export (int) var health

func _on_Base_body_entered(body):
	if body.collision_layer & MOB_BIT:
		print('base hit')
		body.get_parent().queue_free()
		
		health -= 1
		if health == 0:
			emit_signal("base_destroyed")