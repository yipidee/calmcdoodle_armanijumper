extends KinematicBody2D

const DIRECTIONS = {
	"down" : 45,
	"up" : 54,
	"left" : 72,
	"right" : 63
}

const WALKING_SPEED = 75

var is_drunk = false
var in_conversation = false
var computer_controlled = true
var last_direction = "down"

func _physics_process(_delta):
	if not is_drunk:
		if computer_controlled:
			if not in_conversation:
				var pathnode = get_parent()
				if pathnode.unit_offset < 0.13:
					$AnimationPlayer.play("Walking_down")
					last_direction = "down"
				elif pathnode.unit_offset < 0.5:
					$AnimationPlayer.play("Walking_right")
					last_direction = "right"
				elif pathnode.unit_offset < 0.87:
					$AnimationPlayer.play("Walking_left")
					last_direction = "left"
				else:
					$AnimationPlayer.play("Walking_up")
					last_direction = "up"
			else:
				$AnimationPlayer.stop()
				$Sprite.frame = DIRECTIONS[last_direction]
		else:
			if not in_conversation:
				var v_x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
				var v_y= Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
				var dir = Vector2(v_x, v_y).normalized()
				move_and_slide(dir * WALKING_SPEED)
				
				# trigger relevant animations
				if dir.length() > 0:
					if dir.x > 0:
						$AnimationPlayer.play("Walking_right")
						last_direction = "right"
					elif dir.x < 0:
						$AnimationPlayer.play("Walking_left")
						last_direction = "left"
					elif dir.y > 0:
						$AnimationPlayer.play("Walking_down")
						last_direction = "down"
					else:
						$AnimationPlayer.play("Walking_up")
						last_direction = "up"
						
				elif $AnimationPlayer.is_playing():
					$AnimationPlayer.stop()
					$Sprite.frame = DIRECTIONS[last_direction]
	else:
		$AnimationPlayer.play("Drunk")
