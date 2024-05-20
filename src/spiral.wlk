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

	method removeBoxSpiral(spiralBox) {
		game.removeVisual(spiralBox)
		spiralBoxBoard.remove(spiralBox)
	}

}

object spiralBoxFactory {

	method makeBoxSpiral() {
		const spiralBox = new SpiralBox()
		game.addVisual(spiralBox)
		return spiralBox
	}

}

class Element {

	var property position = randomizer.emptyPosition()

	method esAtravesable() {
		return true
	}

	method esAgarrable() {
		return true
	}

	method taken(mainCharacter)

}

class SpiralBox inherits Element {

	var property spirals = 10

	method image() {
		return "trash01.png" // temporal hasta que tengamos imagen de caja de espirales
	}

	override method taken(personaje) {
		self.validateElement()
		self.validateMochila(personaje)
		personaje.guardarEnLaMochila(self)
		spiralBoxManager.removeBoxSpiral(self)
	}

	method validateMochila(personaje) {
		if (not (personaje.mochila().any(self))) {
			self.error("no puedo guardar más cajas de espirales")
		}
	}

	method validateElement() {
		if (not self.esAgarrable()) {
			self.error("no lo puedo agarrar")
		}
	}

}

class Spiral {

	var property position = null

	method image() {
		return "trash05.png" // temporal hasta que tengamos imagen de espiral
	}

	method esAtravesable() {
		return true
	}

	method esAgarrable() {
		return true
	}

}

