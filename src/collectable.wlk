import wollok.game.*
import randomizer.*
import main_character.*
import mosquito.*

object spiralBoxManager {

	const property spiralBoxBoard = []

	method createBoxSpirals() {
		game.onTick(3000, "CREAR CAJAS DE ESPIRALES", { self.makeTwoBoxSpirals()})
	}

//method createCollectable() {
//game.onTick(3000, self.typeOfCollectable(), {self.makeCollectable()}
//}
	method makeTwoBoxSpirals() {
		if (spiralBoxBoard.size() < 2) {
			spiralBoxBoard.add(spiralBoxFactory.makeBoxSpiral())
		}
	}

	method removeBoxSpiral(spiralBox) { // remove collectable
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

	method spiralEffect()

}

class SpiralBox inherits Element {

	method image() {
		return "trash01.png" // temporal hasta que tengamos imagen de caja de espirales
	}

	override method taken() {
		self.validateBag()
		bag.storeInBag()
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

	method activate() {
		game.onTick(500, "EFECTO ESPIRAL", { self.checkAndKill()})
	}

	method checkAndKill() {
		self.elementsArround()
	}

	method elementsArround() {
		const aroundPositions = #{ self.position(), self.position().up(1).left(1), self.position().left(1), self.position().left(1).down(1), self.position().down(1), self.position().down(1).right(1), self.position().right(1), self.position().right(1).up(1), self.position().up(1) }
		aroundPositions.forEach{ thisPosition => self.killArround(thisPosition)}
	}

	method killArround(thisPosition) {
		const savedItems = game.getObjectsIn(thisPosition)
		savedItems.forEach{ element => element.spiralEffect()}
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

	method storeInBag() {
		spirals = 5
	}

	method discountSpiral() {
		spirals -= 1
	}

}

