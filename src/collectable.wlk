import wollok.game.*
import randomizer.*
import main_character.*
import mosquito.*
import obstacles.*
import globalConfig.*

// Hacer vacuna (Cuando me quedo con una vida)
object elementManager {

	const property factories = [ trashFactory, vaccineFactory, refillFactory, spiralBoxFactory ] // Faltan espirales. 

	method createElement() {
		factories.forEach({ factory => factory.createSiPuedo()})
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
		if (self.hasSpirals()) {
			self.error("Todavía tengo espirales en la caja")
		}
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

	override method image() {
		return "vaccine.png"
	}

	override method take() {
		mainCharacter.curar()
		vaccineFactory.removeElement(self)
	}

}

object refill inherits Element {

	method image() {
		return "insecticide01.png"
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
	// refillFactory.createSiPuedo() <- No se usa, lo maneja el elementFactory
	}

	// TODO: Revisar, a veces sigue fallando.
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

	method tieneDisparos() {
		return shoots > 0
	}

	method posiciones(alcance) {
		return (1 .. alcance).map({ n => self.direction().nextMove(self.position(), n) })
	}

	method mosquitos(alcance) {
		return self.posiciones(alcance).map({ d => mosquitosManager.mosquitosEn(d) }).flatten()
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
		return "spray" + cantidad + ".png"
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

	// TODO: Revisar cambio de disfraz. No toma disfraz fijo.
	/*method typeOf() {
	 * 	return 1.randomUpTo(5).roundUp(0)
	 }*/
	override method take() {
		bag.storeTrash()
		trashFactory.removeElement(self)
	}

}

object spiralBox inherits Element {

	override method image() {
		return "spiralbox.png"
	}

	override method take() {
		bag.storeInBag()
		spiralBoxFactory.removeElement(self)
	}

}

// TODO: Revisar acción sobre mosquitos, se rompe.
/* El problema está en validar los mosquitos que si están presentes, 
 * sino envía mensajes a las celdas vacías */
// TODO: Revisar posicionamiento de espirales.
//class Spiral inherits Element {
//
//	var property newPosition
//
//	override method image() {
//		return "spiral.png"
//	}
//
//	method activate() {
//		game.onTick(500, "EFECTO ESPIRAL", { self.killMosquitos()})
//	}
//
//	method killMosquitos() {
//		mosquitosManager.mosquitoesAround(self).forEach({ element => element.spiralEffect()})
//	}
//
//	override method isTakeable() {
//		return false
//	}
//
//	override method take() {
//	}
//
//}
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

// TODO: Revisar posiciones de espirales. No funciona.
//object spiralFactory inherits ElementFactory {
//
//	const property spirals = []
//
//	override method create() {
//		const spiral = new Spiral()
//		spirals.add(spiral)
//		game.addVisual(spiral)
//		game.onTick(500, "EFECTO ESPIRAL", { spiral.activate()})
//		game.schedule(5000, {=> self.removeElement(spiral)})
//	}
//
//	override method puedeCrear() {
//		return spirals.size() < 5 && bag.hasSpirals()
//	}
//
//	override method removeElement(elementSpiral) {
//		game.removeVisual(elementSpiral)
//		self.spirals().remove(elementSpiral)
//	}
//
//}
//
object spiralBoxFactory inherits ElementFactory {

	override method create() {
		game.addVisual(spiralBox)
		exist = true
	}
	
	override method puedeCrear(){
		return !bag.hasSpirals() && super()
	}

}

