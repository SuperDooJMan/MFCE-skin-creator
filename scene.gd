@tool
extends Node2D

@export
var grid_size: Vector2 = Vector2.ONE * 16.0 :
	set(value):
		grid_size = value
		queue_redraw()

@export
var color: Color = Color.DIM_GRAY :
	set(value):
		queue_redraw()
		color = value

func _draw():
	var vp_size: = get_viewport_rect().size
	var cam_pos: = Vector2.ZERO
	var vp_right: = vp_size.x
	var vp_bottom: = vp_size.y
	
	var leftmost: = -vp_right + cam_pos.x
	var topmost: = -vp_bottom + cam_pos.y
	
	var left: float = ceil(leftmost / grid_size.x) * grid_size.x
	var bottommost: = vp_bottom + cam_pos.y
	for x in range(0, (vp_size.x / grid_size.x) * 2 + 1):
		draw_line(Vector2(left, topmost), Vector2(left, bottommost), color)
		left += grid_size.x

	var top: float = ceil(topmost / grid_size.y) * grid_size.y
	var rightmost: = vp_right + cam_pos.x
	for y in range(0, (vp_size.y / grid_size.y) * 2 + 1):
		draw_line(Vector2(leftmost, top), Vector2(rightmost, top), color)
		top += grid_size.y
	
	draw_line(Vector2(0, vp_size.y),Vector2(0, -vp_size.y), Color.GREEN)
	draw_line(Vector2(vp_size.x, 0),Vector2(-vp_size.x, 0), Color.RED)


#func _process(delta: float) -> void:
	#if Engine.is_editor_hint():
		#return
#
#func _physics_process(delta: float) -> void:
	#if Engine.is_editor_hint():
		#return
