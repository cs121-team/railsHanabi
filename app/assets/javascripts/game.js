var Game = function(element, playerId) {
  this.element = $(element); // This element is game-container. We can put stuff there!
  this.init = function() {
    this.turn = 0
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
      this.distributeCards(); //TODO(olivia): Make this something that naturally gets called during game start
      $('#your-turn').show();
    }
    
  };

  this.start = function() {
    this.init();
    this.bindEvents();
    var displayCards = this.players;
    displayCards.splice(playerId,1);

    //player can only see other players' cards
    //$('#card1').html(displayCards);
    if (playerId == 0) {
      $('#status').html('Your turn');
    } else {
      $('#status').html('Waiting for Player0 to play.');
    }

  }

  this.bindEvents = function() {
    $('#take-turn').click(function(e){
      e.preventDefault();
      $('#your-turn').hide();
      App.game.takeTurn(playerId, "play", ["1", "A"]); //TODO: Don't hard-code this.
    });

    $("#play-options input:radio").click(function(e) {
      this.turnType = e.target.value;
      switch(e.target.value) {
        case "play":
          $('#my-cards').show();
          $('#hints').hide();
          break;
        case "hint":
          $('#hints').show();
          $('#my-cards').hide();
          break;
        case "discard":
          $('#my-cards').show();
          $('#hints').hide();
          break;
        default:
          break;
      }
    });

  }

  this.distributeCards = function() {
    App.game.setup();
  };

  this.showCards = function(cards) {
    var handArr = []
    for (var hand of cards) {
      var cardStr = "["
      for (var card of hand) {
        cardStr += card[0] + card[1] + ", "
      }
      cardStr += "], "
      handArr += cardStr
    }

    $('#card1').html(handArr);
  }

  this.turnFinished = function() {
    // Later, do more with this turn
    this.turn = (this.turn + 1) % 2 //TODO(olivia): Later come back and don't hard code # players
    if (this.turn == playerId) {
      $('#your-turn').show();
    }
  }

  this.updatedState = function(data) {
    console.log("WE GOT DATA!!!!!!!!!");
    console.log(data);
    this.turnFinished()
  }


  this.start();

}
