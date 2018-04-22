extends Node

signal resources_updated

export (Array, NodePath) var paths = []

export (int) var mob_health_boost
export (int) var mob_speed_boost
export (int) var mob_spawn_boost

var resources_available
var resources_collected

var available_powerups = ['health', 'spawn', 'speed']
var current_powerups = []

# powerups?
# health
# shooting
#    range?
# speed

func _ready():
	randomize()
	
	resources_available = 0
	resources_collected = 0
	
	$RaceStartTimer.start()

func _on_MobSpawnTimer_timeout():
	if paths.size() > 0:
		var path = paths[randi()%paths.size()]
		var mob = load("res://scenes/Mob.tscn").instance()
		if current_powerups.has('speed'):
			mob.speed = mob_speed_boost
		if current_powerups.has('health'):
			mob.health = mob_health_boost
		get_node(path).add_child(mob)

func _on_RaceStartTimer_timeout():
	$RaceStopTimer.start()
	
	$RaceTrack.spawn_pickups(5)
	resources_available += 5
	
	emit_signal("resources_updated", resources_collected, resources_available)

func _on_RaceStopTimer_timeout():
	var uncollected_resources = resources_available - resources_collected
	
	if uncollected_resources > 0 and available_powerups.size() > 0:
		current_powerups.append(available_powerups.pop_back())
		
		if current_powerups.has('spawn'):
			$MobSpawnTimer.wait_time = 2
	
	$RaceTrack.clear_pickups()
	
	$RaceStartTimer.start()
	
	resources_collected = 0
	resources_available = 0
	
	emit_signal("resources_updated", resources_collected, resources_available)

func _on_Car_resource_collected(resource):
	resources_collected += 1
	emit_signal("resources_updated", resources_collected, resources_available)
	resource.queue_free()

func _on_Base_base_destroyed():
	print('game over')
	get_tree().quit()
	
func on_projectile_hit():
	print('projectile hit')
	$ProjectileHit.play()
