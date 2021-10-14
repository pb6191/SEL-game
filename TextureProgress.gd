extends TextureProgress


var ms2 = 0
var s2 = 0
var m2 = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$".".value = 1000
	$".".tint_progress = Color.green

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	$".".value = $".".value - 1
	if $".".value <= 200:
		$".".tint_progress = Color.red
	elif $".".value <= 500:
		$".".tint_progress = Color.yellow
	else:
		$".".tint_progress = Color.green
