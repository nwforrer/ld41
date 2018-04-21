extends Node

export (Array, NodePath) var paths = []

func _ready():
	randomize()

func _on_MobSpawnTimer_timeout():
	if paths.size() > 0:
		print('spawning mob')
		var path_index = randi()%paths.size()
		var path = paths[path_index]
		var mobScene = load("res://scenes/Mob.tscn")
		var instance = mobScene.instance()
		get_node(path).add_child(instance)
