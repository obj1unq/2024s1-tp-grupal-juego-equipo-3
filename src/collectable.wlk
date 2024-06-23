import wollok.game.*
import randomizer.*
import main_character.*
import mosquito.*
import obstacles.*
import globalConfig.*

object elementManager {

	const property factories = [ trashFactory, vaccineFactory, refillFactory, spiralBoxFactory ]

	method createElement() {
		factories.forEach({ factory => factory.createSiPuedo()})
	}

}

object bag {

	var property spirals = 0
	var property trashes = 0
	var property mosquitoes = 0

	method reloadSpirals() {
		spirals = 5
	}

	method discountSpiral() {
		spirals -= 1
	}

	method hasSpirals() {
		return spirals > 0
	}

	method addMosquito() {
		mosquitoes += 1
	}

	method storeTrash() {
		trashes += 1
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

object vaccine inherits Element {

	override method image() = "vaccine.png"

	override method take() {
		mainCharacter.curar()
		vaccineFactory.removeElement(self)
	}

}

object refill inherits Element {

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

	// TODO: Revisar, a veces sigue fallando.
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
		return self.posiciones(alcance).map({ d => mosquitosManager.mosquitosEn(d) }).flatten()
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

	override method image() = "spray" + cantidad + ".png"

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
		bag.storeTrash()
		trashFactory.removeElement(self)
	}

}

object spiralBox inherits Element {

	override method image() = "spiralbox.png"

	override method take() {
		bag.reloadSpirals()
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
		mosquitosManager.mosquitoesAround(self).forEach({ m => m.killed()})
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
		game.addVisual(vaccine)
		exist = true
	}

	override method puedeCrear() {
		return mainCharacter.isSick() && super()
	}

}

object refillFactory inherits ElementFactory {

	override method create() {
		game.addVisual(refill)
		exist = true
	}

	override method puedeCrear() {
		return !mainCharacter.myInsecticide().tieneDisparos() && super()
	}

}

object sprayFactory {

	// TODO: Consultar sobre polimorfismo. Ahora se aplica sin heredar de elementFactory
	// TODO: Por polimorfismo, hay que cambiar todos los métodos (agregar parámetros)
	// TODO: Ver disparos sobre obstáculos + Limitar disparos
	method createSprayBurst(shootDistance) {
		(1 .. shootDistance).forEach({ i => self.createSiPuedo(i)})
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
		return limit.in(mainCharacter.direction().nextMove(mainCharacter.position(), size))
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
		game.schedule(5000, {=> self.removeElement(spiral)})
	}

	override method puedeCrear() {
		return bag.hasSpirals()
	}

	override method removeElement(elementSpiral) {
		elementSpiral.remove()
		self.spirals().remove(elementSpiral)
	}

}

object spiralBoxFactory inherits ElementFactory {

	override method create() {
		game.addVisual(spiralBox)
		exist = true
	}

	override method puedeCrear() {
		return !bag.hasSpirals() && super()
	}

}