# Restaurant
# A Gamefic demo by Fred Snyder
#
# Examples of the clothing and edible libraries.

require 'gamefic'
require 'gamefic-standard'
require 'gamefic-standard/clothing'
require 'gamefic-standard/edible'
require 'gamefic-standard/test'

Gamefic.script do
  lobby = make Room, :name => 'the lobby', :description => 'An alcove that opens into the dining area to the north. The exit is south.'

  introduction do |actor|
    actor.parent = lobby
    actor.tell "You're in the lobby of your favorite restaurant. You called ahead to make your order and paid by credit card. All that's left to do is enjoy your meal and go home."
  end

  coatroom = make Room, :name => 'the coatroom', :description => 'A walk-in closet where guests can hang their coats.'
  connect coatroom, lobby, "east"

  dining = make Room, :name => 'the dining room', :description => 'The main dining area. Your favorite table is in the northwest corner.'
  connect dining, lobby, "south"

  jacket = make Clothing, :name => 'a wool jacket', :description => 'A thick wool jacket.', :parent => coatroom

  corner = make Room, :name => 'a secluded corner', :description => 'This cozy nook at the end of the dining room has your favorite table.'
  connect corner, dining, "southeast"

  table = make Supporter, :name => 'table', :description => 'A cozy booth.', :parent => corner

  chicken = make Item, :name => 'a chicken dinner', :description => 'A succulent roast chicken breast with a vegetable medley.', :parent => table
  chicken.edible = true

  seat = make Supporter, :name => 'seat', :description => 'The seat.', :parent => corner
  seat.enterable = true

  door = make Portal, :name => 'south', :parent => lobby, :proper_named => true

  respond :go, Gamefic::Query::Siblings.new(door) do |actor, door|
    # If the player has eaten the chicken, its parent will be nil.
    if chicken.parent != nil
      actor.tell "You can't leave the restaurant yet. You're still hungry!"
    # Just for extra fun, we'll script the player to put on the jacket before
    # leaving.
    elsif jacket.parent == actor and jacket.attached?
      actor.conclude @finished
    else
      actor.tell "Hmm... it looks a little cold out there. You're not dressed for it right now."
    end
  end

  @finished = conclusion do |actor|
    actor.tell "You walk home satisfied."
  end

  on_test :me do |actor, queue|
    queue.push "n"
    queue.push "nw"
    queue.push "eat dinner"
    queue.push "se"
    queue.push "s"
    queue.push "w"
    queue.push "take jacket"
    queue.push "wear jacket"
    queue.push "e"
    queue.push "s"
  end
end
