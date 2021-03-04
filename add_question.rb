require 'rexml/document'

XML_PATH = File.join(__dir__, 'data/questions.xml')

XML_BLANK = <<~HEREDOC
<?xml version='1.0' encoding='UTF-8'?>
<questions>
</questions>
HEREDOC

unless File.exist?(XML_PATH)
  File.open(XML_PATH, 'w:UTF-8') { |file| file.puts XML_BLANK }
end

# Для каждого вопроса задать строку вопроса,
# варианты ответов, правильный вариант, количество баллов.
# плюс время на ответ

print 'Введите текст вопроса: '
text = STDIN.gets.chomp

puts

print 'Введите правильный вариант ответа: '
right_answer = STDIN.gets.chomp

wrong_answers = []

puts

loop do
  print 'Введите неправильный вариант ответа: '
  input = STDIN.gets.chomp

  break if input == '--exit'

  wrong_answers << input

  puts
  puts 'Если неправильных ответов больше не нужно - введите --exit'
end

puts

print 'Очков за правильный ответ: '
points = STDIN.gets.to_i

print 'Время на вопрос (в секундах): '
time = STDIN.gets.to_i

xml_file = File.read(XML_PATH, encoding: 'UTF-8')
xml_doc = REXML::Document.new(xml_file)

xml_root = xml_doc.elements.find('questions').first
question = xml_root.add_element('question', {'time' => time, 'points' => points})
question.add_element('text').text = text

answers = question.add_element('answers')
answers.add_element('answer', {'right_answer' => 'true'})
  .text = right_answer

wrong_answers.each do |wrong_answer|
  answers.add_element('answer').text = wrong_answer
end

File.open(XML_PATH, 'w:UTF-8') do |file|
  xml_doc.write(file, 2)
end

puts 'Вопрос добавлен.'
