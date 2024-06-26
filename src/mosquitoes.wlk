import wollok.game.*
import randomizer.*
import positions.*
import mainCharacter.*
import globalConfig.*
import collectable.*
import backpack.*
import sounds.*

// Type of mosquitoes
class Mosquito inherits Character {

	var property position = randomizer.emptyPosition()
	const character = mainCharacter

	method image() = "mosquitoe01.png"

	method moving() {
		game.onTick(1500, self.tickEvent(), { self.typeMove()})
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

	method tickEvent() {
		return "mosquitoeMoving" + self.identity()
	}

	method dead() {
		game.removeVisual(self)
		game.removeTickEvent(self.tickEvent())
		mosquitoesManager.removeMosquito(self)
	}

	method collision() {
		self.dead()
		character.bitten()
	}

	method killed() {
		soundProducer.playEffect("killedMosquitoe.mp3")
		backpack.addMosquito()
		self.dead()
	}

	override method isTakeable() {
		return false
	}

}

class MosquitoHard inherits Mosquito {

	override method image() = "mosquitoe02.png"

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

// Factories - Manager
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

	method build() {
		mosquitoes.clear()
		(1 .. 7).forEach({ m => self.createMosquitoRandom()})
		self.createMosquitoes()
	}

	method createMosquitoes() {
		game.onTick(2500, "CREATION" + self.identity(), { self.createMosquitoRandom()})
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

	method mosquitoesAt(position) {
		return self.mosquitoes().filter({ m => m.position() == position })
	}

	method removeMosquito(mosquito) {
		if (mosquitoes.contains(mosquito)) {
			mosquitoes.remove(mosquito)
		}
	}

}

