# Cloak of Darkness for Gamefic.
# Gamefic implementation by Peter Orme.
# Version 1.0.0 / 1 April 2014
#
# Cloak of Darkness is a "hello world" example for interactive fiction.
# See http://www.firthworks.com/roger/cloak/
# Based on the Inform7 implementation by Emily Short and Graham Nelson.
#
# Version 2.0.0 / 12 July 2014 by Fred Snyder
# Updated to use new features of Gamefic.
#
# Version 3.0.0 / 11 February 2023 by Fred Snyder
# Improved formatting and new features

require 'gamefic'
require 'gamefic-standard'

module CloakOfDarkness
  class Plot < Gamefic::Plot
    include Gamefic::Standard
  end
end

CloakOfDarkness::Plot.script do
  # The Foyer is where the player starts.

  foyer = make Room,
               name: 'Foyer of the Opera House',
               description: 'You are standing in a spacious hall, splendidly decorated in red and gold, with glittering chandeliers overhead. The entrance from the street is to the north, and there are doorways south and west.'

  # There's a "fake" door north, which the player can never go through.

  frontDoor = make Portal,
                   name: 'north',
                   description: 'The door to the street.',
                   parent: foyer,
                   proper_named: true

  respond :go, frontDoor do |actor, _dest|
    actor.tell "You've only just arrived, and besides, the weather outside seems to be getting worse."
  end

  # The cloakroom is west of the foyer.

  cloakroom = make Room,
                   name: 'Cloakroom',
                   description: 'The walls of this small room were clearly once lined with hooks, though now only one remains. The exit is a door to the east.'

  connect foyer, cloakroom, 'west'

  # In the cloak room there's a hook where we can hang the cloak.
  # It doesn't need a new class, it's just a fixture which responds to "put on" and "look".

  hook = make Supporter,
              name: 'a small brass hook',
              description: "It's just a brass hook.",
              parent: cloakroom,
              synonyms: 'peg'

  respond :look, hook do |actor, _hook|
    if hook.children.empty?
      actor.tell "It's just a brass hook, screwed to the wall."
    else
      actor.tell "It's just a brass hook, with #{a hook.children[0]} hanging on it, screwed to the wall."
    end
  end

  interpret 'hang :item on :hook', 'place :item :hook'

  # The eponymous Cloak of Darkness: when the player takes it to the bar, everything is dark.
  # We don't handle wearing it different from carrying it.

  cloak = make Item,
               name: 'a velvet cloak',
               description: 'A handsome cloak, of velvet trimmed with satin, and slightly splattered with raindrops. Its blackness is so deep that it almost seems to suck light from the room.',
               synonyms: 'dark black satin'

  # Stop the player from dropping the cloak except in the cloak room.

  respond :drop, cloak do |actor, _message|
    if actor.parent != cloakroom
      actor.tell "This isn't the best place to leave a smart cloak lying around."
    else
      actor.proceed
    end
  end

  # The bar. If the player is wearing the cloak, it's dark and the player can't see a thing.
  # Otherwise, the player can see the sawdust on the floor.

  bar = make Room,
             name: 'Foyer Bar',
             description: "The bar, much rougher than you'd have guessed after the opulence of the foyer to the north, is completely empty. There seems to be some sort of message scrawled in the sawdust on the floor."
  connect foyer, bar, 'south'

  # There's a message in the sawdust. If the player does things in the dark, the message is destroyed.
  # We track this using a player.session[:disturbed] boolean.

  message = make Scenery,
                 name: 'message',
                 description: '', # this is handled in a specific respond :look
                 parent: bar,
                 synonyms: 'scrawl scrawled sawdust dust'

  respond :look, message do |actor, _message|
    if actor.session[:disturbed]
      actor.conclude :you_have_lost
    else
      actor.conclude :you_have_won
    end
  end

  interpret 'read :message', 'look :message'

  # Check if the bar is dark

  before_action do |action|
    actor = action.actor
    verb = action.verb

    dark = (cloak.parent == actor)
    if actor.room == bar && dark
      if verb == :look
        actor.tell "It's too dark in here."
        action.cancel
      elsif verb != :go
        actor.tell "Uh oh, you're wandering around in the dark!"
        actor.session[:disturbed] = true
        action.cancel
      end
    end
  end

  # Suppress the room output if the bar is dark

  respond :go, Portal do |actor, _portal|
    buffer = actor.buffer { actor.proceed }
    dark = (cloak.parent == actor)
    if actor.room == bar && dark
      actor.tell "It's too dark in here."
    else
      actor.tell buffer
    end
  end

  # The player

  introduction do |player|
    player.tell "Hurrying through the rainswept November night, you're glad to see the bright lights of the Opera House. It's surprising that there aren't more people about but, hey, what do you expect in a cheap demo game...?"
    player.parent = foyer
    cloak.parent = player
    player[:disturbed] = false
    player.perform :look
  end

  # Two different endings

  conclusion :you_have_won do |actor|
    actor.tell 'The message, neatly marked in the sawdust, reads...'
    actor.tell '*** You have won ***'
  end

  conclusion :you_have_lost do |actor|
    actor.tell 'The message has been carelessly trampled, making it difficult to read. You can just distinguish the words...'
    actor.tell '*** You have lost ***'
  end

  meta :test, 'me' do |actor|
    actor.queue.concat [
      's',
      'n',
      'w',
      'inventory',
      'hang cloak on hook',
      'e',
      's',
      'read message'
    ]
  end
end
