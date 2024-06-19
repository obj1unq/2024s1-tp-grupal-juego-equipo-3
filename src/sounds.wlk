import wollok.game.*

object soundProducer {

	var cancion = null
	var provider = game
	var volumenFX = 0.1
	var volumenMusica = 0.2

	method provider(_provider) {
		provider = _provider
	}

	method sound(audioFile) {
		const audio = provider.sound(audioFile)
		audio.volume(volumenFX)
		return audio
	}
	method soundMusic(audioFile) {
		const audio = provider.sound(audioFile)
		audio.volume(volumenMusica)
		return audio
	}

	method subirVolumenFX() {
		volumenFX = (volumenFX + 0.1).min(1)
	}

	method bajarVolumenFX() {
		volumenFX = (volumenFX - 0.1).max(0)
	}

	method subirVolumenMusica() {
	if (cancion!=(null)) {	
		volumenMusica = (volumenMusica + 0.1).min(1)
		cancion.volume(volumenMusica)
		}
	}

	method bajarVolumenMusica() {
	if (cancion!=(null)) {	
		volumenMusica = (volumenMusica - 0.1).max(0)
		cancion.volume(volumenMusica)
		}
	}

	method playCancion(audioFile) {
		cancion = provider.sound(audioFile)
		cancion.volume(volumenMusica)
		cancion.play()
	}
	
	method sacarCancion() {
		cancion.stop()
		cancion = null
	}

}

object soundProviderMock {

	method sound(audioFile) = soundMock

}

object soundMock {

	   method pause(){}

    method paused() = true

    method play(){}

    method played() = false

    method resume(){}

    method shouldLoop(looping){}

    method shouldLoop() = false

    method stop(){}

    method volume(newVolume){}

    method volume() = 0
	
	

}


object settingsMusica {
	method iniciarTeclas() {
		keyboard.z().onPressDo({ soundProducer.bajarVolumenFX()})
		keyboard.a().onPressDo({ soundProducer.subirVolumenFX()})
		keyboard.x().onPressDo({ soundProducer.bajarVolumenMusica()})
		keyboard.s().onPressDo({ soundProducer.subirVolumenMusica()})
	}
}