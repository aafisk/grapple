extends Sprite2D

signal door_entered

func _on_area_2d_body_entered(body):
	if(body.name  == "Player"):
		door_entered.emit()
