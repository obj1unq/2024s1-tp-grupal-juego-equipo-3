import wollok.game.*
import randomizer.*

class Obstacle {

	var property position = randomizer.emptyPosition()
	const asset = (1 .. 8).anyOne().toString()

	method image() = "obstacle0" + asset + ".png"

	method isSolid() {
		return true
	}

}

object obstacleManager {

	const randomBlocks = 20

	method configurate() {
		const obstacles = (0 .. randomBlocks).map({ o => self.create() })
		obstacles.forEach({ o => game.addVisual(o)})
	}

	method create() {
		return new Obstacle()
	}

	method isObstacleIn(position) {
		const elements = game.getObjectsIn(position)
		return !elements.isEmpty() and elements.first().isSolid()
	}

}

//class Obstacle {
//
//	var property position = randomizer.emptyPosition()
//	const imageFile
//	const asset
//
//	method image() {
//		return imageFile + asset + ".png"
//	}
//
////	method whenCollide(character) { //Sirve??
////		character.evadeCollide()
////	}
//	method isSolid() {
//		return true
//	}
//
//}
//
////object obstacleManager {
////
////	const property factories = [ plantFactory, brickFactory, stoneFactory ]
////	const randomBlocks = 20
////
////	method configurate() {
////		const obstacles = (0 .. randomBlocks).map({ o => factories.anyOne().create() })
////		obstacles.forEach({ o => game.addVisual(o)})
////	}
////
////	method isObstacleIn(position) {
////		const elements = game.getObjectsIn(position)
////		return (!elements.isEmpty()) and elements.first().isSolid()
////	}
////
////}
////class Plant inherits Obstacle(imageFile = 'plants0', asset = (1 .. 3).anyOne()) {
////
////}
////
////class Stone inherits Obstacle(imageFile = 'stone0', asset = (1 .. 2).anyOne()) {
////
////}
////
////class Brick inherits Obstacle(imageFile = 'brick0', asset = (1 .. 3).anyOne()) {
////}
////
////object plantFactory {
////
////	method create() {
////		return new Plant()
////	}
////
////}
////
////object brickFactory {
////	method create() {
////		return new Brick()
////	}
////
////}
////
////object stoneFactory {
////
////	method create() {
////		return new Stone()
////	}
////
////} 