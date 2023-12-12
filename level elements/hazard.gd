extends StaticBody2D

signal hazard_entered

var advance
var speed = 15.0

func _ready():
	advance = false

func _on_area_2d_body_entered(body):
	if(body.name  == "Player"):
		hazard_entered.emit()

func _on_hud_start_game():
	pass
#	$AnimatedSprite2D.animation = "default"
#	$AnimatedSprite2D.play()
#	$Blades.animation = "default"
#	$Blades.play()
