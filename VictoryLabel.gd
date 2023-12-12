extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()

func _on_door_door_entered():
	show()
