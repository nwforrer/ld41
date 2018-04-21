extends Node2D

export (PackedScene) var Pickup

func _ready():
	randomize()
	
	$PickupPath/PickupSpawnLocation.set_offset(randi())
	var pickup = Pickup.instance()
	pickup.position = $PickupPath/PickupSpawnLocation.position
	add_child(pickup)