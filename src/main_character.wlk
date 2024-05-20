import wollok.game.*
import spiral.*

object mainCharacter {

	var property direction
	var property position = game.at(4, 4)
	const property mochila = #{}

	method image() = "characterfront.png"

	// TODO: Limitar movimiento dentro de los límites del tablero
	method irA(newPosition, newDirection) {
		self.direction(newDirection)
		position = newPosition
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
		position = direction.newPosition(self.position())
	}

}

object leftDirection {

	method newPosition(currentPosition) {
		return new Position(x = currentPosition.x() + 1, y = currentPosition.y())
	}

	method say() {
		return 'left'
	}

}

object downDirection {

	method newPosition(currentPosition) {
		return new Position(x = currentPosition.x(), y = currentPosition.y() + 1)
	}

	method say() {
		return 'down'
	}

}

object rightDirection {

	method newPosition(currentPosition) {
		return new Position(x = currentPosition.x() - 1, y = currentPosition.y())
	}

	method say() {
		return 'right'
	}

}

object topDirection {

	method newPosition(currentPosition) {
		return new Position(x = currentPosition.x(), y = currentPosition.y() - 1)
	}

	method say() {
		return 'top'
	}

}

