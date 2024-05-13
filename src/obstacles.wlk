import wollok.game.*
import randomizer.*

class Obstacle {

	// TODO: Revisar dónde configurar las colisiones
	// TODO: Ver que métodos y atributos se pueden heredar desde la clase Obstacle
	var property position
	const imageFile
	const asset

	method image() {
		return imageFile + asset + ".png"
	}

	method whenCollide(character) {
//		const direction = character.direction().opossite()
//		character.goesTo(direction)
		character.evadeCollide()
	}

}

// Creación de clases que heredan de obstacle
// TODO: Ver cómo refactorizar imageFile e image
class Plant inherits Obstacle(imageFile = 'plants0') {

}

class Stone inherits Obstacle(imageFile = 'stone0') {

}

class Brick inherits Obstacle(imageFile = 'brick0') {

}

object plant {

	const assets = 3

	method crear(position) {
		return new Plant(position = position, asset = randomizer.randomNumber(1, assets))
	}

}

object brick {

	const assets = 3

	method crear(position) {
		return new Brick(position = position, asset = randomizer.randomNumber(1, assets))
	}

}

object stone {

	const assets = 2

	method crear(position) {
		return new Stone(position = position, asset = randomizer.randomNumber(1, assets))
	}

}

