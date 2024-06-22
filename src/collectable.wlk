import wollok.game.*
import randomizer.*
import main_character.*
import mosquito.*
import obstacles.*
import globalConfig.*

// Hacer vacuna (Cuando me quedo con una vida)
object elementManager {

	const property factories = [ refillFactory, trashFactory ]

	method createElement() {
		factories.forEach({ factory => factory.createSiPuedo()})
	}

	method createTrashRandom() {
		const trash = trashFactory
		game.addVisual(trash)
	}

}

object bag {

	var property spirals = 0
	var property trashes = 0
	var property mosquitoes = 0

	method storeInBag() {
		self.validateSpirals()
		spirals = 5
	}

	method discountSpiral() {
		spirals -= 1
	}

	method validateSpirals() {
		if (self.spirals() > 0) {
			self.error("todavía tengo espirales en la caja")
		}
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

	method removeThis() {
		game.removeVisual(self)
	}

}

class Vaccine inherits Element {

	override method image() {
		return "vaccine.png"
	}

	override method take() {
		mainCharacter.curar()
		self.removeThis()
	}

}

/*class Refill inherits Element {

 * 	override method image() {
 * 		return "insecticide01.png"
 * 	}

 * 	override method take() {
 * 		insecticide.recargar()
 * 		self.removeThis()
 * 	}

 }*/
object refill inherits Element {

	method image() {
		return "insecticide01" + ".png"
	}

	override method take() {
		insecticide.recargar()
		refillFactory.removeElement(self)
	}

}

object insecticide inherits Element {

	var property shoots = 4
	var property shootDistance = 3

	override method image() {
		return "insecticide01.png"
	}

	override method position() {
		return mainCharacter.position()
	}

	method disparar() {
		self.restarDisparo()
		sprayFactory.createSprayBurst(shootDistance)
		self.killMosquitos()
		refillFactory.createSiPuedo()
	}

	// TODO: Resolver bonito u.u
	method killMosquitos() {
		if (self.hayMosquitos(shootDistance)) {
			self.mosquitos(shootDistance).forEach({ m => m.killed()})
		}
	}

	method direction() {
		return mainCharacter.direction()
	}

	method validateDisparos() {
		if (!self.tieneDisparos()) {
			self.error("Recarga tu Spray")
		}
	}

	method restarDisparo() {
		shoots -= 1
	}

	method posiciones(alcance) {
		return (1 .. alcance).map({ n => self.direction().nextMove(self.position(), n) })
	}

	method mosquitos(alcance) {
		return self.posiciones(alcance).map({ d => mosquitosManager.mosquitosEn(d) }).flatten()
	}

	method tieneDisparos() {
		return shoots > 0
	}

	method hayMosquitos(alcance) {
		return !self.mosquitos(alcance).isEmpty()
	}

	method recargar() {
		shoots = 4
	}

	override method take() {
	}

}

// TODO: Resolver conflicto de dirección con picadura de mosquito hard
class Spray inherits Element {

	const cantidad

	override method position() {
		return mainCharacter.direction().nextMove(mainCharacter.position(), cantidad)
	}

	override method image() {
		return "brick0" + cantidad + ".png"
	}

	override method take() {
	}

	override method isTakeable() {
		return false
	}

}

class Trash inherits Element {

	override method image() {
		return "trash01.png"
	}

	/*method typeOf() {
	 * 	return 1.randomUpTo(5).roundUp(0)
	 }*/
	override method take() {
		bag.storeTrash()
		trashFactory.removeElement(self)
	}

}

/* FACTORIES */
class ElementFactory {

	method createSiPuedo() {
		if (self.puedeCrear()) {
			self.create()
		}
	}

	method create()

	method puedeCrear()

	method removeElement(element)

}

object vaccineFactory inherits ElementFactory {

	override method create() {
		var vaccine = new Vaccine()
		game.addVisual(vaccine)
	}

	override method puedeCrear() {
		return mainCharacter.isSick()
	}

	override method removeElement(element) {
	}

}

/*object refillFactory inherits ElementFactory {

 * 	override method create() {
 * 		var refill = new Refill()
 * 		game.addVisual(refill)
 * 	}

 * 	override method puedeCrear() {
 * 		return !mainCharacter.myInsecticide().tieneDisparos()
 * 	}

 * 	override method removeElement(element) {
 * 	}

 }*/
object refillFactory inherits ElementFactory {

	var element = null

	override method create() {
		element = refill
		game.addVisual(element)
	}

	override method puedeCrear() {
		return !mainCharacter.myInsecticide().tieneDisparos()
	}

	override method removeElement(elementSpray) {
		game.removeVisual(elementSpray)
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

