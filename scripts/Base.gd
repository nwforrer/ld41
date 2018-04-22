extends Area2D

signal base_destroyed

const MOB_BIT = 1

export (int) var health

func _ready():
	spawn_health_sprites()
	
func spawn_health_sprites():
	var health_texture = load('res://textures/health.png')
	for health_index in health:
		var health_sprite = Sprite.new()
		health_sprite.texture = health_texture
		health_sprite.position.y = -$Sprite.texture.get_height()/2 - 5 - (2*health_index*health_texture.get_height())
		health_sprite.name = str("BaseHealthSprite",health_index)
		add_child(health_sprite)

func _on_Base_body_entered(body):
	if body.collision_layer & MOB_BIT:
		body.get_parent().queue_free()
		get_node(str("BaseHealthSprite",(health-1))).queue_free()
		
		health -= 1
		if health == 0:
			emit_signal("base_destroyed")