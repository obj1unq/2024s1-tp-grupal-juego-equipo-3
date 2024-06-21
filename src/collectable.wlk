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

	method create() {
	}

	method puedeCrear()

}

object sprayFactory inherits ElementFactory {

	override method create() {
		var spray = new Spray()
		game.addVisual(spray)
	}

	override method puedeCrear() {
		return !mainCharacter.mySpray().tieneDisparos()
	}

}

class Spray inherits Element {

	var disparos = 4
	var property tomado = false

	method image() {
		return "insecticide01.png"
	}

	override method position() {
		return if (tomado) {
			mainCharacter.position()
		} else {
			super()
		}
	}

	method disparar() {
		self.validateDisparos()
		self.validateMosquitos()
		self.mosquitos().forEach({ m => m.dead()})
		bag.addMosquito()
		self.restarDisparo()
		game.addVisual(rafaga)
//		game.onTick(1000, "rafaga", {game.addVisual(rafaga)})
//		game.schedule(1250, game.removeTickEvent("rafaga"))
		sprayFactory.createSiPuedo()
	}

	method direction() {
		return if (tomado) {
			mainCharacter.direction()
		} else null
	}

	method validateMosquitos() {
		if (!self.hayMosquitos()) {
			self.error("No hay mosquitos en el rango")
		}
	}

	method validateDisparos() {
		if (!self.tieneDisparos()) {
			self.error("Recarga tu Spray")
		}
	}
	
	method restarDisparo() {
		disparos -= 1
	}

	method posiciones(alcance) {
		return (1 .. alcance).map({ n => self.direction().nextMove(self.position(), n) })
	}

	method mosquitos() {
		return self.posiciones(3).map({ d => mosquitosManager.mosquitosEn(d) }).flatten()
	}

	method tieneDisparos() {
		return disparos > 0
	}

	method hayMosquitos() {
		return !self.mosquitos().isEmpty()
	}

	override method collision() {
		game.removeVisual(self)
		mainCharacter.mySpray(self)
		tomado = true
	}

}

object rafaga inherits Element {

	override method position() {
		return mainCharacter.direction().nextMove(mainCharacter.position())
	}

	override method image() {
		return "rafaga" + mainCharacter.direction() + ".png"
	}
	
	override method collision(){
		
	}
	
	override method isTakeable(){
		return false
	}
}

