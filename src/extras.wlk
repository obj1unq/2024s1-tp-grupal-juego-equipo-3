import wollok.game.*
import main_character.*
import randomizer.*
import obstacles.*
import mosquito.*
import posiciones.*
import globalConfig.*

object gameConfiguration {

	const gameHeight = 16
	const gameWidth = 20

	method init() {
		game.title("game")
		game.boardGround("background.png")
		game.height(gameHeight)
		game.width(gameWidth)
		game.cellSize(64)
		game.addVisual(mainCharacter)
		(0 .. 3).forEach({ n => mosquitoSoftFactory.createMosquito()})
		(0 .. 2).forEach({ n=> mosquitoHardFactory.createMosquito() })
		mosquitosManager.createMosquitos()
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
	}

}



