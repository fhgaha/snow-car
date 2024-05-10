extends SubViewport

@export var player_path   : NodePath
@export var mesh_inst : MeshInstance3D
@export var world_extents : Rect2

var player : RigidBody3D

func _ready() -> void:
	player = get_node(player_path)
	if !player:
		set_process(false)
	
	if mesh_inst:
		var aabb = mesh_inst.get_aabb()
		world_extents.size = Vector2(aabb.size.x, -aabb.size.z)
	pass


func _process(delta: float) -> void:
	var half_world_extents = world_extents.size / 2
	var player_pos = Vector2(player.position.x, player.position.z)
	player_pos += half_world_extents
	$SnowPaintbrush.position = player_pos / world_extents.size * Vector2(self.size)
	pass
