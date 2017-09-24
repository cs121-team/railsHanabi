var Game = function(element, playerId) {
  this.element = $(element); // This element is game-container. We can put stuff there!
  var turnType = 'blah';
  var hintToPlayer;
  var hint;

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
      $('#your-turn').hide()
      if (turnType == "hint") {
      	console.log(turnType);
      	console.log(hintToPlayer);
      	console.log(hint);
		App.game.takeTurn(playerId, turnType, [hintToPlayer, hint]);
      } else {
      	console.log(turnType);
      	console.log(card);
      	App.game.takeTurn(playerId, turnType, card);
      }
    });

    $("#play-options input:radio").click(function(e) {
      turnType = e.target.value;
      $('#hint-list').hide();
      switch(e.target.value) {
        case "play":
          $('#my-cards').show();
          $('#hint-players').hide();
          break;
        case "hint":
          $('#hint-players').show();
          $('#my-cards').hide();
          break;
        case "discard":
          $('#my-cards').show();
          $('#hint-players').hide();
          break;
        default:
          break;
      }
    });

    $("#my-cards input:radio").click(function(e) {
      card = e.target.value;
    });

    $("#hint-players input:radio").click(function(e) {
      hintToPlayer = e.target.value;
      console.log('trying to show hints?');
      $('#hint-list').show();
    });

    $("#hint-list input:radio").click(function(e) {
      hint = e.target.value;
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
