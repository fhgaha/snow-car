#@tool
class_name MyClass
extends CollisionShape3D
 
@export var mesh : ArrayMesh :
	set(value): 
		#if Engine.is_editor_hint():
			#do(value)
		mesh = value
@export var scale_ : float
#@export var btn: bool :
	#set(value):
		#print("set")
		#if Engine.is_editor_hint():
			#do(mesh)

func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	pass


func do():
	#if Engine.is_editor_hint():
	print("do")
	if !mesh: return
	
	var orig : Array = mesh.surface_get_arrays(Mesh.ARRAY_VERTEX)
	var verts : Array = []
	verts.append_array(orig)
	for i in verts:
		verts[i] *= scale_
	shape = ConcavePolygonShape3D.new()
	shape.set_faces(PackedVector3Array(verts))
	pass
