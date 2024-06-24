import wollok.game.*
import randomizer.*
import main_character.*
import mosquito.*
import obstacles.*
import globalConfig.*
import backpack.*

object elementManager {

	const property factories = [ trashFactory, vaccineFactory, refillFactory, spiralBoxFactory ]

	method build() {
		trashFactory.trashes().clear()
		spiralFactory.spirals().clear()
		(1 .. 3).forEach({ t => trashFactory.createSiPuedo()})
		factories.forEach({ factory => factory.exist(false)})
		game.onTick(2500, "CREAR ELEMENTOS", { self.createElement()})
	}

	method createElement() {
		factories.forEach({ factory => factory.createSiPuedo()})
	}

}

/* ELEMENTS */
class Element {

	var property position = randomizer.emptyPosition()

	method isSolid() {
		return false
	}

	method isTakeable() {
		return true
	}

	method collision() {
		self.take()
	}

	method take()

	method image()

}

class Vaccine inherits Element {

	override method image() = "vaccine.png"

	override method take() {
		mainCharacter.curar()
		vaccineFactory.removeElement(self)
	}

}

class Refill inherits Element {

	override method image() = "insecticide01.png"

	override method take() {
		insecticide.recargar()
		refillFactory.removeElement(self)
	}

}

object insecticide inherits Element {

	var property shoots = 4
	var property shootDistance = 3

	override method image() {
	}

	override method position() {
		return mainCharacter.position()
	}

	method direction() {
		return mainCharacter.direction()
	}

	method disparar() {
		self.restarDisparo()
		sprayFactory.createSprayBurst(shootDistance)
		self.killMosquitoes()
	}

	method killMosquitoes() {
		if (self.hayMosquitos(shootDistance)) {
			self.objetivos(shootDistance).forEach({ m => m.killed()})
		}
	}

	method restarDisparo() {
		shoots -= 1
	}

	method recargar() {
		shoots = 4
	}

	method tieneDisparos() {
		return shoots > 0
	}

	method hayMosquitos(alcance) {
		return !self.objetivos(alcance).isEmpty()
	}

	method objetivos(alcance) {
		return self.posiciones(alcance).map({ d => mosquitoesManager.mosquitoesEn(d) }).flatten()
	}

	method posiciones(alcance) {
		return (1 .. alcance).map({ n => self.direction().nextMove(self.position(), n) })
	}

	override method take() {
	}

}

// TODO: Resolver conflicto de dirección con picadura de mosquito hard
class Spray inherits Element {

	const cantidad
	var direction = mainCharacter.direction()
	var characterPosition = mainCharacter.position()

	override method position() {
		return direction.nextMove(characterPosition, cantidad)
	}

	override method image() = "spray.png"

	override method take() {
	}

	override method isTakeable() {
		return false
	}

}

class Trash inherits Element {

	var costumeNumber = (1 .. 5).anyOne().toString()

	override method image() = "trash0" + costumeNumber + ".png"

	override method take() {
		backpack.storeTrash()
		trashFactory.removeElement(self)
	}

}

class SpiralBox inherits Element {

	override method image() = "spiralbox.png"

	override method take() {
		backpack.reloadSpirals()
		spiralBoxFactory.removeElement(self)
	}

}

class Spiral inherits Element {

	const characterPosition = mainCharacter.position()

	override method image() = "spiral.png"

	override method position() {
		return characterPosition
	}

	method activate() {
		game.onTick(500, self.tickEvent(), { self.killMosquitos()})
	}

	method tickEvent() {
		return "EFECTO ESPIRAL" + self.identity()
	}

	method killMosquitos() {
		mosquitoesManager.mosquitoesAround(self).forEach({ m => m.killed()})
	}

	override method isTakeable() {
		return false
	}

	override method take() {
	}

	method remove() {
		game.removeVisual(self)
		game.removeTickEvent(self.tickEvent())
	}

}

/* FACTORIES */
class ElementFactory {

	var property exist = false

	method createSiPuedo() {
		if (self.puedeCrear()) {
			self.create()
		}
	}

	method create()

	method puedeCrear() {
		return !exist
	}

	method removeElement(element) {
		game.removeVisual(element)
		exist = false
	}

}

object vaccineFactory inherits ElementFactory {

	override method create() {
		var vaccine = new Vaccine()
		game.addVisual(vaccine)
		exist = true
	}

	override method puedeCrear() {
		return mainCharacter.isSick() && super()
	}

}

object refillFactory inherits ElementFactory {

	override method create() {
		var refill = new Refill()
		game.addVisual(refill)
		exist = true
	}

	override method puedeCrear() {
		return !mainCharacter.myInsecticide().tieneDisparos() && super()
	}

}

object sprayFactory {

	method createSprayBurst(shootDistance) {
		self.createSprayBurstRecursivo(shootDistance, 1)
	}

	method createSprayBurstRecursivo(shootDistance, current) {
		if (current <= shootDistance && self.puedeCrear(current)) {
			self.create(current)
			self.createSprayBurstRecursivo(shootDistance, current + 1)
		}
	}

	method create(size) {
		var spray = new Spray(cantidad = size)
		game.addVisual(spray)
		game.schedule(200, { game.removeVisual(spray)})
	}

	method createSiPuedo(size) {
		if (self.puedeCrear(size)) {
			self.create(size)
		}
	}

	method puedeCrear(size) {
		var pos = mainCharacter.direction().nextMove(mainCharacter.position(), size)
		return limit.in(pos) && !obstacleManager.isObstacleIn(pos)
	}

}

object trashFactory inherits ElementFactory {

	const property trashes = []

	override method create() {
		const trash = new Trash()
		trashes.add(trash)
		game.addVisual(trash)
	}

	override method puedeCrear() {
		return trashes.size() < 3
	}

	override method removeElement(elementTrash) {
		game.removeVisual(elementTrash)
		self.trashes().remove(elementTrash)
	}

}

object spiralFactory inherits ElementFactory {

	const property spirals = []

	override method create() {
		const spiral = new Spiral()
		spirals.add(spiral)
		game.addVisual(spiral)
		spiral.activate()
		game.schedule(6000, {=> self.removeElement(spiral)})
	}

	override method puedeCrear() {
		return backpack.hasSpirals()
	}

	override method removeElement(elementSpiral) {
		elementSpiral.remove()
		self.spirals().remove(elementSpiral)
	}

}

object spiralBoxFactory inherits ElementFactory {

	override method create() {
		var spiralBox = new SpiralBox()
		game.addVisual(spiralBox)
		exist = true
	}

	override method puedeCrear() {
		return !backpack.hasSpirals() && super()
	}

}

