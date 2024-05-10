@tool
extends EditorScript


# Called when the script is executed (using File -> Run in Script Editor).
func _run() -> void:
	var g := get_scene().get_node("env/snowy_mountain_-_terrain_1/StaticBody3D/CollisionShape3D") as MyClass
	print(g)
	(g as MyClass).do()
	pass
