extends StaticBody2D

signal hazard_entered

func _on_area_2d_body_entered(body):
	if(body.name  == "player"):
		hazard_entered.emit()
