var Game = function(element, playerId) {
  console.log("GAME CREATED", playerId)
  this.element = $(element); // This element is game-container. We can put stuff there!
  this.init = function() {
    this.center_deck = [[1,'a'],[1, 'b']]
    this.remaining_deck = []
  };
  this.start = function() {
    this.init()
    // TODO: If we decide to go the primarily JS/ActionScript route,
    // then we would move most of the logic from game.rb into here,
    // similar to the game.js file in the tic-tac-toe tutorial.
    console.log("We started!");
    console.log("player", playerId);
    if (playerId == 1) {
      console.log(this.center_deck[0]);
    } else {
      console.log(this.center_deck[1]);
    }
  }



  this.start();

}
