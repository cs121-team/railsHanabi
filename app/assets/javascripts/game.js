var Game = function(element, playerId) {
  console.log("GAME CREATED", playerId)
  this.element = $(element); // This element is game-container. We can put stuff there!

  this.start = function() {
    // TODO: If we decide to go the primarily JS/ActionScript route,
    // then we would move most of the logic from game.rb into here, 
    // similar to the game.js file in the tic-tac-toe tutorial.
    console.log("We started!");
  }



  this.start()

}