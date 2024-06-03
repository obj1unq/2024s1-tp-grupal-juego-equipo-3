import wollok.game.*
import randomizer.*

class Obstacle {

	var property position
	const imageFile
	const asset

	method image() {
		return imageFile + asset + ".png"
	}

	method whenCollide(character) {
		character.evadeCollide()
	}

	method isSolid() {
		return true
	}

}

object obstacleGeneration {

	const property obstacles = [ plant, brick, stone ]
	const randomBlocks = 20

	method configurate() {
		var obstacle = (0 .. randomBlocks).map({ i => obstacles.anyOne().create(randomizer.emptyPosition()) })
		obstacle.forEach({ i => game.addVisual(i)})
	}

	method isObstacleIn(position) {
		const elements = game.getObjectsIn(position)
		return !elements.isEmpty() && elements.first().isSolid()
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

	method create(position) {
		return new Plant(position = position, asset = randomizer.randomNumber(1, assets)) //Ver como hacer polimorfismo con los demas objetos 
	}

}

object brick{

	const assets = 3

	method create(position) {
		return new Brick(position = position, asset = randomizer.randomNumber(1, assets))
	}

}

object stone {

	const assets = 2

	method create(position) {
		return new Stone(position = position, asset = randomizer.randomNumber(1, assets))
	}

}

