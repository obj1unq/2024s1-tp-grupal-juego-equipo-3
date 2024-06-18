import wollok.game.*
import main_character.*
import randomizer.*
import obstacles.*
import mosquito.*
import posiciones.*
import globalConfig.*

object gameConfig {

	method build() {
		game.clear()
		game.addVisual(mainCharacter)
		interface.build()
		(0 .. 3).forEach({ n => mosquitoFactory.createMosquito()})
		(0 .. 2).forEach({ n => mosquitoHardFactory.createMosquito()})
		mosquitosManager.createMosquitos()
		obstacleGeneration.configurate()
		keyboardConfig.configurate()
	}

}

object interface {

	method build() {
		game.addVisual(menu)
		game.addVisual(lifeCounter)
		game.addVisual(repellantCounter)
		mosquitoesCounter.agregarContador()
		trashCounter.agregarContador()
		spiralsCounter.agregarContador()
		gameCounter.agregarContador()
		gameCounter.start()
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

	override method image() = "repellant" + mainCharacter.lifes() + ".png"

}

object repellantCounter inherits MenuElement {

	override method image() = "lifes" + mainCharacter.lifes() + ".png"

}

class MenuCounter inherits MenuElement {

	var unidad = new Unidad(modelo = self)
	var decena = new Decena(modelo = self)

	method agregarContador() {
		game.addVisual(self)
		game.addVisual(unidad)
		game.addVisual(decena)
	}

	method number()

}

class Numero {

	const modelo

	method position()

	method image() {
		return self.prefix() + self.number() + ".png"
	}

	method number()

	method prefix()

}

class Unidad inherits Numero {

	override method position() {
		return modelo.position().right(1)
	}

	override method number() {
		return modelo.number() - modelo.number().div(10) * 10
	}

	override method prefix() {
		return "u"
	}

}

class Decena inherits Numero {

	override method position() {
		return modelo.position()
	}

	override method number() {
		return modelo.number().div(10)
	}

	override method prefix() {
		return "d"
	}

}

object mosquitoesCounter inherits MenuCounter(position = game.at(8, 14)) {

	override method number() {
		return 47
	}

}

object trashCounter inherits MenuCounter(position = game.at(10, 14)) {

	override method number() {
		return 23
	}

}

object spiralsCounter inherits MenuCounter(position = game.at(12, 14)) {

	override method number() {
		return 5
	}

}

object gameCounter inherits MenuCounter(position = game.at(14, 14)) {

	const gameDuration = 99
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
		game.onTick(1000, tickEventName, {=> time--})
	}

	method stop() {
		game.removeTickEvent(tickEventName)
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
		keyboard.c().onPressDo{ mainCharacter.sayDirection()}
		game.onCollideDo(mainCharacter, { o => o.collision()})
	}

}

