extends RichTextLabel

var ms2 = 0
var s2 = 0
var m2 = 0

func _process(delta):
	if ms2 > 9:
		s2 += 1
		ms2 = 0
	if s2 > 59:
		m2 += 1
		s2 = 0
	if s2 > 15:
		var material = SpatialMaterial.new()
		material.albedo_color = Color(1, 0, 0)
		$"../../../../Spatial/RigidBody/CollisionShape/MeshInstance".set_surface_material(0, material)
	#set_text("Visibility time for white/red sphere: "+str(m2)+":"+str(s2)+":"+str(ms2))

func _on_Timer01_timeout():
	ms2 += 1
