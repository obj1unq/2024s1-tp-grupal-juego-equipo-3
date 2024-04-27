import wollok.game.*

class Mosquito {
  var property position = game.at(0,0)

  method image() = "mosquito01.png"
  
  method setPosition(x, y){
  		position = game.at(x, y)
  }
  
  method whenCollide(mainCharacter){
  		mainCharacter.evadeCollide()
  }
  
  method moving(){ 
  	self.position(new Position(x = self.position().x() +1, y = self.position().y() +1))
  }  
  
}