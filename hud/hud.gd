extends CanvasLayer

signal start_game
signal switch

var player_health = 3

func _process(delta):
	$Health/HealthLabel.text = str("Health: ", player_health)

func _on_player_hurt():
	player_health -= 1

func _on_start_button_pressed():
	$StartButton.hide()
	$Title.hide()
	$SpritePicker/SpriteToggle.hide()
	$SpritePicker/ChooseYourSprite.hide()
	$SpritePicker/StockLabel.hide()
	$SpritePicker/RobotLabel.hide()
	start_game.emit()

func _on_sprite_toggle_pressed():
	switch.emit()
