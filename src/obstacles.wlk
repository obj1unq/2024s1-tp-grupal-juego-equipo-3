import wollok.game.*
import randomizer.*

class Obstacle {
 
 // TODO: Revisar dónde configurar las colisiones
 // TODO: Ver que métodos y atributos se pueden heredar desde la clase Obstacle
  var property position
  
  method whenCollide(mainCharacter){
  		mainCharacter.evadeCollide()
  }
}

// Creación de clases que heredan de obstacle
 // TODO: Ver cómo refactorizar imageFile e image
class Plant inherits Obstacle{
	var property imageFile = "plants0"+randomizer.randomNumber(1, 3)+".png"
	method image() = imageFile

}

class Stone inherits Obstacle{
	var property imageFile = "stone0"+randomizer.randomNumber(1, 2)+".png"
	method image() = imageFile
}

class Brick inherits Obstacle{
	var property imageFile = "brick0"+randomizer.randomNumber(1, 3)+".png"
	method image() = imageFile
}

object plant{
	method crear(position){
		return new Plant(position = position)
	}
}

object brick{
	method crear(position){
		return new Brick(position = position)
	}
}

object stone{
	method crear(position){
		return new Stone(position = position)
	}
}