import wollok.game.*
import main_character.*
import randomizer.*
import obstacles.*
import mosquito.*
import posiciones.*
import globalConfig.*

object initialMenu {

	const gameWidth = 20
	const gameHeight = 16

	method start() {
		game.title("game")
		game.height(gameHeight)
		game.width(gameWidth)
		game.cellSize(64)
		menus.configurate()
	}

}

object menus {

	var property option = start
	const property position = game.at(0, 0)

	method image() = "menu_" + option.value() + ".png"

	method configurate() {
		game.addVisual(self)
		keyboard.right().onPressDo{ option.next(self)}
		keyboard.left().onPressDo{ option.previous(self)}
		keyboard.enter().onPressDo{ option.goMenu(self)}
	}

}

object start {

	const property value = 1

	method goMenu(menu) {
		game.clear()
		game.addVisual(gameBackground)
		game.addVisual(mainCharacter)
		(0 .. 3).forEach({ n => mosquitoFactory.createMosquito()})
		(0 .. 2).forEach({ n => mosquitoHardFactory.createMosquito()})
		mosquitosManager.createMosquitos()
		obstacleGeneration.configurate()
		keyboardConfig.configurate()
	}

	method previous(menu) {
		menu.option(exit)
	}

	method next(menu) {
		menu.option(help)
	}

}

object help {

	const property value = 2

	method goMenu(menu) {
		menu.option(helpMenu)
	}

	method previous(menu) {
		menu.option(start)
	}

	method next(menu) {
		menu.option(exit)
	}

}

object exit {

	const property value = 3

	method goMenu(menu) {
		game.stop()
	}

	method previous(menu) {
		menu.option(help)
	}

	method next(menu) {
		menu.option(start)
	}

}

object helpMenu {

	const property value = 4

	method goMenu(menu) {
		menu.option(start)
	}

	method previous(menu) {
	}

	method next(menu) {
	}

}

object gameBackground {

	const property position = game.at(0, 0)

	method image() = "background.png"

}

object keyboardConfig {

	method configurate() {
		keyboard.left().onPressDo{ mainCharacter.goesTo(leftDirection)}
		keyboard.right().onPressDo{ mainCharacter.goesTo(rightDirection)}
		keyboard.up().onPressDo{ mainCharacter.goesTo(upDirection)}
		keyboard.down().onPressDo{ mainCharacter.goesTo(downDirection)}
		keyboard.c().onPressDo{ mainCharacter.sayDirection()}
		keyboard.enter().onPressDo{
		}
		game.onCollideDo(mainCharacter, { o => o.collision()})
	}

}

