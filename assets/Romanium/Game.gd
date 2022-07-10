extends ViewportContainer

func _ready():
	#	$Viewport/Sprite/Viewport2.material.set_shader_param("ViewportTexture", $Viewport/Sprite/Viewport.get_texture())
	pass


func _on_FadeInTimer_timeout():
	print(self.get_fade())
	if self.get_fade() < 1:
		set_fade(get_fade() + 0.02)
	else:
		$FadeOutTimer.stop()


func set_fade(alpha):
	self.modulate.a = alpha

func get_fade():
	return self.modulate.a

func start_fade_in():
	$FadeOutTimer.stop()
	$FadeInTimer.start()


func start_fade_out():
	$FadeInTimer.stop()
	$FadeOutTimer.start()

func _on_FadeOutTimer_timeout():
	print(self.get_fade())
	if self.get_fade() > 0:
		set_fade(get_fade() - 0.02)
	else:
		emit_signal('on_fade_complete')
		$FadeOutTimer.stop()


signal on_fade_complete
