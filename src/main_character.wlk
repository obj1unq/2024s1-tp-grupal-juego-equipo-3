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
	const property bag = #{}

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
		self.validateElementFounded()
		const foundedElements = game.colliders(self)
		foundedElements.forEach{ element => element.taken(self)}
	}

	method validateElementFounded() {
		if (game.colliders(self).isEmpty() or game.colliders(self).any({ element => not element.isTakeable() })) {
			self.error("Nada para agarrar")
		}
	}

	method storeInBag(element) {
		bag.add(element)
	}

	method putSpiral() {
		self.validateEmptyPosition()
		self.validateSpiralBox()
//		self.validateSpiralsInBox()
	}

	method validateEmptyPosition() {
		if (not game.colliders(self).isEmpty()) {
			self.error("No puedo dejar el espiral aquí")
		}
	}

	method validateSpiralBox() {
		if (bag.isEmpty()) {
			self.error("No tengo cajas de espirales")
		}
	}

//	method validateSpiralsInBox() {
//		if(bag{spiralBox.spirals()} == 0
//	)
//	}
//	self.error("No tengo mas espirales")
//}
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

