import wollok.game.*
import randomizer.*
import posiciones.*
import main_character.*
import globalConfig.*
import collectable.*

class Mosquito inherits Character {

	var property position = randomizer.emptyPosition()
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

	method dead() {
		game.removeVisual(self)
		game.removeTickEvent(self.eventMosquito())
	}

	method collision() {
		self.dead()
		character.bitten()
	}

	method killed() {
		self.dead()
		bag.addMosquito()
		mosquitosManager.removeMosquito(self)
	}

	override method isTakeable() {
		return false
	}

}

//Tipo de mosquitos
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
		character.invert()
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

	const property mosquitos = #{}
	const factories = [ mosquitoHardFactory, mosquitoFactory ]

	method createMosquitos() {
		game.onTick(3000, "CREACION" + self.identity(), { self.createMosquitoRandom()})
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

	method removeMosquito(mosquito) {
		mosquitos.remove(mosquito)
	}

}

