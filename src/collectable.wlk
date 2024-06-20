import wollok.game.*
import randomizer.*
import main_character.*
import mosquito.*

object elementManager {

	const property factories = [ spiralBoxFactory, trashFactory ]

	method createElement() {
		factories.forEach({ factory => factory.createIfICan()})
	}

}

class ElementFactory {

	method createIfICan() {
		if (self.canCreate()) {
			self.create()
		}
	}

	method create()

	method canCreate()

	method remove(elementX)

}

object spiralBoxFactory inherits ElementFactory {

	var element = null

	override method create() {
		element = spiralBox
		game.addVisual(element)
	}

	override method canCreate() {
		return not element == spiralBox
	}

	override method remove(elementSpiralBox) {
		game.removeVisual(elementSpiralBox)
		element = null
	}

}

object trashFactory inherits ElementFactory {

	const property trashes = []

	override method create() {
		const trash = new Trash()
		trashes.add(trash)
		game.addVisual(trash)
	}

	override method canCreate() {
		return trashes.size() < 3
	}

	override method remove(elementTrash) {
		game.removeVisual(elementTrash)
		self.trashes().remove(elementTrash)
	}

}

object antidoteFactory inherits ElementFactory {

	const property antidotes = []

	override method create() {
		const antidote = new Antidote()
		antidotes.add(antidote)
		game.addVisual(antidote)
	}

	override method canCreate() {
	}

	override method remove(elementAntidote) {
		game.removeVisual(elementAntidote)
		self.antidotes().remove(elementAntidote)
	}

}

class Element {

	const property position = randomizer.emptyPosition()

	method isSolid() {
		return false
	}

	method isTakeable() {
		return true
	}

	method take()

}

class Antidote inherits Element {

	method image() {
		return "antidote" + ".png"
	}

	override method take() {
		mainCharacter.recuperarVida()
	}

}

object spiralBox inherits Element {

	method image() {
		return "spiralbox" + ".png"
	}

	override method take() {
		bag.storeSpiral()
		spiralBoxFactory.remove(self)
	}

}

class Trash inherits Element {

	method image() {
		return "trash0" + self.typeOf() + ".png"
	}

	method typeOf() {
		return 1.randomUpTo(5).roundUp(0)
	}

	override method take() {
		bag.storeTrash()
		trashFactory.remove(self)
	}

}

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

	var property spiral = 0
	var property trash = 0
	var property mosquito = 0

	method storeSpiral() {
		self.validateSpiral()
		spiral = 5
	}

	method discountSpiral() {
		spiral -= 1
	}

	method storeTrash() {
		trash += 1
	}

	method validateSpiral() {
		if (spiral > 0) {
			self.error("todavía tengo espirales en la caja")
		}
	}

}

