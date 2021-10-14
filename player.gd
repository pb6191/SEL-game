extends KinematicBody

var rng = RandomNumberGenerator.new()
var X_dict = {}
var Y_dict = {}
var Z_dict = {}
var handle_movement_loop = 0
var temp_help_x
var temp_help_y
var temp_help_z
var level1Text = "Look around! This is how most of us live today. We are told that if we continue on this path we are doomed\nPress 'Y' to know what the future holds"
var level1Text2 = "second AI text for level 1. Press U to know more"
var level2Text = "Level 2 text. Press Y to know more"
var level3Text = "Level 3 text. Press Y to know more"

var plasticCounter = 0
var count = 0
var numPoints = 0
var firstChoice = "Unknown"
var currentLevel = "level 0"
var Bullet = preload("res://Bullet.tscn")

export var speed : float = 10
export var acceleration : float = 8
export var air_acceleration : float = 3
export var gravity : float = 0.98
export var max_terminal_velocity : float = 54
export var jump_power : float = 20

export(float, 0.1, 1) var mouse_sensitivity : float = 0.3
export(float, -90, 0) var min_pitch : float = -90
export(float, 0, 90) var max_pitch : float = 90

var velocity : Vector3
var y_velocity : float

#creating array for collect/throw items
var arr = ["FootCube2", "BoxRigidBody2", "BottleRigidBody", "RigidBody", "RigidBody3", "RigidBodyL11", "RigidBodyL12", "RigidBodyL13", "RigidBodyL14", "RigidBodyL15", "RigidBodyL16", "RigidBodyL17", "RigidBodyL18", "RigidBodyL19"]
#creating array for recycle items
var arr2 = ["BoxRigidBody2", "BottleRigidBody"]
	
onready var robot = $Robot
onready var camera_pivot = $Target
onready var camera = $Target/CameraBoom/Camera

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

		
func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * mouse_sensitivity
		camera_pivot.rotation_degrees.x -= event.relative.y * mouse_sensitivity
		camera_pivot.rotation_degrees.x = clamp(camera_pivot.rotation_degrees.x, min_pitch, max_pitch)
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen


func _physics_process(delta):
	handle_movement(delta)
	if Input.is_action_pressed("move_fw") || Input.is_action_pressed("move_bw") || Input.is_action_pressed("move_l") || Input.is_action_pressed("move_r"):
		if is_on_floor():
			if not $"AudioStreamPlayer".is_playing():
				$"AudioStreamPlayer".play()
	else:
		$"AudioStreamPlayer".stop()
	if Input.is_action_just_pressed("jump"):
		if $"AudioStreamPlayer".is_playing():
			$"AudioStreamPlayer".stop()
		if not $"AudioStreamPlayerJump".is_playing():
			$"AudioStreamPlayerJump".play()
	if Input.is_action_just_pressed("shoot") || Input.is_action_just_released("shoot"):
		pass
		#$"AudioStreamPlayerShoot".play()


