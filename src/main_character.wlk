import wollok.game.*
import posiciones.*
import globalConfig.*
import mosquito.*
import collectable.*
import obstacles.*
import navigation.*
import extras.*

object mainCharacter inherits Character {

	var property direction = downDirection
	var property position = game.at(4, 4)
	var property lifes = 2
	var property myInsecticide = insecticide
	var estaInvertido = false

	method image() = "ch" + direction + ".png"

	method goesTo(newDirection) {
		const newPosition = self.nextMove(newDirection)
		if (self.canGo(newPosition)) {
			self.direction(newDirection)
			self.position(newPosition)
		}
	}

	method nextMove(newDirection) {
		return if (estaInvertido) {
			newDirection.opossite().nextMove(position)
		} else {
			newDirection.nextMove(position)
		}
	}

	method nextPositionForward() {
		return direction.nextMove(position)
	}

	method invert() {
		if (!estaInvertido && self.isSick()) {
			estaInvertido = true
		} else {
			estaInvertido = false
		}
	}

	method curar() {
		lifes += 1
		self.invert()
	}

	method bitten() {
		if (self.isSick()) {
			self.morir()
		}
		lifes -= 1
	}

	method isSick() {
		return lifes == 1
	}

	method morir() {
		game.removeVisual(self)
		gameOver.endGame()
	}

	override method isTakeable() {
		return false
	}

	method disparar() {
		self.validateDisparos()
		insecticide.disparar()
	}

	// TODO: No carga disfraz de bruma
	method validateDisparos() {
		if (!insecticide.tieneDisparos()) {
			self.error("Recarga tu spray!")
		}
	}

	method putSpiral() {
		self.validateSpirals()
		bag.discountSpiral()
		spiralFactory.createSiPuedo()
	}

	method validateSpirals() {
		if (!bag.hasSpirals()) {
			self.error("No tenes espirales!")
		}
	}

}

