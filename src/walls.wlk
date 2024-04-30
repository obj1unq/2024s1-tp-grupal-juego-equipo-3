import wollok.game.*
import randomizer.*

class Obstacle {
 
 // TODO: Revisar dónde configurar las colisiones
 // TODO: Ver que métodos y atributos se pueden heredar desde la clase Obstacle
  var property position = game.at(0,0)
  
  method whenCollide(mainCharacter){
  		mainCharacter.evadeCollide()
  }
}

// Creación de clases que heredan de obstacle
class Plant inherits Obstacle{
	method image() = "plants0"+randomizer.randomNumber(1, 2)+".png"
}


class Stone inherits Obstacle{
	method image() = "stone0"+randomizer.randomNumber(1, 2)+".png"
}

class Brick inherits Obstacle{
	method image() = "brick0"+randomizer.randomNumber(1, 3)+".png"
}