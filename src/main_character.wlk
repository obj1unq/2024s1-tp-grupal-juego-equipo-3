import wollok.game.*
import spiral.*
import limit.*
import extras.*

object mainCharacter {

	var property direction
	var property position = game.at(4, 4)
	const property mochila = #{}

	method image() = "characterfront.png"

	method goesTo(newDirection) {
		const newPosition = newDirection.nextMove(position)
		if (limit.in(newPosition) and not obstacleGeneration.isObstacleIn(newPosition) ) {
			self.direction(newDirection)
			self.position(newPosition)
		}
	}

	method sayDirection() {
		game.say(self, direction.say())
	}

	method foundElement() {
		self.validateElementFounded()
		const elementosEncontrados = game.colliders(self).copyWithout(self)
		elementosEncontrados.forEach{ element => element.taken(self)}
	}

	method validateElementFounded() {
		if (game.colliders(self).isEmpty()) {
			self.error("Nada para agarrar")
		}
	}

	method guardarEnLaMochila(element) {
		mochila.add(element)
	}

	method putSpiral() {
		self.validateEmptyPosition()
		self.validateSpiralBox()
		self.validateSpiralsInBox()
	}

	method validateEmptyPosition() {
		if (not game.colliders(self).isEmpty()) {
			self.error("No puedo dejar el espiral aquí")
		}
	}

	method validateSpiralBox() {
		if (mochila.isEmpty()) {
			self.error("No tengo cajas de espirales")
		}
	}

	method validateSpiralsInBox() {
		if(mochila{spiralBox.spirals()} == 0
	)
	}

	self.error("No tengo mas espirales")
}
	method evadeCollide() {
		const newDirection = self.direction().opossite()
		self.goesTo(newDirection)
	}

}

object leftDirection {

	method nextMove(position) {
		return game.at(position.x() - 1, position.y())
	}

	method say() {
		return 'left'
	}

	method opossite() {
		return rightDirection
	}

}

object downDirection {

	method nextMove(position) {
		return game.at(position.x(), position.y() - 1)
	}

	method say() {
		return 'down'
	}

	method opossite() {
		return topDirection
	}

}

object rightDirection {

	method nextMove(position) {
		return game.at(position.x() + 1, position.y())
	}

	method opossite() {
		return leftDirection
	}

	method say() {
		return 'right'
	}

}

object topDirection {

	method nextMove(position) {
		return game.at(position.x(), position.y() + 1)
	}

	method opossite() {
		return downDirection
	}

	method say() {
		return 'top'
	}

}

