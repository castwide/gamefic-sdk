# Interview with The Professor
# A Gamefic demo by Fred Snyder
#
# This game demonstrates interaction with characters. The professor has custom
# responses to questions about his name or the job opening.

require 'gamefic'
require 'gamefic-standard'

module Professor
  class Plot < Gamefic::Plot
    include Gamefic::Standard
  end
end

Professor::Plot.script do
  office = make Room, name: 'the professor\'s office',
                      description: 'A cozy room with thick carpet, rich mahogany woodwork, and lots of books.'

  # Scenery can be used to provide ambience and extra detail. It doesn't usually
  # get included in the list of visible entities in the room description, but it
  # still provides its description upon direct examination.
  carpeting = make Scenery, name: 'carpet', synonyms: 'carpeting shag',
                            description: 'Thick brown shag covers the entire floor.', parent: office
  woodwork = make Scenery, name: 'mahogany woodwork',
                           description: 'Finely crafted and varnished to a pleasant sheen.', parent: office
  books = make Scenery, name: 'books', synonyms: 'shelves bookshelves',
                        description: 'Every wall is covered with shelves full of classic literature and literary criticism.', parent: office

  introduction do |actor|
    actor.tell "A friend of yours told you there's a job available in the university's English department. A secretary gave you directions to the man you need to see."
    actor.parent = office
    actor.perform 'look'
  end

  professor = make Character, name: 'the professor', synonyms: 'Sam Worthington',
                              description: 'A gangly older gentleman with thick glasses and a jaunty bowtie.', parent: office

  block :talk_to_professor do |scene|
    scene.on_start do |_actor, props|
      props.prompt = 'What do you want to ask him about?'
    end

    scene.on_finish do |actor, props|
      actor.perform "ask professor about #{props.input}" unless props.input.empty?
    end
  end

  respond :talk, professor do |actor, _professor|
    actor.cue :talk_to_professor
  end

  respond :talk, professor, plaintext do |actor, professor, subject|
    actor.tell "#{The professor} has nothing to say about #{subject}."
  end

  respond :talk, professor, plaintext(/name/) do |actor, _professor, _subject|
    actor.tell '"Professor Sam Worthington. Pleased to meet you."'
  end

  respond :talk, professor, plaintext(/(job|opening|work|interview)/) do |actor, _professor, _subject|
    actor.conclude :asked_about_job
  end

  conclusion :asked_about_job do |actor|
    actor.tell "#{The professor} smiles. \"Ah, you're here about the job.\" He hands you an application. \"Fill this out and get back to me later.\""
  end

  meta :test, 'me' do |actor|
    actor.queue.concat [
      'look around',
      'look professor',
      'talk to professor',
      'name',
      'ask professor about job'
    ]
  end
end
