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
		game.clear()
		console.println(option.value())
		game.addVisual(self)
		keyboard.right().onPressDo{ option = option.next()}
		keyboard.left().onPressDo{ option = option.previous()}
		keyboard.enter().onPressDo{ option.goMenu()}
	}

}

object start {

	const property value = 1

	method goMenu() {
		game.clear()
		game.addVisual(gameBackground)
		game.addVisual(mainCharacter)
		(0 .. 3).forEach({ n => mosquitoFactory.createMosquito()})
		(0 .. 2).forEach({ n => mosquitoHardFactory.createMosquito()})
		mosquitosManager.createMosquitos()
		obstacleGeneration.configurate()
		keyboardConfig.configurate()
	}

	method previous() {
		return exit
	}

	method next() {
		return help
	}

}

object help {

	const property value = 2

	method goMenu() {
		game.clear()
		game.addVisual(helpMenu)
		self.configurate()
	}

	method previous() {
		return start
	}

	method next() {
		return exit
	}

	method configurate() {
		keyboard.backspace().onPressDo{ helpMenu.back()} // si se presiona enter no funciona
	}

}

object exit {

	const property value = 3

	method goMenu() {
		game.stop()
	}

	method previous() {
		console.println("p3")
		return help
	}

	method next() {
		console.println("n3")
		return start
	}

}

object helpMenu {

	const property position = game.at(0, 0)

	method image() = "help.png"

	method back() {
		game.addVisual(menus)
		menus.configurate()
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

