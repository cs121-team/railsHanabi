var Game = function(element, playerId) {
  console.log("GAME CREATED", playerId)
  this.element = $(element); // This element is game-container. We can put stuff there!
  this.init = function() {
    this.center_deck = [];
    this.remaining_deck = [];
    this.players = [[],[],[],[]];
    this.ranks = ['1','1','1','2','2','3','3','4','4','5'];
    this.suites = ['A','B','C','D','E'];

    //Create the initial deck
    for (i = 0; i < this.ranks.length; i++) {
      for (j = 0; j < this.suites.length; j++){
        this.remaining_deck.push([this.ranks[i],this.suites[j]]);
      }
    }
    if (playerId == 0) {
      this.distributeCards();
    }
    // //Create the hands of players
  };
  this.start = function() {
    this.init()
    // TODO: If we decide to go the primarily JS/ActionScript route,
    // then we would move most of the logic from game.rb into here,
    // similar to the game.js file in the tic-tac-toe tutorial.
    // console.log("We started!");
    // console.log("player", playerId);
    // console.log(this.remaining_deck.length);
    // console.log(this.players.length);
    var displayCards = this.players;
    displayCards.splice(playerId,1);

    //player can only see other players' cards
    //$('#card1').html(displayCards);
    //console.log(this.players[playerId]);
    $('#status').html('Your turn');
    //this.displayCards();

  }

  this.distributeCards = function() {
    for (i = 0; i < this.players.length; i++) {
      var x = 0;
      while (x < 5) {
        var index = Math.floor(Math.random() * this.remaining_deck.length);
        this.players[i].push(this.remaining_deck[index]);
        this.remaining_deck.splice(index,1);
        x += 1;
      }
    };
    App.game.setup();
  };

  this.showCards = function(cards) {
    $('#card1').html(cards);
  }

  


  // this.displayCards = function() {
  //   $("now").html("happy");
  //   var newHTML = [];
  //   for (i = 0; i < this.players.length; i++) {
  //     newHTML.push('<span>' + '2' + '</span>');
  //     $("players").html(i);
  //     console.log("????");
  //   }




  this.start();

}
