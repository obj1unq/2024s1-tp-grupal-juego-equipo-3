import wollok.game.*
import randomizer.*
import posiciones.*
import main_character.*
import globalConfig.*

class Mosquito inherits GlobalConfig {

	var property position = randomizer.position()

	method image() = "mosquito01.png"

	method colition() { // VER
		game.onCollideDo(mainCharacter, { mainCharacter.chopped(self)})
	}

	method moving() {
		game.onTick(1500, "", { self.typeMove()})
	}

	method typeMove() { // Ver como buscar posiciones libres 
		const newPosition = self.nextPosition()
			// if (limit.in(newPosition) and not obstacleGeneration.isObstacleIn(newPosition)) {
		if (self.canGo(newPosition)) {
			self.position(newPosition)
		}
	}

	method nextPosition() {
		const directions = [ leftDirection, downDirection, upDirection, rightDirection ]
		return (directions.anyOne()).nextMove(self.position())
	}

	method effect() // VER efecto que deja al picar cada mosquito

}

//Tipo de mosquitos
class MosquitoSoft inherits Mosquito {

	override method effect() {
	}

}

// Invertí el comportamiento entre mosquitoHard y mosquitoSoft
// TODO: Buscarles nombres más significativos a ambos
class MosquitoHard inherits Mosquito {

	const character = mainCharacter

	override method image() = "mosquito02.png"

	override method nextPosition() {
		// TODO: Ver si es posible refactorizar !!!!!!!!!!!
		const distanceX = axisX.distance(character, self)
		const distanceY = axisY.distance(character, self)
		const axis = if (distanceX > distanceY) axisX else axisY
		var nextPosition = axis.nextDirection(character, self).nextMove(self.position())
		if (not self.canGo(nextPosition)) {
			nextPosition = axis.opossite().nextDirection(character, self).nextMove(self.position())
			if (not self.canGo(nextPosition)) {
				nextPosition = super()
			}
		}
		return nextPosition
	}

	override method effect() {
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

