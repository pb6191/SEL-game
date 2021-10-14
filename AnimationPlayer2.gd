extends AnimationPlayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

onready var anim = get_node(".")
func _on_VisibilityNotifier2_screen_entered():
	anim.play("Idle-loop")


func _on_VisibilityNotifier2_screen_exited():
	anim.play("Attack_1")
