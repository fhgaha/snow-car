extends SubViewport

@export var player_path   : NodePath
@export var world_extents : Rect2

var player : RigidBody3D

func _ready() -> void:
	player = get_node(player_path)
	if !player:
		set_process(false)
	pass


func _process(delta: float) -> void:
	var half_world_extents = world_extents.size / 2
	var player_pos = Vector2(player.position.x, player.position.z)
	
	player_pos += half_world_extents
	var paintbrush_position = player_pos / world_extents.size
	
	$SnowPaintbrush.position = paintbrush_position * Vector2(self.size)
	pass
