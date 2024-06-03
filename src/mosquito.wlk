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
		game.onTick(1000, "", { self.typeMove()})
	}

	method typeMove()

	method effect() // VER efecto que deja al picar cada mosquito

	override method isTakeable() {
		return false
	}

	override method isSolid() {
		return false
	}

}

//Tipo de mosquitos
class MosquitoHard inherits Mosquito {

	override method typeMove() { // Ver como buscar posiciones libres 
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

	override method effect() {
	}

}

class MosquitoSoft inherits Mosquito {

	override method typeMove() {
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

	const mosquitos = [ mosquitoHardFactory ] // [mosquitoHardFactory,mosquitoSoftFactory ]

	method createMosquitos() {
		game.onTick(2000, "", { mosquitos.anyOne().createMosquito()})
	}

}

