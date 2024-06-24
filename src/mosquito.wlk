import wollok.game.*
import randomizer.*
import posiciones.*
import main_character.*
import globalConfig.*
import collectable.*
import backpack.*

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
		mosquitoesManager.removeMosquito(self)
	}

	method collision() {
		self.dead()
		character.bitten()
	}

	method killed() {
		backpack.addMosquito()
		self.dead()
	}

	override method isTakeable() {
		return false
	}

}

//Tipo de mosquitoes
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

object mosquitoesManager {

	const property mosquitoes = #{}
	const factories = [ mosquitoHardFactory, mosquitoFactory ]

	method build(){
		mosquitoes.clear()
		(1 .. 5).forEach({ m => self.createMosquitoRandom()})
		self.createMosquitoes()
	}
	
	method createMosquitoes() {
		game.onTick(3000, "CREACION" + self.identity(), { self.createMosquitoRandom()})
	}

	method createMosquitoRandom() {
		const mosquito = factories.anyOne().create()
		game.addVisual(mosquito)
		mosquito.moving()
		mosquitoes.add(mosquito)
	}

	method mosquitoesAround(visual) {
		return mosquitoes.filter({ mosquito => mosquito.position().distance(visual.position()) < 2 })
	}

	method mosquitoesEn(position) {
		return self.mosquitoes().filter({ m => m.position() == position })
	}

	method removeMosquito(mosquito) {
		if(mosquitoes.contains(mosquito)){
			mosquitoes.remove(mosquito)
		}
	}

}

