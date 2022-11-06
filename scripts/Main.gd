extends Spatial

export(PackedScene) var mob_scene

func _ready():
	randomize()
	
	$UserInterface/Retry.hide()

func _on_MobTimer_timeout():
	var mob = mob_scene.instance()
	
	var mob_spawn_location = $SpawnPath/SpawnLocation;
	mob_spawn_location.unit_offset = randf()
	
	var player_position = $Player.transform.origin
	mob.initializate(mob_spawn_location.translation, player_position)
	mob.connect("squashed", $UserInterface/ScoreLabel, "_on_Mob_squashed")
	
	add_child(mob)

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		get_tree().reload_current_scene()

func _on_Player_hit():
	$MobTimer.stop()
	$UserInterface/Retry.show()
