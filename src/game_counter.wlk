import wollok.game.*

object textColours {

	const property red = "FF0000FF"
	const property green = "00FF00FF"

}

object endGame {

	const property position = game.at(10, 9)

	method text() {
		return "game ended"
	}

	method finish() {
		gameCounter.stop()
		game.clear()
		game.addVisual(self)
	}

}

object gameCounter {

	const gameDuration = 91
	const tickEventName = 'gameCounterTick'
	var property time = 0
	const property position = game.at(15, 14)

	method text() {
		return time.stringValue()
	}

	method isTimeRunningOut() {
		return time < 10
	}

	method textColor() {
		return if (self.isTimeRunningOut()) textColours.red() else textColours.green()
	}

	method start() {
		self.time(gameDuration)
		game.onTick(1000, tickEventName, {=> time--})
	}

	method stop() {
		game.removeTickEvent(tickEventName)
	}

	method isTimeout() {
		return time == 0
	}

}

