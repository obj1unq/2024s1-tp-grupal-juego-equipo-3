import wollok.game.*
import wollok.game.*

object soundProducer {

	var song = null
	var provider = game
	var generalVolume = 0.4

	method provider(_provider) {
		provider = _provider
	}

	method soundEffect(audioFile) {
		const audio = provider.sound(audioFile)
		audio.volume(generalVolume)
		return audio
	}

	method soundMusic(audioFile) {
		const audio = provider.sound(audioFile)
		song = audio
		audio.volume(generalVolume)
		audio.shouldLoop(true)
		return audio
	}

	method increaseMusicVolume() {
		generalVolume = (generalVolume + 0.1).min(1)
		if (song != null) {
			song.volume(generalVolume)
		}
	}

	method decreaseMusicVolume() {
		generalVolume = (generalVolume - 0.1).max(0)
		if (song != null) {
			song.volume(generalVolume)
		}
	}

	method playSong(audioFile) {
		self.soundMusic(audioFile).play()
	}

	method playEffect(audioFile) {
		self.soundEffect(audioFile).play()
	}

	method stopSong() {
		if (song != null) {
			song.stop()
			song = null
		}
	}

	method configureSettings() {
		keyboard.q().onPressDo{ self.increaseMusicVolume()}
		keyboard.a().onPressDo{ self.decreaseMusicVolume()}
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

