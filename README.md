# Gamefic SDK

**A Ruby Interactive Fiction Framework**

The Gamefic SDK provides development tools for writing games and interactive fiction with Gamefic.

## Installation

Install the gem:

    $ gem install gamefic-sdk

## Usage

This section provides a fast and simple introduction to using the SDK. Go to
the [Gamefic website](https://gamefic.com) for in-depth guides and
documentation.

### Creating a New Project

Create a new project and go to its directory:

    $ gamefic init my_game
    $ cd my_game

Test the project by running the game on the command line:

    $ rake ruby:run

The Ruby game works like a traditional text adventure:

    Hello, world!
    >

You can enter commands at the `>` prompt, but you haven't written any content,
so there's not much to do yet. Enter `QUIT` to exit the game.

### The Script Code

The plot for your narrative is defined in the `plot.rb` file. It should look
something like this:

```ruby
module Example
  class Plot < Gamefic::Plot
    UUID = 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'

    include Gamefic::Standard

    script do
      introduction do |actor|
        actor.tell "Hello, world!"
      end
    end
  end
end
```

`UUID` is a globally unique identifier. It can be useful if you want to
add your game to online catalogs, such as the [Interactive Fiction Database](https://ifdb.tads.org/),
but it's safe to delete if you don't need it.

['gamefic-standard'](https://github.com/castwide/gamefic-standard) is a collection
of baseline features that are frequently useful for interactive fiction. [Inform](http://inform7.com/)
developers should find it similar to Inform's Standard Rules. It defines common
components like Rooms and Characters, along with in-game commands like `GO`,
`GET`, and `DROP` to enable basic interactivity.

`script` is where you write the story itself. In the starter project,
the only thing in the script is an introductory message.

### Modifying the Script

Replace the contents of `plot.rb` with the following:

```ruby
module Example
  class Plot < Gamefic::Plot
    UUID = 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'

    include Gamefic::Standard

    seed do
      @living_room = make Room, name: 'living room', description: 'This is your living room.'
      @bedroom = make Room, name: 'bedroom', description: 'This is your bedroom.'
      connect @living_room, @bedroom, 'north'
      @backpack = make Room, name: 'backpack', description: 'Your trusty backpack.', parent: @bedroom
      @book = make Room, name: 'book', description: 'Your favorite novel.', parent: @living_room
    end

    script do
      introduction do |actor|
        actor.parent = @living_room
        actor.tell "You're in your house."
      end
    end
  end
end
```

Enter `rake ruby:run` to test the game. Now that it has rooms and objects, you
can perform in-game commands like `LOOK AROUND`, `GO NORTH`, and `TAKE THE BACKPACK`.

### Making Games for the Web

The default game project includes tasks for building "web" apps using HTML,
CSS, and JavaScript. Generate the code for a web build with the following
command:

```
$ rake web:generate
```

Test the game in a browser by starting a server:

```
$ rake web:run
```

Open `http://localhost:9000` to run the game in debug mode.

Build a standalone web game:

```
$ rake web:build
```

The game's HTML file and related assets will be generated in the
`web/build` directory. The SDK uses [Opal](https://github.com/opal/opal)
to compile Ruby code to JavaScript, so the web build does not require a
Ruby interpreter. Open `index.html` in a browser to play the game.

Note: building the web app requires [Node.js](https://nodejs.org).

### Example Projects

The gamefic-sdk repo includes several example projects that provide more
complete demonstrations of Gamefic's features. To run an example, copy
its `plot.rb` file to your own project.

### Learning More

Go to the [Gamefic website](https://gamefic.com) for more information about
developing and building apps with Gamefic.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/castwide/gamefic-sdk.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
