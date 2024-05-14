import wollok.game.*
import randomizer.*
import main_character.*

object spiralBoxManager {

	const property spiralBoxBoard = []

	method makeBoxSpirals() {
		if (spiralBoxBoard.size() < 2) {
			spiralBoxBoard.add(spiralBoxFactory.makeBoxSpiral())
		}
	}

}

object spiralBoxFactory {

	method makeBoxSpiral() {
		const spiralBox = new SpiralBox()
		game.addVisual(spiralBox)
		return spiralBox
	}

}

class SpiralBox {

	var property position = randomizer.emptyPosition()
	const property spirals = 10

	method image() {
		return trash01.png // temporal hasta que tengamos imagen de caja de espirales
	}

	method esAtravesable() {
		return true
	}

	method esAgarrable() {
		return true
	}

	method taken(mainCharacter) {
		mainCharacter.guardarEnLaMochila()
	}

}

class Spiral {

	var property position = null

	method image() {
		return trash05.png // temporal hasta que tengamos imagen de espiral
	}

	method esAtravesable() {
		return true
	}

	method esAgarrable() {
		return true
	}

}

