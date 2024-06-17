import wollok.game.*
import randomizer.*
import main_character.*
import mosquito.*

class Element {

	const property position = randomizer.emptyPosition()

	method isSolid() {
		return false
	}

	method isTakeable() {
		return true
	}

	method createIfICan() {
		if (self.canCreate()) {
			self.create()
		}
	}

	method create()

	method canCreate()

	method take()

}

//object initialElementManager {
//
//	const property factories = [ spiralBoxFactory ] // basuraFactory 
//
//	method createElement() {
//		factories.forEach({ f => f.create()})
//	}
//
//}
//class ElementFactory {
//
//	method createSiPuedo() {
//		if (self.puedeCrear()) {
//			self.create()
//		}
//	}
//
//	method create() {
//	}
//
//	method puedeCrear()
//
//}
//object spiralBoxFactory inherits ElementFactory {
//
//	var spiralBoxActual = null
//
//	override method create() {
//		const spiralBox = new SpiralBox()
//		game.addVisual(spiralBox)
//		spiralBoxActual = spiralBox
//	}
//
//	override method puedeCrear() {
//		return spiralActual == null
//	}
//
//	method removeBoxSpiral() {
//		game.removeVisual(spiralActual)
//		spiralBoxActual = null
//	}
//
//}
object spiralBox inherits Element {

	var estado = null

	method image() {
		return "spiralbox" + ".png"
	}

	override method create() {
		game.addVisual(self)
	}

	override method canCreate() {
		return estado == null
	}

	method removeBoxSpiral() {
		game.removeVisual(self)
		estado = null
	}

	override method take() {
		bag.storeInBag()
		self.removeBoxSpiral()
	}

}

//object spiralFactory inherits ElementFactory {
//
//	override method puedeCrear() {
//		return game.getObjectsIn(position).isEmpty()
//	}
//
//}
/*object TrashFactory {
 * 	
 * }
 */
class Spiral inherits Element {

	var property newPosition = null

	override method position() {
		return newPosition
	}

	method image() {
		return "spiral" + ".png"
	}

	method activate() {
		game.onTick(500, "EFECTO ESPIRAL", { self.killMosquitos()})
	}

	method killMosquitos() {
		mosquitosManager.mosquitoesAround(self).forEach({ element => element.spiralEffect()})
	}

	override method isTakeable() {
		return false
	}

}

object bag {

	var property spirals = 0
	var property trashes = 0
	var property mosquitoes = 0

	method storeInBag() {
		self.validateBag()
		spirals = 5
	}

	method discountSpiral() {
		spirals -= 1
	}

	method validateBag() {
		if (self.spirals() > 0) {
			self.error("todavía tengo espirales en la caja")
		}
	}

}

