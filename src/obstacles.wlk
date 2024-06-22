import wollok.game.*
import randomizer.*

class Obstacle {

	var property position = randomizer.emptyPosition()
	const imageFile
	const asset

	method image() {
		return imageFile + asset + ".png"
	}

//	method whenCollide(character) { //Sirve??
//		character.evadeCollide()
//	}
	method isSolid() {
		return true
	}

}

object obstacleManager {

	const property factories = [ plantFactory, brickFactory, stoneFactory ]
	const randomBlocks = 20

	method configurate() {
		const obstacles = (0 .. randomBlocks).map({ o => factories.anyOne().create() })
		obstacles.forEach({ o => game.addVisual(o)})
	}

	method isObstacleIn(position) {
		const elements = game.getObjectsIn(position)
		return (!elements.isEmpty()) and elements.first().isSolid()
	}

}
class Plant inherits Obstacle(imageFile = 'plants0', asset = (1 .. 3).anyOne()) {

}

class Stone inherits Obstacle(imageFile = 'stone0', asset = (1 .. 2).anyOne()) {

}

class Brick inherits Obstacle(imageFile = 'brick0', asset = (1 .. 3).anyOne()) {
}

object plantFactory {

	method create() {
		return new Plant()
	}

}

object brickFactory {
	method create() {
		return new Brick()
	}

}

object stoneFactory {

	method create() {
		return new Stone()
	}

}

//import wollok.game.*
//import randomizer.*
//
//class Obstacle {
//
//	var property position
//	const imageFile
//	const asset
//
//	method image() {
//		return imageFile + asset + ".png"
//	}
//
//	method whenCollide(character) {
//		character.evadeCollide()
//	}
//
//	method isSolid() {
//		return true
//	}
//
//}
//
//object obstacleGeneration {
//
//	const property obstacles = [ plant, brick, stone ]
//	const randomBlocks = 20
//
//	method configurate() {
//		var obstacle = (0 .. randomBlocks).map({ i => obstacles.anyOne().create(randomizer.emptyPosition()) })
//		obstacle.forEach({ i => game.addVisual(i)})
//	}
//
//	method isObstacleIn(position) {
//		const elements = game.getObjectsIn(position)
//		return !elements.isEmpty() && elements.first().isSolid()
//	}
//
//}
//
//// Creación de clases que heredan de obstacle
//// TODO: Ver cómo refactorizar imageFile e image
//class Plant inherits Obstacle(imageFile = 'plants0') {
//
//}
//
//class Stone inherits Obstacle(imageFile = 'stone0') {
//
//}
//
//class Brick inherits Obstacle(imageFile = 'brick0') {
//
//}
//
//object plant {
//
//	const assets = 3
//
//	method create(position) {
//		return new Plant(position = position, asset = randomizer.randomNumber(1, assets)) //Ver como hacer polimorfismo con los demas objetos 
//	}
//
//}
//
//object brick{
//
//	const assets = 3
//
//	method create(position) {
//		return new Brick(position = position, asset = randomizer.randomNumber(1, assets))
//	}
//
//}
//
//object stone {
//
//	const assets = 2
//
//	method create(position) {
//		return new Stone(position = position, asset = randomizer.randomNumber(1, assets))
//	}
//
//} 