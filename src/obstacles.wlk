import wollok.game.*
import randomizer.*

class Obstacle {

	var property position = randomizer.emptyPosition() 
	var asset = (1..8).anyOne().toString()
	
	method image() = "obstacle0" + asset + ".png"
	
	method isSolid() {
		return true
	}

}

object obstacleManager {

	var randomBlocks = 20

	method configurate() {
		const obstacles = (0 .. randomBlocks).map({ o => self.create() })
		obstacles.forEach({ o => game.addVisual(o)})
	}

	method create() {
		return new Obstacle()
	}

	method isObstacleIn(position) {
		const elements = game.getObjectsIn(position)
		return (!elements.isEmpty()) and elements.first().isSolid()
	}

}