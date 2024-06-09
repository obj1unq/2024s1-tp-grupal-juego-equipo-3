import wollok.game.*
import randomizer.*
import posiciones.*
import main_character.*
import globalConfig.*

class Mosquito inherits Character {

	var property position = randomizer.position()
	const character = mainCharacter

	method image() = "mosquito01.png"

	method moving() {
		game.onTick(1500, self.eventMosquito(), { self.typeMove()})
	}

	method typeMove() {
		const newPosition = self.nextPosition()
		if (self.canGo(newPosition)) {
			self.position(newPosition)
		}
	}

	method nextPosition() {
		const directions = [ leftDirection, downDirection, upDirection, rightDirection ]
		return (directions.anyOne()).nextMove(self.position())
	}

	method eventMosquito() {
		return "mosquitoMoving" + self.identity()
	}

//	override method spiralEffect() {
//		self.dead()
//	}

	method dead() {
		game.removeVisual(self)
		game.removeTickEvent(self.eventMosquito())
	}

	override method collision() {
		self.dead()
		character.restarVida()
	}
	
	override method isTakeable(){
		return false
	}

}

//Tipo de mosquitos
// TODO: Buscarles nombres más significativos a ambos
class MosquitoHard inherits Mosquito {

	override method image() = "mosquito02.png"

	override method nextPosition() {
		const distanceX = axisX.distance(character, self)
		const distanceY = axisY.distance(character, self)
		const axis = if (distanceX > distanceY) axisX else axisY
		var nextPosition = axis.nextMove(self, character)
		if (not self.canGo(nextPosition)) {
			nextPosition = axis.opossite().nextMove(self, character)
			if (not self.canGo(nextPosition)) {
				nextPosition = super()
			}
		}
		return nextPosition
	}
	
	override method collision() {
        super()
        character.changeMoving()
    }

}

//Factory 
class MosquitoFactory {
	const property mosquitos = []
	method createMosquito() {
	var  mosquitoo = self.create()
		game.addVisual(mosquitoo)
		mosquitoo.moving()
		mosquitos.add(mosquitoo)
	}

	method create()

}

object mosquitoFactory inherits MosquitoFactory {

	override method create() {
		return new Mosquito()
	}

}

object mosquitoHardFactory inherits MosquitoFactory {

	override method create() {
		return new MosquitoHard()
	}

}

object mosquitosManager {
	

	method createMosquitos() {
		game.onTick(5000, "CREACION" + self.identity(), { self.createMosquito()})
	}
	
	method createMosquito(){
		var miFactory = [mosquitoHardFactory,mosquitoFactory].anyOne()
		miFactory.createMosquito()
	}
	
	method mosquitos(){
		return [mosquitoHardFactory,mosquitoFactory].flatMap({f => f.mosquitos()})
	}

}

