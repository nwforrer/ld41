extends Node2D

export (PackedScene) var Pickup

func _ready():
	randomize()
	
func spawn_pickups(count):
	for pickup_index in count:
		$PickupPath/PickupSpawnLocation.set_offset(randi())
		var pickup = Pickup.instance()
		pickup.position = $PickupPath/PickupSpawnLocation.position
		add_child(pickup)