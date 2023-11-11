extends Sprite2D

@onready var ray_cast = $RayCast2D
var distance: float = 500.0
@export var grapple_time = 0.1
@export var hang_time = 0.1
@export var grapple_time_reverse = 0.75
@export var fired = false
 
signal hooked(hooked_position)

func interpolate(length, duration = 0.1):
	var tween_offset = get_tree().create_tween()
	var tween_rect_h = get_tree().create_tween()

	tween_offset.tween_property(self, "offset", Vector2(0, length / 2.0), duration)
	tween_rect_h.tween_property(self, "region_rect", Rect2(0, 0, 8, length), duration)

func reverse_interpolate():
	interpolate(0, grapple_time_reverse)

func launch_grapple():
#	if event.is_action_pressed("grapple"):
	fired = true

	interpolate(await check_collision(), grapple_time)
	await get_tree().create_timer(grapple_time).timeout
	await get_tree().create_timer(hang_time).timeout
	reverse_interpolate()
	await get_tree().create_timer(grapple_time_reverse).timeout
	fired = false

func look_in_direction(direction):
	look_at(direction)

func check_collision():
	await get_tree().create_timer(grapple_time).timeout
	var collision_point
	if ray_cast.is_colliding():
		collision_point = ray_cast.get_collision_point()
		distance = (global_position - collision_point).length()
		hooked.emit(collision_point)
	else:
		distance = 500.0
	return distance