func handle_movement(delta):
	var shortestPlasticDist = 9999999
	var direction = Vector3()
	var is_moving = false
	
	if Input.is_action_pressed("move_fw"):
		direction -= transform.basis.z
		is_moving = true

	if Input.is_action_pressed("move_bw"):
		direction += transform.basis.z
		is_moving = true

	if Input.is_action_pressed("move_l"):
		direction -= transform.basis.x
		is_moving = true

	if Input.is_action_pressed("move_r"):
		direction += transform.basis.x
		is_moving = true

	direction = direction.normalized()
	
	var accel = acceleration if is_on_floor() else air_acceleration
	velocity = velocity.linear_interpolate(direction * speed, accel * delta)
	
	if is_on_floor():
		y_velocity = -0.01
	else:
		y_velocity = clamp(y_velocity - gravity, -max_terminal_velocity, max_terminal_velocity)
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		y_velocity = jump_power
	
	velocity.y = y_velocity
	velocity = move_and_slide(velocity, Vector3.UP)

	if is_moving:
		var angle = transform.origin - velocity
		robot.look_at(angle, Vector3.UP)
	
	#print(String($".".translation.x)+" "+String($".".translation.y)+" "+String($".".translation.z))

	# Save player position in the dictionary
	X_dict[String(handle_movement_loop)] = $".".translation.x
	Y_dict[String(handle_movement_loop)] = $".".translation.y
	Z_dict[String(handle_movement_loop)] = $".".translation.z
	X_dict.erase(String(handle_movement_loop-251))
	Y_dict.erase(String(handle_movement_loop-251))
	Z_dict.erase(String(handle_movement_loop-251))
	
	# respawn at position 300 loops back
	if $".".translation.y < -100:
		$".".translation.x = X_dict.get(String(handle_movement_loop-250))
		$".".translation.y = 3 + Y_dict.get(String(handle_movement_loop-250))
		$".".translation.z = Z_dict.get(String(handle_movement_loop-250))
	
	# respawn in level 0 after falling
	#if $".".translation.y < -100:
	#	$".".translation.x = 0
	#	$".".translation.y = 3
	#	$".".translation.z = -85
	#	currentLevel = "level 0"
		
	#going back to level 1 door in level 0
	#if $".".translation.x > 81 and $".".translation.x < 89 and $".".translation.y > 0 and $".".translation.y < 4 and $".".translation.z > 29 and $".".translation.z < 30:
	#	$".".translation.x = -4
	#	$".".translation.y = 1
	#	$".".translation.z = -125
	#	get_node("../../Viewports/VBoxContainer/ViewportContainer1/Viewport1/RichTextLabel4").text = ""
		
	# entering level 1
	if $".".translation.x > -5 and $".".translation.x < -3 and $".".translation.y > 0 and $".".translation.y < 4 and $".".translation.z > -130.7 and $".".translation.z < -129.7:
		$".".translation.x = 0
		$".".translation.y = 8
		$".".translation.z = 0
		$"../../Control/AcceptDialog".visible = false
		$"../../Control/AcceptDialog".dialog_text = level1Text
		$"../../Control/AcceptDialog".rect_position = Vector2(rng.randi_range(56, 756), rng.randi_range(50, 450))
		$"../../Control/AcceptDialog".popup()
		#get_node("../../Viewports/VBoxContainer/ViewportContainer1/Viewport1/RichTextLabel4").text = "Hi there! If you want to now more about what the future could be like, press 'Y' or just keep playing"
		$"../../Viewports/VBoxContainer/ViewportContainer1/Viewport1/Timer".start()
		currentLevel = "level 1"
		count = count + 1
		if (count == 1):
			firstChoice = "level 1"
		
	# trying to enter level 2 from level 0
	if $".".translation.x > -1 and $".".translation.x < 1 and $".".translation.y > 0 and $".".translation.y < 4 and $".".translation.z > -130.8 and $".".translation.z < -129.8:
		#$".".translation.x = 0
		#$".".translation.y = 4
		#$".".translation.z = 100
		count = count + 1
		if (count == 1):
			firstChoice = "level 2"
		
	# trying to enter level 3 from level 0
	if $".".translation.x > 3 and $".".translation.x < 5 and $".".translation.y > 0 and $".".translation.y < 4 and $".".translation.z > -130.5 and $".".translation.z < -129.5:
		count = count + 1
		if (count == 1):
			firstChoice = "level 3"
			
	if $".".translation.x > -10 and $".".translation.x < 10 and $".".translation.y > -2 and $".".translation.z > 31 and $".".translation.z < 79:
		currentLevel = "bridge 1"
		
	if $".".translation.x > -10 and $".".translation.x < 10 and $".".translation.y > -2 and $".".translation.z > -68.5 and $".".translation.z < -20.11:
		currentLevel = "bridge 0"
		
	if $".".translation.x > -10 and $".".translation.x < 10 and $".".translation.y > -2 and $".".translation.z > 119.5 and $".".translation.z < 180.24:
		currentLevel = "bridge 2"
		
	if $".".translation.x > -5.6 and $".".translation.x < 5.6 and $".".translation.y > -2 and $".".translation.z > -131 and $".".translation.z < -70:
		currentLevel = "level 0"
		
	if currentLevel != "level 1" and $".".translation.x > -20 and $".".translation.x < 46 and $".".translation.y > -2 and $".".translation.z > -20 and $".".translation.z < 31:
		currentLevel = "level 1"
		$"../../Control/AcceptDialog".visible = false
		$"../../Control/AcceptDialog".dialog_text = level1Text
		$"../../Control/AcceptDialog".rect_position = Vector2(rng.randi_range(56, 756), rng.randi_range(50, 450))
		$"../../Control/AcceptDialog".popup()
		
	if currentLevel != "level 2" and $".".translation.x > -20 and $".".translation.x < 21 and $".".translation.y > -2 and $".".translation.z > 79 and $".".translation.z < 119.5:
		currentLevel = "level 2"
		$"../../Control/AcceptDialog".visible = false
		$"../../Control/AcceptDialog".dialog_text = level2Text
		$"../../Control/AcceptDialog".rect_position = Vector2(rng.randi_range(56, 756), rng.randi_range(50, 450))
		$"../../Control/AcceptDialog".popup()
		
	if currentLevel != "level 3" and $".".translation.x > -20 and $".".translation.x < 46 and $".".translation.y > -2 and $".".translation.z > 180.24 and $".".translation.z < 231.15:
		currentLevel = "level 3"
		$"../../Control/AcceptDialog".visible = false
		$"../../Control/AcceptDialog".dialog_text = level3Text
		$"../../Control/AcceptDialog".rect_position = Vector2(rng.randi_range(56, 756), rng.randi_range(50, 450))
		$"../../Control/AcceptDialog".popup()
		
	if $".".translation.y < -2:
		currentLevel = "freefall"
		
	# sending to level 1 help
	if Input.is_action_just_pressed("num_y") and currentLevel == "level 1":
		temp_help_x = $".".translation.x
		temp_help_y = $".".translation.y
		temp_help_z = $".".translation.z
		$".".translation.x = 0
		$".".translation.y = 4
		$".".translation.z = -200
		currentLevel = "level 1 help"
		$"../../Control/AcceptDialog".visible = false
		$"../../Control/AcceptDialog".dialog_text = "Science can make well-informed predictions, but the truth is...we cannot know for sure what the future holds\nPress 'N' to get back"
		$"../../Control/AcceptDialog".rect_position = Vector2(rng.randi_range(56, 756), rng.randi_range(50, 450))
		$"../../Control/AcceptDialog".popup()
		
	# sending from level 1 help
	if Input.is_action_just_pressed("num_n") and currentLevel == "level 1 help":
		$".".translation.x = temp_help_x
		$".".translation.y = 3 + temp_help_y
		$".".translation.z = temp_help_z
		currentLevel = "level 1"
		$"../../Control/AcceptDialog".visible = false
		$"../../Control/AcceptDialog".dialog_text = level1Text
		$"../../Control/AcceptDialog".rect_position = Vector2(rng.randi_range(56, 756), rng.randi_range(50, 450))
		$"../../Control/AcceptDialog".popup()
		
	# sending to level 2 help
	if Input.is_action_just_pressed("num_y") and currentLevel == "level 2":
		temp_help_x = $".".translation.x
		temp_help_y = $".".translation.y
		temp_help_z = $".".translation.z
		$".".translation.x = 0
		$".".translation.y = 4
		$".".translation.z = -300
		currentLevel = "level 2 help"
		$"../../Control/AcceptDialog".visible = false
		$"../../Control/AcceptDialog".dialog_text = "Press 'N' to get back"
		$"../../Control/AcceptDialog".rect_position = Vector2(rng.randi_range(56, 756), rng.randi_range(50, 450))
		$"../../Control/AcceptDialog".popup()
		
	# sending from level 2 help
	if Input.is_action_just_pressed("num_n") and currentLevel == "level 2 help":
		$".".translation.x = temp_help_x
		$".".translation.y = 3 + temp_help_y
		$".".translation.z = temp_help_z
		currentLevel = "level 2"
		$"../../Control/AcceptDialog".visible = false
		$"../../Control/AcceptDialog".dialog_text = level2Text
		$"../../Control/AcceptDialog".rect_position = Vector2(rng.randi_range(56, 756), rng.randi_range(50, 450))
		$"../../Control/AcceptDialog".popup()
		
	if currentLevel == "level 0" and handle_movement_loop == 0:
		$"../../Control/AcceptDialog".visible = false
		$"../../Control/AcceptDialog".dialog_text = "Welcome to NAME of GAME"
		$"../../Control/AcceptDialog".rect_position = Vector2(rng.randi_range(56, 756), rng.randi_range(50, 450))
		$"../../Control/AcceptDialog".popup()
		
	if currentLevel == "level 0" and handle_movement_loop == 1000:
		$"../../Control/AcceptDialog".visible = false
		$"../../Control/AcceptDialog".dialog_text = "I am NAME\nEarth sent me far forward in time so I could see the many different futures that we could write together...some good, some bad, and some downright catastrophic"
		$"../../Control/AcceptDialog".rect_position = Vector2(rng.randi_range(56, 756), rng.randi_range(50, 450))
		$"../../Control/AcceptDialog".popup()
		
	if currentLevel == "level 0" and handle_movement_loop == 2000:
		$"../../Control/AcceptDialog".visible = false
		$"../../Control/AcceptDialog".dialog_text = "If you were told that we are doomed; or you think you are too small to make a difference...think again."
		$"../../Control/AcceptDialog".rect_position = Vector2(rng.randi_range(56, 756), rng.randi_range(50, 450))
		$"../../Control/AcceptDialog".popup()
		
	if currentLevel == "level 0" and handle_movement_loop == 3000:
		$"../../Control/AcceptDialog".visible = false
		$"../../Control/AcceptDialog".dialog_text = "I know that there is not one future, I’ve been there! So hone your skills and get ready with this tutorial. You can choose the future you want; one that will make humanity better, and that will save our beautiful Earth"
		$"../../Control/AcceptDialog".rect_position = Vector2(rng.randi_range(56, 756), rng.randi_range(50, 450))
		$"../../Control/AcceptDialog".popup()
		
	if currentLevel == "level 0" and handle_movement_loop == 4000:
		$"../../Control/AcceptDialog".visible = false
		$"../../Control/AcceptDialog".dialog_text = "Take all the time you need. You have a very important task to accomplish. When you are ready, find the door that will set you off to start building a better future"
		$"../../Control/AcceptDialog".rect_position = Vector2(rng.randi_range(56, 756), rng.randi_range(50, 450))
		$"../../Control/AcceptDialog".popup()
		
	if currentLevel == "level 0" and handle_movement_loop == 5000:
		$"../../Control/AcceptDialog".visible = false
		$"../../Control/AcceptDialog".dialog_text = "Don’t worry, you are not alone in this. I’ll be there with you every step of the way."
		$"../../Control/AcceptDialog".rect_position = Vector2(rng.randi_range(56, 756), rng.randi_range(50, 450))
		$"../../Control/AcceptDialog".popup()
		
	# calculating shortest plastic distance and using only after here in the funciton
	for item in arr2:
		var rb = get_parent().get_node(item)
		var sp = get_node("../../Viewports/ViewportContainer0/Viewport0/"+item)
		var icon = get_node("../../Viewports/ViewportContainer0/Viewport0/"+item+"/RecycleIcon")
		if (sp.visible == true and icon.visible == true) or (sp.visible == false and icon.visible == false):
			if rb.global_transform.origin.distance_to(get_node(".").global_transform.origin) < shortestPlasticDist:
				shortestPlasticDist = rb.global_transform.origin.distance_to(get_node(".").global_transform.origin)
		
	if shortestPlasticDist > 4:
		plasticCounter = 0
		
	if shortestPlasticDist < 4 and plasticCounter != 1:
		plasticCounter = 1
		$"../../Control/AcceptDialog".visible = false
		$"../../Control/AcceptDialog".dialog_text = level1Text2
		$"../../Control/AcceptDialog".rect_position = Vector2(rng.randi_range(56, 756), rng.randi_range(50, 450))
		$"../../Control/AcceptDialog".popup()
		
	handle_movement_loop = handle_movement_loop + 1

