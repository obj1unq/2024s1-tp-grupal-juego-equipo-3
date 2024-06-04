import wollok.game.*
import randomizer.*
import posiciones.*
import main_character.*
import globalConfig.*

class Mosquito inherits Character {

	var property position = randomizer.position()

	method image() = "mosquito01.png"

	method moving() {
		game.onTick(1500, self.eventMosquito(), { self.typeMove(mainCharacter)})
	}

	method typeMove(character)

	method effect() // VER efecto que deja al picar cada mosquito

	// Utilizado para identificar a los mosquitos en período de prueba
	method text() {
		return self.toString()
	}

	method eventMosquito() {
		return "mosquitoMoving" + self.identity()
	}

	method dead() {
		game.removeVisual(self)
		game.removeTickEvent(self.eventMosquito())
	}

	override method colition(algo) {
		self.dead()
		algo.restarVida()
	}

	override method isTakeable() {
		return false
	}
	
	override method isSolid(){
		return false 
	}

}

//Tipo de mosquitos
class MosquitoSoft inherits Mosquito {

	override method typeMove(character) { // Ver como buscar posiciones libres 
		const newPosition = self.nextPosition()
		if (self.canGo(newPosition)) {
			self.position(newPosition)
		}
	}

	method nextPosition() {
		const directions = [ leftDirection, downDirection, upDirection, rightDirection ]
		return (directions.anyOne()).nextMove(self.position())
	}

}

// Invertí el comportamiento entre mosquitoHard y mosquitoSoft
// TODO: Buscarles nombres más significativos a ambos
class MosquitoHard inherits Mosquito {

	override method typeMove(character) {
		const newPosition = self.nextPosition(character)
			// TODO: Redireccionar en caso de que no pueda avanzar
		if (self.canGo(newPosition)) {
			self.position(newPosition)
		}
	}

	method nextPosition(character) {
		// TODO: Ver si es posible refactorizar
		const directionX = [ rightDirection, leftDirection ]
		const directionY = [ upDirection, downDirection ]
		const distanceX = character.position().x() - self.position().x()
		const distanceY = character.position().y() - self.position().y()
		return if (distanceX.abs() > distanceY.abs()) {
			self.getDirection(distanceX, directionX).nextMove(self.position())
		} else {
			self.getDirection(distanceY, directionY).nextMove(self.position())
		}
	}

	method getDirection(distance, direction) {
		return if (distance >= 0) {
			direction.get(0)
		} else {
			direction.get(1)
		}
	}

	override method colition(algo) {
		super(algo)
		algo.changeMoving()
	}

}

//Factory 
class MosquitoFactory {

	method createMosquito() {
		const mosquito = self.create()
		game.addVisual(mosquito)
		mosquito.moving()
	}

	method create()

}

object mosquitoHardFactory inherits MosquitoFactory {

	override method create() {
		return new MosquitoHard()
	}

}

object mosquitoSoftFactory inherits MosquitoFactory {

	override method create() {
		return new MosquitoSoft()
	}

}

object mosquitosManager {

	const mosquitos = [ mosquitoHardFactory, mosquitoSoftFactory ]

	method createMosquitos() {
		// Creé el mensaje que le asigna un mensaje a cada mosquito
		game.onTick(10000, "" + self.identity(), { mosquitos.anyOne().createMosquito()})
	}

}

