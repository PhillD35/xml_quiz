require 'rexml/document'

require_relative 'lib/question'
require_relative 'lib/quiz'

XML_PATH = File.join(__dir__, 'data/questions.xml').freeze

quiz = Quiz.questions_from_xml(XML_PATH)

puts quiz.greetings

quiz.begin do |question|
  puts question
  quiz.checkpoint

  puts
  print 'Ваш ответ: '
  input = STDIN.gets.to_i

  puts
  puts quiz.process_answer(question: question, answer: input)
  puts
end

puts quiz.result
