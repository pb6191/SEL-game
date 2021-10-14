extends Node

onready var player1 = $"Spatial/KinematicBody"
onready var rayCast1 = $"Spatial/KinematicBody/Target/CameraBoom/Camera/RayCast1"
var data_file = File.new()
var existing_content = ""
var output = []
var time_elapsed = 0
var loops_elapsed = 0
var datetime0 = OS.get_datetime()
var filename_datetime0 = String(datetime0.year) +String(datetime0.month) +String(datetime0.day) +String(datetime0.hour) +String(datetime0.minute) +String(datetime0.second)

func _enter_tree():
	var time0 = OS.get_time()
	#var time_return0 = String(time0.hour) +":"+String(time0.minute)+":"+String(time0.second)
	#output.append(time_return0 + "  NEW EXECUTION  - The root node has entered")


# Called when the node enters the scene tree for the first time.
func _ready():
	#var time1 = OS.get_time()
	#var time_return1 = String(time1.hour) +":"+String(time1.minute)+":"+String(time1.second)
	#output.append(time_return1 + "  The whole tree has been initialized")
	#time1 = OS.get_time()
	#time_return1 = String(time1.hour) +":"+String(time1.minute)+":"+String(time1.second)
	#output.append(time_return1 + "  Starting time: " + str(time_elapsed) + "  Processing loop: " + str(loops_elapsed))
	output.append("Timestamp,Elapsed,Loop,Player_X,Player_Y,Player_Z,Footcube_inventoried,FirstChoice,CurrentLevel,CurrentLevel1ObjectExploring,CurrentLevel2ObjectExploring")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_elapsed += delta
	loops_elapsed += 1
	if (loops_elapsed % 25 == 0):
		var time2 = OS.get_time()
		var time_return2 = String(time2.hour) +":"+String(time2.minute)+":"+String(time2.second)
		output.append(time_return2 + "," + str(time_elapsed) + "," + str(loops_elapsed) + "," + str($"Spatial/KinematicBody".translation.x) + "," + str($"Spatial/KinematicBody".translation.y) + "," + str($"Spatial/KinematicBody".translation.z)+","+ str($"Viewports/ViewportContainer0/Viewport0/FootCube2".visible)+","+player1.firstChoice+","+player1.currentLevel+","+rayCast1.currentLevel1ObjectExplored+","+rayCast1.currentLevel2ObjectExplored)
		
func _exit_tree():
	#var time0 = OS.get_time()
	#var time_return0 = String(time0.hour) +":"+String(time0.minute)+":"+String(time0.second)
	#output.append(time_return0 + "  The root node has left")
	#time0 = OS.get_time()
	#time_return0 = String(time0.hour) +":"+String(time0.minute)+":"+String(time0.second)
	#output.append(time_return0 + "  Ending time: " + str(time_elapsed) + "  Processing loop: " + str(loops_elapsed))
	if data_file.file_exists("user://data_file"+filename_datetime0+".txt"):
		data_file.open("user://data_file"+filename_datetime0+".txt", File.READ)
		existing_content = data_file.get_as_text()
		data_file.close()
	data_file.open("user://data_file"+filename_datetime0+".txt", File.WRITE)   
	data_file.store_line(existing_content)
	for line in output: data_file.store_line(line)
	data_file.close()
