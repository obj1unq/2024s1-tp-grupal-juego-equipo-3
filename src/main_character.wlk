import wollok.game.*
import spiral.*

object mainCharacter {

	var property direction
	var property position = game.at(4, 4)
	const property mochila = []

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
		//uniqueColliders para enviarle al elemento un mensaje con self
		// y que reconozca que se encontró con él. Este elemento debe
		// saber que debe guardarse en mochila con validateMochila() y si es agarrable()
	}

//	method validateMochila() {
//		if (not mochila.size() < 2) {
//			self.error("no puedo guardar más cajas de espirales")
//		}
//	}
//
//	method validateElement(element) {
//		if (not element.esAgarrable()) {
//			self.error("no lo puedo agarrar")
//		}
//	}

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

