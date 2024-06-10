import wollok.game.*
import posiciones.*
import globalConfig.*
import mosquito.*

object mainCharacter inherits Character {

	var property direction = downDirection
	var property position = game.at(4, 4)
	var property lifes = 2
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

	method changeMoving() {
		estaInvertido = true
	}

	method recuperarVida() {
		if (lifes < 2) {
			lifes += 1
		}
	}

	method restarVida() {
		if (lifes == 1) {
			self.morir()
		} else {
			lifes -= 1
		}
	}

	method morir() {
		game.removeVisual(self)
	// CONFIGURAR FINAL 
	}

	override method isTakeable() {
		return false
	}

	method foundElement() {
		self.validateFoundedElement()
		const foundedElements = game.colliders(self)
		foundedElements.forEach{ element => element.taken()}
	}

	method validateFoundedElement() {
		if (game.colliders(self).isEmpty() or game.colliders(self).any({ element => not element.isTakeable() })) {
			self.error("Nada para agarrar")
		}
	}

	method putSpiral() {
		self.validateEmptyPositionForPut()
		self.validateSpirals()
		bag.discountSpiral()
		const spiral = new Spiral()
		spiral.position(self.position())
		game.addVisual(spiral)
		spiral.activate()
	}

	method validateEmptyPositionForPut() {
		if (not game.colliders(self).isEmpty()) {
			self.error("No puedo dejar nada aquí")
		}
	}

	method validateSpirals() {
		if (bag.spirals() < 1) {
			self.error("No tengo espirales")
		}
	}

}

