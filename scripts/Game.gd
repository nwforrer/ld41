extends Node

signal resources_updated

export (Array, NodePath) var paths = []

export (int) var mob_health_boost
export (int) var mob_speed_boost
export (int) var mob_spawn_boost

export (int) var resources_to_spawn

var resources_available
var resources_collected

var available_mob_powerups = ['health', 'spawn', 'speed']
var current_mob_powerups = []

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

func _process(delta):
	if not $RaceStartTimer.is_stopped() and $RaceStartTimer.time_left <= 5:
		$GUI.countdown($RaceStartTimer.time_left)
	elif not $RaceStopTimer.is_stopped() and $RaceStopTimer.time_left <= 5:
		$GUI.countdown($RaceStopTimer.time_left)

func _on_MobSpawnTimer_timeout():
	if paths.size() > 0:
		var path = paths[randi()%paths.size()]
		var mob = load("res://scenes/Mob.tscn").instance()
		if current_mob_powerups.has('speed'):
			mob.speed = mob_speed_boost
		if current_mob_powerups.has('health'):
			mob.health = mob_health_boost
		get_node(path).add_child(mob)

func _on_RaceStartTimer_timeout():
	$RaceStopTimer.start()
	
	$RaceTrack.spawn_pickups(resources_to_spawn)
	resources_available += resources_to_spawn
	
	emit_signal("resources_updated", resources_collected, resources_available)

func _on_RaceStopTimer_timeout():
	var uncollected_resources = resources_available - resources_collected
	
	if uncollected_resources > 0 and available_mob_powerups.size() > 0:
		var new_boost = available_mob_powerups.pop_front()
		current_mob_powerups.append(new_boost)
		
		if current_mob_powerups.has('spawn'):
			$MobSpawnTimer.wait_time = mob_spawn_boost
			
		$GUI.add_mob_boost(new_boost)
		$Missed.play()
	
	$RaceTrack.clear_pickups()
	
	$RaceStartTimer.start()
	
	resources_collected = 0
	resources_available = 0
	
	resources_to_spawn += 1
	
	emit_signal("resources_updated", resources_collected, resources_available)

func _on_Car_resource_collected(resource):
	resources_collected += 1
	$ResourcePickup.play()
	emit_signal("resources_updated", resources_collected, resources_available)
	resource.queue_free()

func _on_Base_base_destroyed():
	#get_tree().quit()
	get_tree().paused = true
	
func on_projectile_hit():
	$ProjectileHit.play()
