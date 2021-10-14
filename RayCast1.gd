extends RayCast

onready var player1 = $"../../../.."
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var rng = RandomNumberGenerator.new()
var L1HObject1Text = "This is what might happen if the whole world completely stopped polluting the Earth right now.\nHow certain do you think this scenario is?"
var L1HObject2Text = "This is what might happen if the whole world continues doing things the way we do now.\nHow certain do you think this scenario is?"
var L1HObject3Text = "July 1, 2176\nDear friend, the picture you see on this postcard was taken many centuries ago, when my people lived in balance with our ancestral land. They passed on to me this image from one generation to the next so that I could see where we come from and how beautiful our planet used to be. But my world is nothing like the one you see here.\nI’m sending you this postcard because I want you to know that everything you do today has the power to shape the whole world’s future. I beg you, please, make your choices wisely and remember that you are part of something bigger than yourself."
var L1HObject4Text = "It’s hard to plan for your life when you don’t know what’s in store for our planet and humanity at large. But if you look carefully inside of you, and listen to your own voice, you’ll find the direction you need not to get lost in your life journey."
var L1HObject5Text = "Doing things under pressure is hard. Different people react differently when they know time is running out.\nHow about you? Is this when you give your best? Or do you freeze and want to run away?"
var L1HObject6Text = "July 1, 2176\nCollective action yields surprising results!\nCaring for each other has saved humanity and mother Earth\nAfter historical declines in our ability to care for each other, which had led to the near destruction of humankind and planet Earth, empathy is back!\nA massive generational shift in our willingness to look beyond our own individual selves, has finally led to unprecedented technological, economic and social progress.\nLife satisfaction is at historical highs; social injustice, discriminination and inequality have never been lower; and our natural environment is flourishing and richer than ever."
var L1HObject1TextAI = "Not knowing what’s coming can make us anxious or even fearful. How does it make YOU feel?"
var L1HObject2TextAI = "Not knowing what’s coming can make us anxious or even fearful. How does it make YOU feel?"
var L1HObject3TextAI = "What do you think the world in 2176 will look like?"
var L1HObject4TextAI = "Knowing how to live in highly uncertain times might be one of the most important survival skills you could ever learn for yourself. This is not a hard skill to learn. All you need to do is to change your perspective about what uncertainty really is.\nSo repeat with me:\n'Uncertainty is an opening towards possibilities'\n'Uncertainty is an invitation to play MY part in deciding what future I want'"
var L1HObject5TextAI = "More and more we are asked to do a million things all at once. On top of that we are expected to excel at every one of them. This can be very stressful and it can harm us.\nLearning how to deal with stress is a survival skill you need to make it in this world.\nWhen you feel overwhelmed, take a moment for yourself. Close your eyes, take a few deep breaths and listen to your inner voice."
var L1HObject6TextAI = "Many of the problems we have today come from the same root.\nOver time, we became careless, disrespecting each other and our natural environment. Sometime in our journey we forgot that caring for each other and for our beautiful planet is fundamental to the survival of our species. If we want to save ourselves, we must relearn to empathise with other fellow humans and any other living being"
var currentLevel1ObjectExplored = "none"
var L2HObject1Text = "Object 21 text"
var L2HObject2Text = "Object 22 text"
var L2HObject3Text = "Object 23 text"
var L2HObject4Text = "Object 24 text"
var L2HObject5Text = "Object 25 text"
var currentLevel2ObjectExplored = "none"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

const ray_length = 10000

#creating array for collect/throw items
var arrNew = ["FootCube2", "BoxRigidBody2", "BottleRigidBody", "RigidBody", "RigidBody3", "RigidBodyL11", "RigidBodyL12", "RigidBodyL13", "RigidBodyL14", "RigidBodyL15", "RigidBodyL16", "RigidBodyL17", "RigidBodyL18", "RigidBodyL19"]
#creating array for recycle items
var arrRecycle = ["BoxRigidBody2", "BottleRigidBody"]
#creating array for resizable items
var arr = ["RigidBody", "RigidBody3", "FootCube2", "RigidBodyL17", "RigidBodyL18", "RigidBodyL19"]
#creating array for hover popup items
var arr2 = ["L1HObject1", "L1HObject2", "L1HObject3", "L1HObject4", "L1HObject5", "L1HObject6"]
#creating array for hover popup items
var arr3 = ["L2HObject1", "L2HObject2", "L2HObject3", "L2HObject4", "L2HObject5"]
		
