extends Node3D


func trigger():
	GameState.checkpoint = self
	$OmniLight3D.omni_range = 5.0
	$Smoke.emitting = true
	$Fire.emitting = true
	$TriggerArea.queue_free()
