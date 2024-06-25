import wollok.game.*
import main_character.*
import randomizer.*
import obstacles.*
import mosquito.*
import posiciones.*
import collectable.*
import navigation.*
import backpack.*
import extras.*
import sounds.*

object limit {

	const property maxX = game.width() - 2
	const property minX = 1
	const property maxY = game.height() - 4
	const property minY = 1

	method in(position) {
		return position.x().between(minX, maxX) and position.y().between(minY, maxY)
	}

}

class Character {

	method canGo(position) {
		return limit.in(position) and not obstacleManager.isObstacleIn(position)
	}

	method isSolid() {
		return false
	}

	method isTakeable() {
		return false
	}

}

object gameConfig {

	const property gameElements = #{ mainCharacter, interface, mosquitoesManager, elementManager, obstacleManager, backpack }

	method build() {
		game.clear()
		gameElements.forEach{ element => element.build()}
		game.onCollideDo(mainCharacter, { o => o.collision()})
		soundProducer.sacarCancion()
		keyboardConfig.configurate()
		soundProducer.playCancion("nivelMusic.mp3")
		soundProducer.configurateSettings()
		gameCounter.start()
	}

}

object keyboardConfig {

	method configurate() {
		keyboard.left().onPressDo{ mainCharacter.goesTo(leftDirection)}
		keyboard.right().onPressDo{ mainCharacter.goesTo(rightDirection)}
		keyboard.up().onPressDo{ mainCharacter.goesTo(upDirection)}
		keyboard.down().onPressDo{ mainCharacter.goesTo(downDirection)}
		keyboard.e().onPressDo{ mainCharacter.putSpiral()}
		keyboard.d().onPressDo{ mainCharacter.disparar()}
	}

}

