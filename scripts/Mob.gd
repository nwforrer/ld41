extends PathFollow2D

export (int) var speed
export (int) var health

func _ready():
	spawn_health_sprites()

func spawn_health_sprites():
	var health_texture = load('res://textures/health.png')
	for health_index in health:
		var health_sprite = Sprite.new()
		health_sprite.texture = health_texture
		health_sprite.position.y = position.y - (40 + 2*health_index * health_texture.get_height())
		health_sprite.name = str("MobHealthSprite",health_index)
		add_child(health_sprite)

func _process(delta):
	set_offset(get_offset() + (speed*delta))

func projectile_hit():
	get_node(str("MobHealthSprite",(health-1))).queue_free()
	health -= 1
	if health == 0:
		queue_free()