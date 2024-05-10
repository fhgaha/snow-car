class_name CarCamGimbal
extends Node3D

@export var target : VehicleBody3D
@export var dist : float = 100
@export var offset_x : float = 20
@export var offset_z : float = 0
@export var dirToTrg : Vector3

@export_group("rotations")
@export var sens_vertical : float = 0.2
@export var sens_horizontal : float = 0.2
@export var max_z_rot_deg : float = -31
@export var min_z_rot_deg : float = 24

var cur_z_rot_deg : float = 0

func _ready() -> void:
	dirToTrg = self.global_position.direction_to(target.global_position)
	pass

func _process(delta: float) -> void:
	if !target: return
	
	global_position = target.global_position
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var yToRotate : float = event.relative.x * sens_horizontal
		rotate_y(deg_to_rad(-yToRotate))
		
		#var zRotate : float = event.relative.y * sens_vertical
		#if (cur_z_rot_deg + zRotate > min_z_rot_deg 
		#or  cur_z_rot_deg + zRotate < max_z_rot_deg):
			#pass
		#else:
			#rotate_z(deg_to_rad(zRotate))
			#cur_z_rot_deg += zRotate
	pass
