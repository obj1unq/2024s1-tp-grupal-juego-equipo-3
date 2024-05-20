import wollok.game.*
import main_character.*
import randomizer.*
import obstacles.*
import spiral.*

const gameHeight = 15
const gameWidth = 15
const randomBlocks = 15

object gameConfiguration {

	method init() {
		game.title("game")
		game.boardGround("background.png")
		game.height(gameHeight)
		game.width(gameWidth)
		game.cellSize(64)
		game.addVisual(mainCharacter)
		obstacleGeneration.configurate()
		keyboardConfig.configurate()
	}

}

object keyboardConfig {

	method configurate() {
		keyboard.left().onPressDo{ mainCharacter.goesTo(leftDirection)}
		keyboard.right().onPressDo{ mainCharacter.goesTo(rightDirection)}
		keyboard.up().onPressDo{ mainCharacter.goesTo(topDirection)}
		keyboard.down().onPressDo{ mainCharacter.goesTo(downDirection)}
		keyboard.c().onPressDo{ mainCharacter.sayDirection()}
		keyboard.f().onPressDo{ mainCharacter.foundElement()}
		keyboard.p().onPressDo{ mainCharacter.putSpiral()}
		keyboard.u().onPressDo{ mainCharacter.useSpray()}
		keyboard.t().onPressDo{ mainCharacter.cleanTrash()}
	}

}

object obstacleGeneration {
	const property obstacles = [ plant, brick, stone ]

	method configurate() {
		var obstacle = (0 .. randomBlocks).map({ i => obstacles.anyOne().crear(randomizer.emptyPosition()) })
		obstacle.forEach({ i => game.addVisual(i)})
	}
	
	method isObstacleIn(position){
			const elements = game.getObjectsIn(position)
			if (elements.isEmpty()) {
				return false
			}
			return elements.first().isSolid()			
	}
	
}

