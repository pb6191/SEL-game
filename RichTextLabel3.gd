extends RichTextLabel
#CENTRE OF THE SCREEN rect posn Y WAS 294 not 364
#WHEN RAYCAST translatn Y WAS 0 not -0.4

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	set_text("+")

