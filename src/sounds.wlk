import wollok.game.*

object soundProducer {

	var cancion = null
	var provider = game
	var volumenGeneral = 0.4

	method provider(_provider) {
		provider = _provider
	}

	method soundEffect(audioFile) {
		const audio = provider.sound(audioFile)
		audio.volume(volumenGeneral)
		return audio
	}

	method soundMusic(audioFile) {
		const audio = provider.sound(audioFile)
		cancion = audio
		audio.volume(volumenGeneral)
		audio.shouldLoop(true)
		return audio
	}

	method subirVolumenMusica() {
		volumenGeneral = (volumenGeneral + 0.1).min(1)
		if (cancion != null) {
			cancion.volume(volumenGeneral)
		}
	}

	method bajarVolumenMusica() {
		volumenGeneral = (volumenGeneral - 0.1).max(0)
		if (cancion != null) {
			cancion.volume(volumenGeneral)
		}
	}

	method playCancion(audioFile) {
		self.soundMusic(audioFile).play()
	}

	method playEffect(audioFile) {
		self.soundEffect(audioFile).play()
	}

	method sacarCancion() {
		if (cancion != null){
			cancion.stop()	
		}
		cancion = null
	}

	method configurateSettings() {
		keyboard.q().onPressDo{ self.subirVolumenMusica()}
		keyboard.a().onPressDo{ self.bajarVolumenMusica()}
	}

}

object soundProviderMock {

	method sound(audioFile) = soundMock

}

object soundMock {

	method pause() {
	}

	method paused() = true

	method play() {
	}

	method played() = false

	method resume() {
	}

	method shouldLoop(looping) {
	}

	method shouldLoop() = false

	method stop() {
	}
	
	method volume(newVolume) {
	}

	method volume() = 0

}

