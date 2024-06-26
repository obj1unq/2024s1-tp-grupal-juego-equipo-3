import wollok.game.*
import positions.*
import globalConfig.*
import mosquitoes.*
import collectable.*
import obstacles.*
import navigation.*
import extras.*
import backpack.*
import sounds.*

object mainCharacter inherits Character {

	var property direction = null
	var property position = null
	var property lifes = null
	var property myInsecticide = insecticide
	var property inverted = null
	var property bites = 0
	var property estado = winner

	method image() = "ch" + direction + ".png"

	method build() {
		const default = game.at(2, 2)
		game.addVisual(self)
		self.direction(downDirection)
		self.position(default)
		self.lifes(2)
		self.myInsecticide().shoots(4)
		self.inverted(false)
		self.bites(0)
		self.estado(winner)
	}

	method goesTo(newDirection) {
		const newPosition = self.nextMove(newDirection)
		if (self.canGo(newPosition)) {
			self.direction(newDirection)
			self.position(newPosition)
		}
	}

	method nextMove(newDirection) {
		return if (inverted) {
			newDirection.opossite().nextMove(position)
		} else {
			newDirection.nextMove(position)
		}
	}

	method nextPositionForward() {
		return direction.nextMove(position)
	}

	method invert() {
		if (!inverted && self.isSick()) {
			inverted = true
		} else {
			inverted = false
		}
	}

	method heal() {
		lifes += 1
		soundProducer.playEffect("heal.mp3")
		self.invert()
	}

	method bitten() {
		soundProducer.playEffect("bitten.mp3")
		if (self.isSick()) {
			estado = loser
			self.die()
		}
		lifes -= 1
		bites += 1
	}

	method bitesBonus() {
		return bites * 250
	}

	method isSick() {
		return lifes == 1
	}

	method die() {
		game.removeVisual(self)
		gameOver.endGame()
	}

	override method isTakeable() {
		return false
	}

	method shoot() {
		soundProducer.playEffect("shooting.mp3")
		self.validateShots()
		insecticide.shoot()
	}

	// TODO: Doesn't load mist costume
	method validateShots() {
		if (!insecticide.hasShots()) {
			self.error("Recarga tu insecticida!")
		}
	}

	method putSpiral() {
		self.validateSpirals()
		spiralFactory.createIfPossible()
		soundProducer.playEffect("put.mp3")
		backpack.discountSpiral()
	}

	method validateSpirals() {
		if (!backpack.hasSpirals()) {
			self.error("No tenes espirales!")
		}
	}

	method deathSound() {
		return estado.sound()
	}

}

object winner {

	method sound() {
		soundProducer.playEffect("win.mp3")
	}

}

object loser {

	method sound() {
		soundProducer.playEffect("lose.mp3")
	}

}

