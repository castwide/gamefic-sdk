# Warehouse
# A Gamefic demo by Fred Snyder
#
# Examples of various types of containers and supporters, including lockable
# containers.

require 'gamefic'
require 'gamefic-standard'

module Warehouse
  class Plot < Gamefic::Plot
    include Gamefic::Standard
  end
end

Warehouse::Plot.script do
  office = make Room, name: 'the manager\'s office', description: 'A small office in the back of the warehouse.'

  desk = make Supporter, name: 'a desk', description: 'A plain wooden desk.', parent: office

  chair = make Supporter, name: 'a chair', description: 'A straight-backed wooden chair.', parent: office
  # Make the chair enterable so the player can use it.
  chair.enterable = true

  key = make Item, name: 'a key', description: 'A small key for a padlock.', parent: desk

  stacks = make Room, name: 'the stacks', description: 'The warehouse\'s main storage area.'
  connect stacks, office, 'south'

  # Containers have a key property that indicates which entity unlocks it.
  # Setting the key property automatically selects the :lockable option.
  crate = make Container, name: 'a crate',
                          description: 'A large wooden crate. According to the label, it was shipped from Fort Knox, Kentucky.', parent: stacks, lock_key: key
  crate.locked = true

  gold = make Item, name: 'a gold brick', description: 'A shiny gold brick.', parent: crate

  introduction do |actor|
    actor.parent = chair
    actor.tell "You are sitting in a small office inside a large warehouse. There's a gold brick somewhere in the stacks. Can you find it?"
  end

  respond :take, gold do |actor, _gold|
    actor.conclude :found_gold
  end

  conclusion :found_gold do |actor|
    actor.tell 'Congratulations, you got the gold!'
  end

  meta :test, 'me' do |actor|
    actor.queue.concat [
      'look around',
      'get off chair',
      'look desk',
      'take key',
      'n',
      'unlock crate with key',
      'open crate',
      'take gold'
    ]
  end
end
