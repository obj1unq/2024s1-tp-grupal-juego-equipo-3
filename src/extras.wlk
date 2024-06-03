import wollok.game.*
import main_character.*
import randomizer.*
import obstacles.*
import spiral.*
import mosquito.*
import posiciones.*
import globalConfig.*

object gameConfiguration {

	const gameHeight = 15
	const gameWidth = 15

	method init() {
		game.title("game")
		game.boardGround("background.png")
		game.height(gameHeight)
		game.width(gameWidth)
		game.cellSize(64)
		game.addVisual(mainCharacter)
		(0 .. 3).forEach({ n => mosquitoHardFactory.createMosquito()})
//      (0..3).forEach({ n=> [mosquitoHardFactory,mosquitoSoftFactory].anyOne().createMosquito() })
		mosquitosManager.createMosquitos()
		spiralBoxManager.createBoxSpirals()
		obstacleGeneration.configurate()
		keyboardConfig.configurate()
	}

}

object keyboardConfig {

	method configurate() {
		keyboard.left().onPressDo{ mainCharacter.goesTo(leftDirection)}
		keyboard.right().onPressDo{ mainCharacter.goesTo(rightDirection)}
		keyboard.up().onPressDo{ mainCharacter.goesTo(upDirection)}
		keyboard.down().onPressDo{ mainCharacter.goesTo(downDirection)}
		keyboard.c().onPressDo{ mainCharacter.sayDirection()}
		keyboard.f().onPressDo{ mainCharacter.foundElement()}
		keyboard.p().onPressDo{ mainCharacter.putSpiral()}
//		keyboard.u().onPressDo{ mainCharacter.useSpray()}
//		keyboard.t().onPressDo{ mainCharacter.cleanTrash()}
	}

}

