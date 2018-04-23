extends Node

signal resources_updated

export (Array, NodePath) var paths = []

export (int) var mob_health_boost
export (int) var mob_speed_boost
export (int) var mob_spawn_boost

export (int) var resources_to_spawn

var resources_available
var resources_collected
export (int) var resources_held = 0
export (int) var resources_needed = 5
export (int) var resources_needed_increase = 5

var available_mob_powerups = ['health', 'spawn', 'speed']
var current_mob_powerups = []

var towers_upgraded = 0

var selected_tower

func _ready():
	randomize()
	
	resources_available = 0
	resources_collected = 0
	
	emit_signal("resources_updated", resources_held, resources_needed)
	
	$RaceStartTimer.start()

func _process(delta):
	if towers_upgraded == 6 and $WinCountdown.is_stopped():
		$WinCountdown.start()
	elif not $WinCountdown.is_stopped():
		$GUI.win_countdown($WinCountdown.time_left)
		
	get_input()
	if not $RaceStartTimer.is_stopped() and $RaceStartTimer.time_left <= 5:
		$GUI.countdown($RaceStartTimer.time_left, true)
	elif not $RaceStopTimer.is_stopped() and $RaceStopTimer.time_left <= 5:
		$GUI.countdown($RaceStopTimer.time_left, false)

func get_input():
	if Input.is_action_just_pressed('ui_interact'):
		upgrade_selected_tower()
	
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
	
	emit_signal("resources_updated", resources_held, resources_needed)

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
	if $RaceStopTimer.wait_time > 5:
		$RaceStopTimer.wait_time *= 0.9
	
	resources_collected = 0
	resources_available = 0
	
	resources_to_spawn += 1
	
	emit_signal("resources_updated", resources_held, resources_needed)

func _on_Car_resource_collected(resource):
	resources_collected += 1
	resources_held += 1
	$ResourcePickup.play()
	emit_signal("resources_updated", resources_held, resources_needed)
	resource.queue_free()

func _on_Base_base_destroyed():
	get_tree().change_scene('res://scenes/GameOver.tscn')
	
func on_projectile_hit():
	$ProjectileHit.play()

func upgrade_selected_tower():
	if selected_tower and resources_held >= resources_needed:
		if selected_tower.upgrade():
			resources_held -= resources_needed
			resources_needed += resources_needed_increase
			emit_signal("resources_updated", resources_held, resources_needed)
			$Powerup.play()
			towers_upgraded += 1

func _on_tower_selected(tower):
	selected_tower = tower

func _on_Tower_tower_unselected(tower):
	selected_tower = null

func _on_WinCountdown_timeout():
	print('you win!')
	get_tree().change_scene('res://scenes/YouWin.tscn')
