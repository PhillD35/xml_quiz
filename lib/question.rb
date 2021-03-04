class Question
  attr_reader :right_answer, :points, :time

  def self.from_node(node)
    right_answer = nil
    points = node.attributes['points'].to_i
    time = node.attributes['time'].to_i
    text = node.elements.find('text').first.text.strip

    answers = []

    node.elements.each('answers/answer') do |answer|
      answer_text = answer.text.strip

      if answer.attributes['right_answer']
        right_answer = answer_text
      end

      answers << answer_text
    end

    self.new(
      answers: answers.shuffle,
      right_answer: right_answer,
      points: points.to_i,
      text: text,
      time: time.to_i
    )
  end

  def initialize(answers:, points:, right_answer:, text:, time:)
    @answers = answers
    @right_answer = right_answer
    @points = points
    @text = text
    @time = time
  end

  def right_answer_index
    @answers.index(@right_answer)
  end

  def right_answer?(answer_index)
    right_answer_index == answer_index - 1
  end

  def to_s
    "#{@text}\n\n" +
    @answers.map.with_index(1) { |answer, index| "#{index}. #{answer}" }
      .join("\n")
  end
end
