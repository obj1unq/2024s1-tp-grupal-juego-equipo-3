import wollok.game.*
import main_character.*
import randomizer.*
import obstacles.*
import mosquito.*
import posiciones.*
import globalConfig.*
import sounds.*

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
		(1..5).forEach({m => mosquitosManager.createMosquitoRandom()})
		mosquitosManager.createMosquitos()
		obstacleManager.configurate()
		keyboardConfig.configurate()
		settingsMusica.iniciarTeclas()
	}

}

object keyboardConfig {

	method configurate() {
		keyboard.left().onPressDo{ mainCharacter.goesTo(leftDirection)}
		keyboard.right().onPressDo{ mainCharacter.goesTo(rightDirection)}
		keyboard.up().onPressDo{ mainCharacter.goesTo(upDirection)}
		keyboard.down().onPressDo{ mainCharacter.goesTo(downDirection)}
		keyboard.c().onPressDo{ mainCharacter.sayDirection()}
		game.onCollideDo(mainCharacter, {o => o.collision()})
		
	}

}