func _physics_process(delta):
	get_node(".").cast_to = Vector3(0,0,-1) * ray_length
	if Input.is_action_just_pressed("left_click"):
		#print(get_node(".").get_collider().get_name())
		if get_node(".").get_collider() != null:
			if get_node(".").get_collider().get_name() in arr:
				get_node(".").get_collider().set_scale(get_node(".").get_collider().get_scale()*2)
	if Input.is_action_just_pressed("right_click"):
		if get_node(".").get_collider() != null:
			if get_node(".").get_collider().get_name() in arr:
				get_node(".").get_collider().set_scale(get_node(".").get_collider().get_scale()*0.5)
	if Input.is_action_just_pressed("remove"):
		if get_node(".").get_collider() != null:
			if get_node(".").get_collider().get_name() in arrNew:
				var rb = get_parent().get_parent().get_parent().get_parent().get_parent().get_node(get_node(".").get_collider().get_name())
				var sp = get_node("../../../../../../Viewports/ViewportContainer0/Viewport0/"+get_node(".").get_collider().get_name())
				if rb.get_scale() <= Vector3(1,1,1) and rb.visible == true and rb.global_transform.origin.distance_to(get_node("../../../..").global_transform.origin) <= 4:
					rb.visible = false
					sp.visible = true
					player1.numPoints = player1.numPoints + 10
					get_node("../../../../../../Viewports/VBoxContainer/ViewportContainer1/Viewport1/RichTextLabel4").text = "Points for collecting objects and recycling: "+str(player1.numPoints)
	if Input.is_action_just_pressed("throw"):
		if get_node(".").get_collider() != null:
			if get_node(".").get_collider().get_name() in arrNew:
				var rb = get_parent().get_parent().get_parent().get_parent().get_parent().get_node(get_node(".").get_collider().get_name())
				var sp = get_node("../../../../../../Viewports/ViewportContainer0/Viewport0/"+get_node(".").get_collider().get_name())
				if rb.visible == true and rb.global_transform.origin.distance_to(get_node("../../../..").global_transform.origin) <= 4:
					rb.start($"../../../../Robot/Position3D".global_transform)
					if get_node(".").get_collider().get_name() in arrRecycle and get_node("../../../..").global_transform.origin.distance_to(get_node("../../../../../bin_model2").global_transform.origin) <= 1:
						rb.visible = false
						sp.visible = true
						var icon = get_node("../../../../../../Viewports/ViewportContainer0/Viewport0/"+get_node(".").get_collider().get_name()+"/RecycleIcon")
						icon.visible = true
						player1.numPoints = player1.numPoints + 20
						get_node("../../../../../../Viewports/VBoxContainer/ViewportContainer1/Viewport1/RichTextLabel4").text = "Points for collecting objects and recycling: "+str(player1.numPoints)
	if get_node(".").get_collider() != null:
		if get_node(".").get_collider().get_name() in arr2 and currentLevel1ObjectExplored != get_node(".").get_collider().get_name():
			currentLevel1ObjectExplored = get_node(".").get_collider().get_name()
			$"../../../../../../Control/AcceptDialog".visible = false
			$"../../../../../../Control/AcceptDialog".dialog_text = get(get_node(".").get_collider().get_name()+"Text")
			$"../../../../../../Control/AcceptDialog".rect_position = Vector2(rng.randi_range(56, 756), rng.randi_range(50, 450))
			$"../../../../../../Control/AcceptDialog".popup()
		if !(get_node(".").get_collider().get_name() in arr2) and currentLevel1ObjectExplored in arr2:
			$"../../../../../../Control/AcceptDialog".visible = false
			$"../../../../../../Control/AcceptDialog".dialog_text = get(currentLevel1ObjectExplored+"TextAI")
			currentLevel1ObjectExplored = currentLevel1ObjectExplored + "AIText"
			$"../../../../../../Control/AcceptDialog".rect_position = Vector2(rng.randi_range(56, 756), rng.randi_range(50, 450))
			$"../../../../../../Control/AcceptDialog".popup()
			
	if get_node(".").get_collider() != null:
		if get_node(".").get_collider().get_name() in arr3 and currentLevel2ObjectExplored != get_node(".").get_collider().get_name():
			currentLevel2ObjectExplored = get_node(".").get_collider().get_name()
			$"../../../../../../Control/AcceptDialog".visible = false
			$"../../../../../../Control/AcceptDialog".dialog_text = get(get_node(".").get_collider().get_name()+"Text")
			$"../../../../../../Control/AcceptDialog".rect_position = Vector2(rng.randi_range(56, 756), rng.randi_range(50, 450))
			$"../../../../../../Control/AcceptDialog".popup()
			
	if $"../../../../../../Control/AcceptDialog".visible == false or ($"../../../../../../Control/AcceptDialog".dialog_text != L1HObject1Text and $"../../../../../../Control/AcceptDialog".dialog_text != L1HObject2Text and $"../../../../../../Control/AcceptDialog".dialog_text != L1HObject3Text and $"../../../../../../Control/AcceptDialog".dialog_text != L1HObject4Text and $"../../../../../../Control/AcceptDialog".dialog_text != L1HObject5Text and $"../../../../../../Control/AcceptDialog".dialog_text != L1HObject6Text and $"../../../../../../Control/AcceptDialog".dialog_text != L1HObject1TextAI and $"../../../../../../Control/AcceptDialog".dialog_text != L1HObject2TextAI and $"../../../../../../Control/AcceptDialog".dialog_text != L1HObject3TextAI and $"../../../../../../Control/AcceptDialog".dialog_text != L1HObject4TextAI and $"../../../../../../Control/AcceptDialog".dialog_text != L1HObject5TextAI and $"../../../../../../Control/AcceptDialog".dialog_text != L1HObject6TextAI):
		currentLevel1ObjectExplored = "none"
		
	if $"../../../../../../Control/AcceptDialog".visible == false or ($"../../../../../../Control/AcceptDialog".dialog_text != L2HObject1Text and $"../../../../../../Control/AcceptDialog".dialog_text != L2HObject2Text and $"../../../../../../Control/AcceptDialog".dialog_text != L2HObject3Text and $"../../../../../../Control/AcceptDialog".dialog_text != L2HObject4Text and $"../../../../../../Control/AcceptDialog".dialog_text != L2HObject5Text):
		currentLevel2ObjectExplored = "none"
		
