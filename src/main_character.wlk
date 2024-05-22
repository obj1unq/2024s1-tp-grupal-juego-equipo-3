import wollok.game.*
import spiral.*
import limit.*
import extras.*
import posiciones.*
import character.*
import mosquito.*

object mainCharacter inherits Character {

	var property direction = null
	var property position = game.at(4, 4)

	method image() = "characterfront.png"

	method goesTo(newDirection) {
		const newPosition = newDirection.nextMove(position)
		if (self.canGo(newPosition)) {
			// if (limit.in(newPosition) and not obstacleGeneration.isObstacleIn(newPosition) ) {
			self.direction(newDirection)
			self.position(newPosition)
		}
	}

	method sayDirection() {
		game.say(self, direction.say())
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
		const spiral = new Spiral()
		spiral.position(self.position())
		game.addVisual(spiral)
		bag.discountSpiral()
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

	method evadeCollide() {
		const newDirection = self.direction().opossite()
		self.goesTo(newDirection)
	}

	method chopped(mosquito) { // VER PICADO
		mosquito.effect()
	}

	override method isTakeable() {
		return false
	}

	override method isSolid() {
		return false
	}

}

