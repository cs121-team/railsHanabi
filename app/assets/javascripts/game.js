var Game = function(element, playerId) {
  console.log("GAME CREATED", playerId)
  this.element = $(element);
  this.init = function() {
    console.log("WE STARTED!!!!");
  }

}