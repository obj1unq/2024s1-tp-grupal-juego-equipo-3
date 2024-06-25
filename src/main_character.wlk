import wollok.game.*
import posiciones.*
import globalConfig.*
import mosquito.*
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
	var property estaInvertido = null
	var property bites = 0
	var property estado = ganador

	method image() = "ch" + direction + ".png"

	method build() {
		const default = game.at(2, 2)
		game.addVisual(self)
		self.direction(downDirection)
		self.position(default)
		self.lifes(2)
		self.myInsecticide().shoots(4)
		self.estaInvertido(false)
		self.bites(0)
		self.estado(ganador)
	}

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
		soundProducer.playEffect("recarga.mp3")
		lifes += 1
		self.invert()
	}

	method bitten() {
		soundProducer.playEffect("picado.mp3")
		if (self.isSick()) {
			estado = perdedor
			self.morir()
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

	method morir() {
		game.removeVisual(self)
		gameOver.endGame()
	}

	override method isTakeable() {
		return false
	}

	method disparar() {
		soundProducer.playEffect("shooting.mp3")
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
		spiralFactory.createSiPuedo()
		soundProducer.playEffect("put.mp3")
		backpack.discountSpiral()
	}

	method validateSpirals() {
		if (!backpack.hasSpirals()) {
			self.error("No tenes espirales!")
		}
	}

	method deadSound() {
		return estado.sound()
	}

}

object ganador {

	method sound() {
		soundProducer.playEffect("win.mp3")
	}

}

object perdedor {

	method sound() {
		soundProducer.playEffect("loose.mp3")
	}

}

