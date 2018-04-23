extends StaticBody2D

signal tower_selected
signal tower_unselected

export (bool) var is_built = true

const MOB_BIT = 1
const PLAYER_BIT = 4

var active_bodies = []
var can_fire = false
var is_upgraded = false
var is_highlighted = false

func _ready():
	if is_built:
		$Base.hide()
		$Tower.show()
	else:
		$Base.show()
		$Tower.hide()
		
	$ArrowSprite.hide()

func _process(delta):
	if is_built and can_fire and active_bodies.size() > 0:
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
	print('upgrading..isbuilt:', is_built, ' isupgraded:', is_upgraded)
	if not is_built:
		$Base.hide()
		$Tower.show()
		is_built = true
		return true
	elif not is_upgraded:
		$FireTimer.wait_time = 1
		is_upgraded = true
		spawn_upgrade_sprite()
		return true
	return false

func spawn_upgrade_sprite():
	var health_texture = load('res://textures/health.png')
	var health_sprite = Sprite.new()
	health_sprite.texture = health_texture
	health_sprite.position.y = -$Tower.texture.get_height()/2 - 5 - (2*health_texture.get_height())
	health_sprite.name = str(get_name(), "HealthSprite")
	add_child(health_sprite)

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


func _on_PlayerSelectRange_body_entered(body):
	if not is_highlighted and body.collision_layer & PLAYER_BIT:
		emit_signal("tower_selected", self)
		$ArrowSprite.show()
		is_highlighted = true

func _on_PlayerSelectRange_body_exited(body):
	if is_highlighted and body.collision_layer & PLAYER_BIT:
		emit_signal("tower_unselected", self)
		$ArrowSprite.hide()
		is_highlighted = false
