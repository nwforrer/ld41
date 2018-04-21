extends Node

export (Array, NodePath) var paths = []

var resources_available
var resources_collected

var mob_power

func _ready():
	randomize()
	
	mob_power = 1
	resources_available = 0
	resources_collected = 0
	
	$RaceStartTimer.start()

func _on_MobSpawnTimer_timeout():
	if paths.size() > 0:
		var path = paths[randi()%paths.size()]
		var mob = load("res://scenes/Mob.tscn").instance()
		mob.health = mob_power
		get_node(path).add_child(mob)

func _on_RaceStartTimer_timeout():
	$RaceStopTimer.start()
	
	$RaceTrack.spawn_pickups(5)
	resources_available += 5
	$GUI.add_resources_available(5)

func _on_RaceStopTimer_timeout():
	var uncollected_resources = resources_available - resources_collected
	mob_power += uncollected_resources
	
	$RaceStartTimer.start()

func _on_Car_resource_collected(resource):
	resources_collected += 1
	$GUI.add_resources_collected(1)
	resource.queue_free()


func _on_Base_base_destroyed():
	print('game over')
	get_tree().quit()
