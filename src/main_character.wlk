import wollok.game.*
import limit.*

object mainCharacter {

	var property direction
	var property position = game.at(4, 4)

	method image() = "characterfront.png"

	// TODO: Limitar movimiento dentro de los límites del tablero
	method goesTo(newDirection) {
		const newPosition = newDirection.nextMove(position)
		if (limit.in(newPosition) && game.getObjectsIn(newPosition).get(0).isSolid()) {
			self.direction(newDirection)
			self.position(newPosition)
		}
	}

	method sayDirection() {
		game.say(self, direction.say())
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

