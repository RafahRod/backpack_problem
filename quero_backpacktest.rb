class BackpackProblemTest

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
      recommended_items, bag_value = BackpackProblem.new.calculate_backpack_value(items, max_weight)
      
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
