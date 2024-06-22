import wollok.game.*
import randomizer.*
import main_character.*
import mosquito.*
import obstacles.*
import globalConfig.*

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

	method addMosquito() {
		mosquitoes += 1
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

	method collision()

	method image()

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
class ElementFactory {

	method createSiPuedo() {
		if (self.puedeCrear()) {
			self.create()
		}
	}

	method create()

	method puedeCrear()

}

object recargaFactory inherits ElementFactory {

	override method create() {
		var recarga = new Recarga()
		game.addVisual(recarga)
	}

	override method puedeCrear() {
		return !mainCharacter.mySpray().tieneDisparos()
	}

}

object spray inherits Element {

	var property shoots = 4

	method image() {
		return "insecticide01.png"
	}

	override method position() {
		return mainCharacter.position()
	}

	method disparar() {
//		self.validateMosquitos()
		self.restarDisparo()
		brumaFactory.createBrumas()
		self.killMosquitos()
		recargaFactory.createSiPuedo()
	}

	// TODO: Resolver bonito u.u
	method killMosquitos() {
		if (!self.mosquitos().isEmpty()) {
			self.mosquitos().forEach({ m => m.killed()})
		}
	}

	method direction() {
		return mainCharacter.direction()
	}

//	method validateMosquitos() {
//		if (!self.hayMosquitos()) {
//			self.error("No hay mosquitos en el rango")
//		}
//	}
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

	method mosquitos() {
		return self.posiciones(3).map({ d => mosquitosManager.mosquitosEn(d) }).flatten()
	}

	method tieneDisparos() {
		return shoots > 0
	}

	method hayMosquitos() {
		return !self.mosquitos().isEmpty()
	}

	method recargar() {
		shoots = 4
	}

	override method collision() {
	}

}

class Recarga inherits Element {

	override method image() {
		return "insecticide01.png"
	}

	override method collision() {
		spray.recargar()
		game.removeVisual(self)
	}

}

// TODO: Resolver conflicto de dirección con picadura de mosquito hard
class Bruma inherits Element {

	const cantidad

	override method position() {
		return mainCharacter.direction().nextMove(mainCharacter.position(), cantidad)
	}

	override method image() {
		return "brick0" + cantidad + ".png"
	}

	override method collision() {
	}

	override method isTakeable() {
		return false
	}

}

object brumaFactory inherits ElementFactory {

	//TODO: Por polimorfismo, hay que cambiar todos los métodos (agregar parámetros)
	//TODO: Ver disparos sobre obstáculos + Limitar disparos
	method createBrumas() {
		(1 .. 3).forEach({ i => self.createSiPuedoEn(i)})
	}

	override method create() {
	}

	method createOn(i) {
		var bruma = new Bruma(cantidad = i)
		game.addVisual(bruma)
		game.schedule(200, { game.removeVisual(bruma)})
	}

	override method createSiPuedo() {
	}

	method createSiPuedoEn(cantidad) {
		if (self.puedeCrearEn(cantidad)) {
			self.createOn(cantidad)
		}
	}

	override method puedeCrear() {
	}

	method puedeCrearEn(cantidad) {
		return limit.in(mainCharacter.direction().nextMove(mainCharacter.position(), cantidad))
	}

}

