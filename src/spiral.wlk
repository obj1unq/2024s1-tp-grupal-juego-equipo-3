import wollok.game.*
import randomizer.*
import main_character.*

object spiralBoxManager {

	const property spiralBoxBoard = []

	method createBoxSpirals() {
		game.onTick(3000, "CREAR CAJAS DE ESPIRALES", { self.makeTwoBoxSpirals()})
	}

	method makeTwoBoxSpirals() {
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

	method isSolid() {
		return false
	}

	method isTakeable() {
		return true
	}

	method taken(personaje)

}

class SpiralBox inherits Element {

	var property spirals = 5

	method image() {
		return "trash01.png" // temporal hasta que tengamos imagen de caja de espirales
	}

	override method taken(personaje) {
		self.validateBag(personaje)
		personaje.storeInBag(self)
		spiralBoxManager.removeBoxSpiral(self)
	}
// TODO: hacer un objeto MOCHILA que guarde diferentes atributos (chatarra, mosquitos, spirales)
	method validateBag(personaje) {
		if (personaje.bag().contains(self)) {
			self.error("no puedo guardar más cajas de espirales")
		}
	}

}

class Spiral {

	var property position = null

	method image() {
		return "trash05.png" // temporal hasta que tengamos imagen de espiral
	}

	method isSolid() {
		return false
	}

	method isTakeable() {
		return true
	}

}

