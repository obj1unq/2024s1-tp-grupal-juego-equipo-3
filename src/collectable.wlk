import wollok.game.*
import randomizer.*
import main_character.*
import mosquito.*

object elementManager {

	const property factories = [ spiralBoxFactory, sprayFactory, trashFactory ]

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

	method removeThis(elementX)

}

object spiralFactory inherits ElementFactory {

	const property spirals = []

	override method create() {
		const spiral = new Spiral()
		spirals.add(spiral)
		game.addVisual(spiral)
		game.onTick(500, "EFECTO ESPIRAL", { spiral.activate()})
		game.schedule(5000, {=> self.removeThis(spiral)})
	}

	override method canCreate() {
		return spirals.size() < 5
	}

	override method removeThis(elementSpiral) {
		game.removeVisual(elementSpiral)
		self.spirals().remove(elementSpiral)
	}

}

object spiralBoxFactory inherits ElementFactory {

	var element = null

	override method create() {
		element = spiralBox
		game.addVisual(element)
	}

	override method canCreate() {
		return not (element == spiralBox)
	}

	override method removeThis(elementSpiralBox) {
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

	override method removeThis(elementTrash) {
		game.removeVisual(elementTrash)
		self.trashes().remove(elementTrash)
	}

}

object sprayFactory inherits ElementFactory {

	var element = null

	override method create() {
		element = spray
		game.addVisual(element)
	}

	override method canCreate() {
		return not (element == spray)
	}

	override method removeThis(elementSpray) {
		game.removeVisual(elementSpray)
		element = null
	}

}

object antidoteFactory inherits ElementFactory {

	const element = antidote

	override method create() {
		game.addVisual(element)
	}

	override method canCreate() {
		return true
	}

	override method removeThis(elementAntidote) {
		game.removeVisual(elementAntidote)
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

object antidote inherits Element {

	method image() {
		return "antidote" + ".png"
	}

	override method take() {
		mainCharacter.recuperarVida()
		antidoteFactory.removeThis(self)
	}

}

object spiralBox inherits Element {

	method image() {
		return "spiralbox" + ".png"
	}

	override method take() {
		bag.storeSpiral()
		spiralBoxFactory.removeThis(self)
	}

}

object spray inherits Element {

	method image() {
		return "insecticide01" + ".png"
	}

	override method take() {
		mainCharacter.equipSpray()
		sprayFactory.removeThis(self)
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
		trashFactory.removeThis(self)
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

	override method take() {
	}

}

object bag {

	var property spiral = 0
	var property trash = 0

//	var property mosquito = 0
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

