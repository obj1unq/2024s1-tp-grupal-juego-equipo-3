import wollok.game.*
import main_character.*
import randomizer.*
import obstacles.*
import mosquito.*
import posiciones.*
import globalConfig.*
import counters.*
import collectable.*

object gameConfig {

	method build() {
		game.clear()
		game.addVisual(mainCharacter)
		interface.build()
		(1 .. 5).forEach({ m => mosquitosManager.createMosquitoRandom()})
		mosquitosManager.createMosquitos()
		(1 .. 3).forEach({ t => trashFactory.createSiPuedo()})
		game.onTick(2500, "CREAR ELEMENTOS", { elementManager.createElement()})
		obstacleManager.configurate()
		keyboardConfig.configurate()
	}

}

object gameBackground {

	const property position = game.at(0, 0)

	method image() = "background.png"

}

object gameConfiguration {

	const gameWidth = 20
	const gameHeight = 16

	method start() {
		game.title("DENGUE")
		game.height(gameHeight)
		game.width(gameWidth)
		game.boardGround("background.png")
		game.cellSize(64)
		menus.configurate()
	}

}

object menus {

	var property option = start
	const property position = game.at(0, 0)

	method image() = option.menuName() + ".png"

	method configurate() {
		game.addVisual(self)
		keyboard.right().onPressDo{ option.next(self)}
		keyboard.left().onPressDo{ option.previous(self)}
		keyboard.enter().onPressDo{ option.goMenu(self)}
	}

}

object start {

	method goMenu(menu) {
		game.clear()
		loadScreen.build()
		menu.option(loadScreen)
	}

	method previous(menu) {
		menu.option(exit)
	}

	method next(menu) {
		menu.option(controls)
	}

	method menuName() {
		return "start"
	}

}

object controls {

	method goMenu(menu) {
		menu.option(controlsMenu)
	}

	method previous(menu) {
		menu.option(start)
	}

	method next(menu) {
		menu.option(exit)
	}

	method menuName() {
		return "controls"
	}

}

object exit {

	method goMenu(menu) {
		game.stop()
	}

	method previous(menu) {
		menu.option(controls)
	}

	method next(menu) {
		menu.option(start)
	}

	method menuName() {
		return "exit"
	}

}

object controlsMenu {

	method goMenu(menu) {
		menu.option(controls)
	}

	method menuName() {
		return "controlsMenu"
	}

}

object loadScreen {

	var property currentScreen = 0
	var property screens = 3
	var property position = game.at(0, 0)

	method image() = "loading" + currentScreen + ".jpg"

	method build() {
		game.addVisual(self)
		game.onTick(100, "load", { self.load()})
	}

	method load() {
		if (self.isComplete()) {
			self.stop()
			gameConfig.build()
		} else {
			currentScreen++
		}
	}

	method stop() {
		game.removeTickEvent("load")
	}

	method isComplete() {
		return currentScreen == screens
	}

}

object gameOver {

	const finalCounters = #{ collectedCounter, bonusCounter, timeBonusCounter, collectedMosquitoesCounter, totalCounter }

	method endGame() {
		game.clear()
		menus.option(self)
		menus.configurate()
		self.addFinalCounters()
	}

	method addFinalCounters() {
		finalCounters.forEach{ counter => counter.addCounter()}
	}

	method removeFinalCounters() {
		finalCounters.forEach{ counter => counter.removeCounter()}
	}

	method goMenu(menu) {
		self.removeFinalCounters()
		menu.option(start)
	}

	method menuName() {
		return "gameOver"
	}

}

