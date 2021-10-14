class_name MyClass extends MainLoop


var time_elapsed = 0

func _initialize():
	print("Initialized:")
	print("  Starting time: %s" % str(time_elapsed))

func _idle(delta):
	time_elapsed += delta


func _finalize():
	print("Finalized:")
	print("  End time: %s" % str(time_elapsed))

