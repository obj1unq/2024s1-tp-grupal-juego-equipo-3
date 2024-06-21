import wollok.game.*
import randomizer.*
import posiciones.*
import main_character.*
import globalConfig.*
import obstacles.*
class Mosquito inherits Character {

	var property position = randomizer.position()
	const character = mainCharacter

	method image() = "mosquito01.png"

	method moving() {
		game.onTick(3000, self.eventMosquito(), { self.typeMove()})
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

	method spiralEffect() {
		self.dead()
	}

	method dead() {
		mosquitosManager.removeMosquito(self)
		game.removeVisual(self)
		game.removeTickEvent(self.eventMosquito())
	}

	override method collision() {
		self.dead()
		character.restarVida()
	}

	override method isTakeable() {
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
object mosquitoFactory {

	method create() {
		return new Mosquito()
	}

}

object mosquitoHardFactory {
	method create() {
		return new MosquitoHard()
	}

}

object mosquitosManager {

	const property mosquitos = #{} // cuando mato un mosquito se elimina de esta lista?
	const factories = [ mosquitoHardFactory, mosquitoFactory ]

	method createMosquitos() {
		game.onTick(5000, "CREACION" + self.identity(), { self.createMosquitoRandom()})
	}

	method createMosquitoRandom() {
		const mosquito = factories.anyOne().create()
		game.addVisual(mosquito)
		mosquito.moving()
		mosquitos.add(mosquito)
	}

	method mosquitoesAround(visual) {
		return mosquitos.filter({ mosquito => mosquito.position().distance(visual.position()) < 2 })
	}

	method mosquitosEn(position) {
		return self.mosquitos().filter({ m => m.position() == position })
	}

	method removeMosquito(mosquito){
		mosquitos.remove(mosquito)
	}
	
	method hayMosquitosEn(position){
		return mosquitos.any({m=> m.position() == position})
	}

}