var counter = 0
func _unhandled_input(event):
	var npc = get_parent().get_node("ip_guy")
	var npcText = get_parent().get_node("ip_guy/RichTextLabelNPC")
	if npc.global_transform.origin.distance_to(get_node(".").global_transform.origin) <= 4 and counter == 0:
		npcText.text = "Hi friend! How are you?\nPress 1 - Everything is great\tPress 2 - I am frustrated\nPress 3 - Why do you ask?\tPress 4 - I am confused"
		counter = 1
	if event.is_action("num_1") and counter == 1:
		npcText.text = "Would you like me to make something for you?\nPress M - Yes\tPress N - No"
		counter = 11
	if event.is_action("num_m") and counter == 11:
		npcText.text = "But you don't have the required objects yet!"
		counter = 111
	if event.is_action("num_n") and counter == 11:
		npcText.text = "Ok! Talk to you later"
		counter = 112
	if event.is_action("num_2") and counter == 1:
		npcText.text = "Are you having a hard time finding something?\nPress M - Yes\tPress N - No"
		counter = 12
	if event.is_action("num_m") and counter == 12:
		npcText.text = "You can look around for objects"
		counter = 121
	if event.is_action("num_n") and counter == 12:
		npcText.text = "Ok! Talk to you later"
		counter = 122
	if event.is_action("num_3") and counter == 1:
		npcText.text = "I like to be friendly and helpful"
		counter = 13
	if event.is_action("num_4") and counter == 1:
		npcText.text = "Start collecting objects\nTo collect objects, just get close to them and press R\nBut remember, you cannot collect objects unless they are small enough"
		counter = 14
	if npc.global_transform.origin.distance_to(get_node(".").global_transform.origin) > 4:
		npcText.text = ""
		counter = 0
	
	if event.is_action("shoot"):
		var b = Bullet.instance()
		#b.start($"Robot/Position3D".global_transform)
		#get_parent().add_child(b)

