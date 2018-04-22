extends StaticBody2D

signal tower_selected

const MOB_BIT = 1

var active_bodies = []
var can_fire = false
var is_upgraded = false

func _process(delta):
	if can_fire and active_bodies.size() > 0:
		var selected_mob = active_bodies[0]
		var vector_to_mob = (selected_mob.global_position - global_position).normalized()
		
		var projectile = load("res://scenes/Projectile.tscn").instance()
		projectile.spawn(vector_to_mob)
		projectile.connect("projectile_hit", get_parent(), "on_projectile_hit")
		add_child(projectile)
		
		$Shot.play()
		
		$FireTimer.start()
		can_fire = false

func upgrade():
	if not is_upgraded:
		$FireTimer.wait_time = 1
		is_upgraded = true
		spawn_upgrade_sprite()
		return true
	return false

func spawn_upgrade_sprite():
	var health_texture = load('res://textures/health.png')
	var health_sprite = Sprite.new()
	health_sprite.texture = health_texture
	health_sprite.position.y = -$Sprite.texture.get_height()/2 - 5 - (2*health_texture.get_height())
	health_sprite.name = str(get_name(), "HealthSprite")
	add_child(health_sprite)

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.pressed:
		print('upgrading tower:', name)
		emit_signal('tower_selected', self)

func _on_FireTimer_timeout():
	$FireTimer.stop()
	can_fire = true

func _on_Area2D_body_entered(body):
	if body.collision_layer & MOB_BIT:
		active_bodies.append(body)

func _on_Area2D_body_exited(body):
	var body_index = active_bodies.find(body)
	if body_index >= 0:
		active_bodies.remove(body_index)
