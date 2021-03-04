class Quiz
  SCORE_WORD_FORMS = %w[балл балла баллов]
  QUESTION_WORD_FORMS = %w[вопрос вопроса вопросов]

  def self.questions_from_xml(path)
    xml_file = File.read(path)
    xml_doc = REXML::Document.new(xml_file)

    questions = []

    xml_doc.elements.each('questions/question') do |node|
      questions << Question.from_node(node)
    end

    self.new(questions.shuffle)
  end

  def initialize(questions)
    @questions = questions
    @checkpoint = nil
    @score = 0
    @right_answers = 0
  end

  def begin(&block)
    @questions.each(&block)
  end

  def checkpoint
    @checkpoint = Time.now
  end

  def greetings
    "У нас для Вас есть #{@questions.size} " \
    "#{case_adjuster(@questions.size, *QUESTION_WORD_FORMS)}" \
    ". Удачи!"
  end

  def process_answer(question:, answer:)
    return 'Время истекло.' if time_out?(question)

    if question.right_answer?(answer)
      @score += question.points
      @right_answers += 1

      "Верный ответ!"
    else
      "Неверно. Правильный ответ: #{question.right_answer}"
    end
  end

  def time_out?(question)
    Time.now - @checkpoint > question.time
  end

  def result
    <<~HEREDOC
    Правильных ответов: #{@right_answers} из #{@questions.size}
    Вы набрали #{@score} #{case_adjuster(@score, *SCORE_WORD_FORMS)}
    HEREDOC
  end

  private

  def case_adjuster(number, one, few, many)
    return many if (11..14).include?(number % 100)

    case number % 10
    when 1 then one
    when 2..4 then few
    else many
    end
  end
end
