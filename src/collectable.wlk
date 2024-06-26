import wollok.game.*
import randomizer.*
import mainCharacter.*
import mosquitoes.*
import obstacles.*
import globalConfig.*
import backpack.*
import sounds.*

object elementManager {

	const property factories = [ trashFactory, vaccineFactory, refillFactory, spiralBoxFactory ]

	method build() {
		trashFactory.trashes().clear()
		spiralFactory.spirals().clear()
		(1 .. 3).forEach({ t => trashFactory.createIfPossible()})
		factories.forEach({ factory => factory.exist(false)})
		game.onTick(2500, "CREATE ELEMENTS", { self.createElement()})
	}

	method createElement() {
		factories.forEach({ factory => factory.createIfPossible()})
	}

}

//Elements
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

	method take() {
		soundProducer.playEffect("picking.mp3")
	}

	method image()

}

class Vaccine inherits Element {

	override method image() = "vaccine.png"

	override method take() {
		mainCharacter.heal()
		vaccineFactory.removeElement(self)
	}

}

class Refill inherits Element {

	override method image() = "insecticide01.png"

	override method take() {
		super()
		insecticide.reload()
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

	method shoot() {
		self.decrementShot()
		sprayFactory.createSprayBurst(shootDistance)
		self.killMosquitoes()
	}

	method killMosquitoes() {
		if (self.hasMosquitoes(shootDistance)) {
			self.targets(shootDistance).forEach({ m => m.killed()})
		}
	}

	method decrementShot() {
		shoots -= 1
	}

	method reload() {
		shoots = 4
	}

	method hasShots() {
		return shoots > 0
	}

	method hasMosquitoes(range) {
		return !self.targets(range).isEmpty()
	}

	method targets(range) {
		return self.positions(range).map({ d => mosquitoesManager.mosquitoesAt(d) }).flatten()
	}

	method positions(range) {
		return (1 .. range).map({ n => self.direction().nextMove(self.position(), n) })
	}

	override method take() {
	}

}

class Spray inherits Element {

	const positionNumber
	var direction = mainCharacter.direction()
	var characterPosition = mainCharacter.position()

	override method position() {
		return direction.nextMove(characterPosition, positionNumber)
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
		super()
		backpack.storeTrash()
		trashFactory.removeElement(self)
	}

}

class SpiralBox inherits Element {

	override method image() = "spiralbox.png"

	override method take() {
		super()
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
		game.onTick(500, self.tickEvent(), { self.killMosquitoes()})
	}

	method tickEvent() {
		return "SPIRAL EFFECT" + self.identity()
	}

	method killMosquitoes() {
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

//Factories
class ElementFactory {

	var property exist = false

	method createIfPossible() {
		if (self.canCreate()) {
			self.create()
		}
	}

	method create() {
	}

	method canCreate() {
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

	override method canCreate() {
		return mainCharacter.isSick() && super()
	}

}

object refillFactory inherits ElementFactory {

	override method create() {
		var refill = new Refill()
		game.addVisual(refill)
		exist = true
	}

	override method canCreate() {
		return !insecticide.hasShots() && super()
	}

}

object sprayFactory {

	method createSprayBurst(range) {
		self.createRecursiveSprayBurst(range, 1)
	}

	method createRecursiveSprayBurst(range, currentNumber) {
		if (currentNumber <= range && self.canCreate(currentNumber)) {
			self.create(currentNumber)
			self.createRecursiveSprayBurst(range, currentNumber + 1)
		}
	}

	method create(currentNumber) {
		var spray = new Spray(positionNumber = currentNumber)
		game.addVisual(spray)
		game.schedule(200, { game.removeVisual(spray)})
	}

	method canCreate(currentNumber) {
		var position = mainCharacter.direction().nextMove(mainCharacter.position(), currentNumber)
		return limit.in(position) && !obstacleManager.isObstacleIn(position)
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

	override method canCreate() {
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

	override method canCreate() {
		return !backpack.hasSpirals() && super()
	}

}

