extends KinematicBody2D

signal resource_collected

export (int) var speed = 200
export (float) var rotation_speed = 1.5

const PICKUP_BIT = 32

var velocity = Vector2()
var rotation_dir = 0

func get_input():
    rotation_dir = 0
    velocity = Vector2()
    if Input.is_action_pressed('ui_right'):
        rotation_dir += 1
    if Input.is_action_pressed('ui_left'):
        rotation_dir -= 1
    if Input.is_action_pressed('ui_down'):
        velocity = Vector2(-speed, 0).rotated(rotation)
    if Input.is_action_pressed('ui_up'):
        velocity = Vector2(speed, 0).rotated(rotation)

func _physics_process(delta):
	get_input()
	rotation += rotation_dir * rotation_speed * delta
	move_and_slide(velocity)

func _on_Area2D_area_entered(area):
	if area.collision_layer & PICKUP_BIT:
		emit_signal("resource_collected", area)