#	if event.is_action("remove"):
#		for item in arr:
#			var rb = get_parent().get_node(item)
#			var sp = get_node("../../Viewports/ViewportContainer0/Viewport0/"+item)
#			if rb.get_scale() <= Vector3(1,1,1) and rb.visible == true and rb.global_transform.origin.distance_to(get_node(".").global_transform.origin) <= 4:
#				rb.visible = false
#				sp.visible = true
#				numPoints = numPoints + 10
#		get_node("../../Viewports/VBoxContainer/ViewportContainer1/Viewport1/RichTextLabel4").text = "Points for collecting objects and recycling: "+str(numPoints)
		
#	if event.is_action("throw"):
#		for item in arr:
#			var rb = get_parent().get_node(item)
#			var sp = get_node("../../Viewports/ViewportContainer0/Viewport0/"+item)
#			if !(item in arr2) and rb.visible == false:
#				rb.set_scale(Vector3(1, 1, 1))
#				rb.visible = true
#				sp.visible = false
#				rb.start($"Robot/Position3D".global_transform)
#				numPoints = numPoints - 10
#			if item in arr2 and rb.visible == false and get_node(".").global_transform.origin.distance_to(get_node("../bin_model2").global_transform.origin) > 1:
#				var icon = get_node("../../Viewports/ViewportContainer0/Viewport0/"+item+"/RecycleIcon")
#				if icon.visible == false:
#					rb.set_scale(Vector3(1, 1, 1))
#					rb.visible = true
#					sp.visible = false
#					rb.start($"Robot/Position3D".global_transform)
#					numPoints = numPoints - 10
#			if item in arr2 and get_node("../../Viewports/ViewportContainer0/Viewport0/"+item+"/RecycleIcon").visible == false and rb.visible == false and get_node(".").global_transform.origin.distance_to(get_node("../bin_model2").global_transform.origin) <= 1:
#				var icon = get_node("../../Viewports/ViewportContainer0/Viewport0/"+item+"/RecycleIcon")
#				icon.visible = true
#				numPoints = numPoints + 10
#		get_node("../../Viewports/VBoxContainer/ViewportContainer1/Viewport1/RichTextLabel4").text = "Points for collecting objects and recycling: "+str(numPoints)
		
		
