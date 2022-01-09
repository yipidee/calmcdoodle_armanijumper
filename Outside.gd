extends Node2D

const RESPONSES = ["nada", "absolutely nathin'", "nope", "nope didily no", "better luck next time"]

var dialogue
var outside_long_enough = false
var leaving = false
var areas_searched = 0

func _ready():
	$AudioStreamPlayer.play()
	randomize()


func player_notification(notification_text, time):
	$Cal.in_conversation = true
	$Text/CenterContainer/RichTextLabel.text = notification_text
	yield(get_tree().create_timer(time),"timeout")
	$Text/CenterContainer/RichTextLabel.text = ""
	$Cal.in_conversation = false


func _process(delta):
	for i in range(5):
		if Input.is_action_just_pressed("ui_accept") and get_node("SearchArea"+str(i+1)).overlaps_body($Cal):
			player_notification(RESPONSES[randi() % RESPONSES.size()], 0.5)
			update_searched_areas()
	
	if outside_long_enough and areas_searched > 1:
		if Input.is_action_just_pressed("ui_accept") and $DoorZone.overlaps_body($Cal):
			player_notification("Let's head back in", 1)
			leaving = true
			#yield(get_tree().create_timer(.7),"timeout")
	
	if leaving and not $Cal.in_conversation:
		get_tree().change_scene("res://Davnets2.tscn")


func _on_Timer_timeout():
	outside_long_enough = true


func update_searched_areas():
	areas_searched += 1
