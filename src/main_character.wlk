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
	var estaInvertido = false // TODO: Ver cómo indicar que fue picado por un hard

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

	method sayDirection() {
		game.say(self, direction.say())
	}

	method evadeCollide() {
		const newDirection = self.direction().opossite()
		self.goesTo(newDirection)
	}

	method collision() {
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
	// vaccineFactory.createSiPuedo() <- No se usa, lo maneja el elementFactory
	}

	method isSick() {
		return lifes == 1
	}

	method morir() {
		game.removeVisual(self)
		gameOver.endGame()
	// CONFIGURAR FINAL 
	}

	override method isTakeable() {
		return false
	}

	method disparar() {
		self.validateDisparos()
		insecticide.disparar()
	}

	// TODO: No carga disfraz de bruma
	// TODO: Modificar disfraces de bruma (ROJO)
	method validateDisparos() {
		if (!insecticide.tieneDisparos()) {
			self.error("Recarga tu spray!")
		}
	}

	/*method putSpiral() {
		//self.validateEmptyPositionForPut()
		self.validateSpirals()
		bag.discountSpiral()
		spiralFactory.createSiPuedo()
	}

	method validateEmptyPositionForPut() {
		if (not game.colliders(self).isEmpty()) {
			self.error("No puedo dejar nada aquí")
		}
	}

	method validateSpirals() {
		if (!bag.hasSpirals()) {
			self.error("No tengo espirales.")
		}
	}*/

}

