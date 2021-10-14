extends RigidBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
#	set_contact_monitor(true)
#	set_max_contacts_reported(1)

func start(xform):
	transform = xform
