import wollok.game.*
import main_character.*
import randomizer.*
import obstacles.*
import mosquito.*
import posiciones.*
import globalConfig.*
import navigation.*
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
		menu.option(help)
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

object interface {

	const menuCounters = #{ mosquitoesCounter, trashCounter, spiralsCounter, gameCounter }

	method build() {
		game.addVisual(menu)
		game.addVisual(lifeCounter)
		game.addVisual(repellantCounter)
		self.addMenuCounters()
		gameCounter.start()
	}

	method addMenuCounters() {
		menuCounters.forEach{ menuElement => menuElement.addCounter()}
	}

}

class MenuElement {

	const property position = game.at(0, 13)

	method image() {
		return "counters.png"
	}

}

object menu inherits MenuElement {

	override method image() = "menu.png"

}

object lifeCounter inherits MenuElement {

	override method image() = "lifes" + mainCharacter.lifes() + ".png"

}

object repellantCounter inherits MenuElement {

	override method image() = "repellant" + insecticide.shoots() + ".png"

}

class MenuCounter inherits MenuElement {

	var unidad = new Unidad(modelo = self, prefix = "u")
	var decena = new Decena(modelo = self, prefix = "d")

	method addCounter() {
		game.addVisual(self)
		game.addVisual(unidad)
		game.addVisual(decena)
	}

	method removeCounter() {
		game.removeVisual(self)
		game.removeVisual(unidad)
		game.removeVisual(decena)
	}

	method number()

}

class Numero {

	const modelo
	const prefix

	method position()

	method image() {
		return prefix + self.number() + ".png"
	}

	method number()

}

class Unidad inherits Numero {

	override method position() {
		return modelo.position().right(1)
	}

	override method number() {
		return modelo.number() % 10
	}

}

class Decena inherits Numero {

	override method position() {
		return modelo.position()
	}

	override method number() {
		return modelo.number().div(10) % 10
	}

}

class Centena inherits Numero {

	override method position() {
		return modelo.position().left(1)
	}

	override method number() {
		return modelo.number().div(100) % 10
	}

}

class Mil inherits Numero {

	override method position() {
		return modelo.position().left(2)
	}

	override method number() {
		return modelo.number().div(1000) % 10
	}

}

class FinalCounter inherits MenuCounter {

	var u = new Unidad(modelo = self, prefix = "")
	var d = new Decena(modelo = self, prefix = "")
	var c = new Centena(modelo = self, prefix = "")
	var m = new Mil(modelo = self, prefix = "")

	override method addCounter() {
		game.addVisual(self)
		game.addVisual(u)
		game.addVisual(d)
		game.addVisual(c)
		game.addVisual(m)
	}

	override method removeCounter() {
		game.removeVisual(self)
		game.removeVisual(u)
		game.removeVisual(d)
		game.removeVisual(c)
		game.removeVisual(m)
	}

}

object mosquitoesCounter inherits MenuCounter(position = game.at(8, 14)) {

	override method number() {
		return bag.mosquitoes()
	}

}

object trashCounter inherits MenuCounter(position = game.at(10, 14)) {

	override method number() {
		return bag.trashes()
	}

}

object spiralsCounter inherits MenuCounter(position = game.at(12, 14)) {

	override method number() {
		return bag.spirals()
	}

}

object collectedCounter inherits FinalCounter(position = game.at(13, 9)) {

	override method number() {
		return bag.trashes() * 50
	}

}

// TODO: Revisar condiciones de bonus
object bonusCounter inherits FinalCounter(position = game.at(13, 8)) {

	override method number() {
		return bag.trashes() * 50
	}

}

object collectedMosquitoesCounter inherits FinalCounter(position = game.at(13, 7)) {

	override method number() {
		return bag.mosquitoes() * 25
	}

}
// TODO: No sumar el tiempo si el personaje muere o condicionarlo
object timeBonusCounter inherits FinalCounter(position = game.at(13, 6)) {

	override method number() {
		return gameCounter.time() * 50
	}

}

object totalCounter inherits FinalCounter(position = game.at(13, 5)) {

//TODO: Resolver bonito u.u
	override method number() {
		return bonusCounter.number() + timeBonusCounter.number() + collectedMosquitoesCounter.number() + collectedCounter.number()
	}

}

object gameCounter inherits MenuCounter(position = game.at(14, 14)) {

	const gameDuration = 40
	const tickEventName = 'gameCounterTick'
	var property time = 0

	override method number() {
		return time
	}

	method isTimeRunningOut() {
		return time < 10
	}

	method start() {
		self.time(gameDuration)
		game.onTick(1000, tickEventName, {=> self.remainingTime()})
	}

	method stop() {
		game.removeTickEvent(tickEventName)
	}

	method remainingTime() {
		if (self.isTimeout()) {
			self.stop()
			gameOver.endGame()
		} else {
			time--
		}
	}

	method isTimeout() {
		return time == 0
	}

}

object keyboardConfig {

	method configurate() {
		keyboard.left().onPressDo{ mainCharacter.goesTo(leftDirection)}
		keyboard.right().onPressDo{ mainCharacter.goesTo(rightDirection)}
		keyboard.up().onPressDo{ mainCharacter.goesTo(upDirection)}
		keyboard.down().onPressDo{ mainCharacter.goesTo(downDirection)}
		//keyboard.s().onPressDo{ mainCharacter.putSpiral()}
		keyboard.d().onPressDo{ mainCharacter.disparar()}
		game.onCollideDo(mainCharacter, { o => o.collision()})
	}

}

