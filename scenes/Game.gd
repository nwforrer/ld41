extends Node

export (Array, NodePath) var paths = []

func _ready():
	randomize()

func _on_MobSpawnTimer_timeout():
	if paths.size() > 0:
		var path = paths[randi()%paths.size()]
		var mobScene = load("res://scenes/Mob.tscn")
		get_node(path).add_child(mobScene.instance())
