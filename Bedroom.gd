extends Node2D

signal next

var dialogue
var can_check = false
var has_checked_drawers1 = false
var has_checked_drawers2 = false
var has_checked_under_bed1 = false
var has_checked_under_bed2 = false
var chat1_done = false
var chat2_done = false

func _ready():
	dialogue = Dialogue.Script
	$AudioStreamPlayer.play()


func _input(event):
	if event.is_action_pressed("ui_accept"):
		emit_signal("next")


func read_script(passage):
	$Cal.in_conversation = true
	for line in dialogue[passage]:
		$Text/CenterContainer/RichTextLabel.text = line
		yield(self, "next")
	$Text/CenterContainer/RichTextLabel.text = ""
	$Cal.in_conversation = false


func player_notification(notification_text, time):
	$Cal.in_conversation = true
	$Text/CenterContainer/RichTextLabel.text = notification_text
	yield(get_tree().create_timer(time),"timeout")
	$Text/CenterContainer/RichTextLabel.text = ""
	$Cal.in_conversation = false
	

func _process(_delta):
	#Cal going to door first time
	if Input.is_action_just_pressed("ui_accept") and $DoorZone.overlaps_body($Cal) and not chat1_done:
		chat1_done = true
		read_script("bronagh1")
		can_check = true
	
	if can_check:
		if has_checked_drawers1 and has_checked_drawers2 and has_checked_under_bed1 and has_checked_under_bed2 and not chat2_done:
			if Input.is_action_just_pressed("ui_accept") and $DoorZone.overlaps_body($Cal):
				chat2_done = true
				read_script("bronagh2")
		else:
			if Input.is_action_just_pressed("ui_accept") and $Bed1Zone.overlaps_body($Cal):
				player_notification("Nothing under this bed (that you want to acknowledge the existence of)", 1.5)
				has_checked_under_bed1 = true
			if Input.is_action_just_pressed("ui_accept") and $Bed2Zone.overlaps_body($Cal):
				player_notification("Nothing under this bed", 1.5)
				has_checked_under_bed2 = true
			if Input.is_action_just_pressed("ui_accept") and $Drawer1Zone.overlaps_body($Cal):
				player_notification("It's not in here", 1.5)
				has_checked_drawers1 = true
			if Input.is_action_just_pressed("ui_accept") and $Drawer2Zone.overlaps_body($Cal):
				player_notification("Not in here. (Didn't think Roger'd be into that kind of thing)", 2)
				has_checked_drawers2 = true
	
	if chat2_done and not $Cal.in_conversation:
		yield(get_tree().create_timer(1),"timeout")
		get_tree().change_scene("res://Davnets.tscn")

