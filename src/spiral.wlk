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

	method taken()

}

class SpiralBox inherits Element {

	method image() {
		return "trash01.png" // temporal hasta que tengamos imagen de caja de espirales
	}

	override method taken() {
		self.validateBag()
		bag.storeInBag(self)
		spiralBoxManager.removeBoxSpiral(self)
	}

	method validateBag() {
		if (bag.spirals() > 0) {
			self.error("todavía tengo espirales en la caja")
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

object bag {

	var property spirals = 0
	var property trashes = 0
	var property mosquitoes = 0

	method storeInBag(element) {
		spirals = 5
	}

	method discountSpiral() {
		spirals -= 1
	}

}

