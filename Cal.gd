extends KinematicBody2D

const WALKING_SPEED = 75

var last_direction
var in_conversation

func _ready():
	last_direction = Vector2(0,0)
	in_conversation = false

func _physics_process(delta):
	if not in_conversation:
		var v_x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		var v_y= Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		var dir = Vector2(v_x, v_y).normalized()
		move_and_slide(dir * WALKING_SPEED)
		
		# trigger relevant animations
		if dir.length() > 0:
			if dir.x > 0:
				$AnimationPlayer.play("Walking_right")
				last_direction = Vector2(1,0)
			elif dir.x < 0:
				$AnimationPlayer.play("Walking_left")
				last_direction = Vector2(-1,0)
			elif dir.y > 0:
				$AnimationPlayer.play("Walking_down")
				last_direction = Vector2(0,1)
			else:
				$AnimationPlayer.play("Walking_up")
				last_direction = Vector2(0,-1)
				
		elif $AnimationPlayer.is_playing():
			$AnimationPlayer.stop()
			if last_direction.x > 0:
				$Sprite.frame = 67
			elif last_direction.x < 0:
				$Sprite.frame = 76
			elif last_direction.y > 0:
				$Sprite.frame = 49
			else:
				$Sprite.frame = 58
