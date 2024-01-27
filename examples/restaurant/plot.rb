# Restaurant
# A Gamefic demo by Fred Snyder
#

require 'gamefic'
require 'gamefic-standard'

module Restaurant
  class Plot < Gamefic::Plot
    include Gamefic::Standard
  end
end

Restaurant::Plot.script do
  lobby = make Room, name: 'the lobby',
                     description: 'An alcove that opens into the dining area to the north. The exit is south.'

  introduction do |actor|
    actor.parent = lobby
    actor.tell "You're in the lobby of your favorite restaurant. You called ahead to make your order and paid by credit card. All that's left to do is enjoy your meal and go home."
  end

  coatroom = make Room, name: 'the coatroom', description: 'A walk-in closet where guests can hang their coats.'
  connect coatroom, lobby, 'east'

  dining = make Room, name: 'the dining room',
                      description: 'The main dining area. Your favorite table is in the northwest corner.'
  connect dining, lobby, 'south'

  jacket = make Item, name: 'a wool jacket', description: 'A thick wool jacket.', parent: coatroom

  corner = make Room, name: 'a secluded corner',
                      description: 'This cozy nook at the end of the dining room has your favorite table.'
  connect corner, dining, 'southeast'

  table = make Supporter, name: 'table', description: 'A cozy booth.', parent: corner

  chicken = make Item, name: 'a chicken dinner',
                       description: 'A succulent roast chicken breast with a vegetable medley.', parent: table

  seat = make Supporter, name: 'seat', description: 'The seat.', parent: corner
  seat.enterable = true

  door = make Portal, name: 'south', parent: lobby, proper_named: true

  respond :go, siblings(door) do |actor, _door|
    # If the player has eaten the chicken, its parent will be nil.
    if !chicken.parent.nil?
      actor.tell "You can't leave the restaurant yet. You're still hungry!"
    # Just for extra fun, we'll script the player to put on the jacket before
    # leaving.
    elsif jacket.parent == actor && jacket.attached?
      actor.conclude :finished
    else
      actor.tell "Hmm... it looks a little cold out there. You're not dressed for it right now."
    end
  end

  respond :wear, jacket do |actor, _jacket|
    if jacket.parent == actor && jacket.attached?
      actor.tell "You're already wearing the jacket."
    else
      jacket.parent = actor
      jacket.attached = true
      actor.tell 'You put on the jacket.'
    end
  end
  interpret 'put on :clothing', 'wear :clothing'
  interpret 'put :clothing on', 'wear :clothing'
  interpret 'don :clothing', 'wear :clothing'

  respond :doff, jacket do |actor, jacket|
    if jacket.parent == actor && jacket.attached?
      jacket.attached = false
      actor.tell "You take off #{the jacket}."
    else
      actor.tell "You're not wearing #{the jacket}."
    end
  end
  interpret 'remove :clothing', 'doff :clothing'
  interpret 'take off :clothing', 'doff :clothing'
  interpret 'take :clothing off', 'doff :clothing'

  respond :drop, children(jacket) do |actor, jacket|
    jacket.attached = false
    actor.proceed
  end

  respond :eat, chicken do |actor, chicken|
    actor.tell "You eat #{the chicken}."
    chicken.parent = nil
  end

  conclusion :finished do |actor|
    actor.tell 'You walk home satisfied.'
  end

  meta :test, 'me' do |actor|
    actor.queue.concat [
      'n',
      'nw',
      'eat dinner',
      'se',
      's',
      'w',
      'take jacket',
      'wear jacket',
      'e',
      's'
    ]
  end
end
