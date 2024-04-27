import wollok.game.*

class Obstacle {
  var property position = game.at(0,0)

  method image() = "plants01.png"
  
  method setPosition(x, y){
  		position = game.at(x, y)
  }
  
  method whenCollide(mainCharacter){
  		mainCharacter.evadeCollide()
  }
}