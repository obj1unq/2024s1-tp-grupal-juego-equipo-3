import wollok.game.*

object mainCharacter {

	var property direction
	var property position = game.at(4, 4)

	method image() = "characterfront.png"
	
	// TODO: Limitar movimiento dentro de los límites del tablero
	method irA(newPosition, newDirection) {
		self.direction(newDirection)
		position = newPosition
	}

	method sayDirection() {
		game.say(self, direction.say())
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

