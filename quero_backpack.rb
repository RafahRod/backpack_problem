class BackPackProblem
  def run
    loop do
      puts "-----------------------------------------------------"
      puts "Estágio em SRE e Backend-Elixir - Problema da Mochila"
      puts "-----------------------------------------------------"

      items = get_backpack_items
      max_weight = get_max_weight

      recommended_items, bag_value = calculate_backpack_value(items, max_weight)

      puts "\nResultado:\nItems selecionados: #{recommended_items} \nValor total: #{bag_value}"
      puts "\nDeseja resolver outro problema? (Digite 'sim' para continuar ou qualquer outra coisa para sair)"
      answer = gets.chomp.downcase
      break unless answer == 'sim'
      system ("cls") #windows
      system ("clear")#linux
    end

    puts "Obrigado por usar o programa!"
  end

  def get_backpack_items
    items = []
    puts "\nDigite os itens no formato [(peso, valor)], que deseja levar em sua mochila. Exemplo: [(3, 7), (2, 10)]...:"
    input = gets.chomp

    if input.strip.match(/\A\[\((\d+),\s*(\d+)\)(,\s*\((\d+),\s*(\d+)\))*\]\z/)
      items = input.scan(/\((\d+),\s*(\d+)\)|\[\((\d+),\s*(\d+)\)\]/).map { |match| match.compact.map(&:to_i) }
    else
      puts "\nEntrada inválida. Certifique-se de digitar os itens no formato correto."
      return get_backpack_items
    end

    items
  end

  def get_max_weight
    puts "\nDigite a capacidade máxima de sua mochila: "
    max_weight = gets.chomp.to_i
      
    if max_weight <= 0
      puts "\nA capacidade máxima deve ser maior que zero."
      return get_max_weight
    end
  
    max_weight
  end

  def calculate_maximum_values(items, max_weight)
    items_count = items.length
    maximum_values = Array.new(items_count + 1) { Array.new(max_weight + 1, 0) }
    
    items.each_with_index do |(weight, value), item_index|
      (1..max_weight).each do |current_capacity|
        without_current_item = maximum_values[item_index][current_capacity]
        if weight <= current_capacity
          with_current_item = maximum_values[item_index][current_capacity - weight] + value
          maximum_values[item_index + 1][current_capacity] = [without_current_item, with_current_item].max
        else
          maximum_values[item_index + 1][current_capacity] = without_current_item
        end
      end
    end
    
    maximum_values
  end

  def find_recommended_items(items, maximum_values, items_count, max_weight)
    recommended_items = []
    bag_value = maximum_values[items_count][max_weight]
    
  item_index, current_capacity = items_count, max_weight
  while item_index > 0 && current_capacity > 0
    if maximum_values[item_index][current_capacity] != maximum_values[item_index - 1][current_capacity]
      recommended_items.unshift(items[item_index - 1])
      current_capacity -= items[item_index - 1][0]
    end
    item_index -= 1
  end

  [recommended_items, bag_value]
  end

  def calculate_backpack_value(items, max_weight)
    items_count = items.length
    maximum_values = calculate_maximum_values(items, max_weight)
    recommended_items, bag_value = find_recommended_items(items, maximum_values, items_count, max_weight)
    [recommended_items, bag_value]
  end
end

class BackPackProblemTest
  # [
  #   [itens, capacidade máxima],
  # ]
  @@inputs = [
    [[[1,1], [2,6], [5,18], [6,22], [7,28], [9,40], [11,60]], 23],
    [[[1,1], [2,6], [5,18], [6,22]], 10],
    [[[2, 10], [3, 7], [4, 13], [5, 17]], 10],
  ]
  # [
  #   [Itens recomendados esperados, Peso esperado da mochila],
  # ]
  @@expected_results = [
    [[[1, 1], [2, 6], [9, 40], [11, 60]], 107],
    [[[1, 1], [2, 6], [6, 22]], 29],
    [[[2, 10], [3, 7], [5, 17]], 34],
  ]
  def run()
    @@inputs.each_with_index do |(items, max_weight), index|
      puts "\nItens testados: #{items}, Capacidade: #{max_weight}\n"
      recommended_items, bag_value = BackPackProblem.new.calculate_backpack_value(items, max_weight)
      
      equal_items = recommended_items == @@expected_results[index][0]
      equal_weigth = bag_value == @@expected_results[index][1]
      
      puts "Itens recomendados esperados #{@@expected_results[index][0]}: #{get_result(equal_items)}"
      puts "Peso esperado da mochila #{@@expected_results[index][1]}: #{get_result(equal_weigth)}\n\n"
      
    end
  end
  
  def get_result(result)
    result ? "\e[32m#{result}\e[0m" : "\e[31m#{result}\e[0m"
  end
end

ARGV[0] == "teste" ? BackPackProblemTest.new.run : BackPackProblem.new.run