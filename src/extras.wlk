import wollok.game.*
import main_character.*
import randomizer.*
import obstacles.*

object gameConfiguration {

	method init() {
		game.title("game")
		game.boardGround("background.png")
		game.height(16)
		game.width(20)
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
	}

}

object obstacleGeneration {

	const property obstacles = [ plant, brick, stone ]

	method configurate() {
		var obstacle = (0 .. 30).map({ i => obstacles.anyOne().crear(randomizer.emptyPosition()) })
		obstacle.forEach({ i => game.addVisual(i)})
	}

}

