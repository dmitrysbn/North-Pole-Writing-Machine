require 'erb'

kids_data   = File.read('data/kids-data.txt')
invoice_letter = File.read('templates/invoice_letter_template.txt.erb')

kids_data.each_line do |kid|

  kid_data_array = kid.split

  name     = kid_data_array[0]
  behavior = kid_data_array[1]
  toys     = kid_data_array[2..7]
  street_number = kid_data_array[8]
  street_name = kid_data_array[9]
  street_suffix = kid_data_array[10] + '.'
  postal_code = kid_data_array[11]
  house_value = kid_data_array[12].to_i

  if house_value >= 1_000_000
    toy_price = 1_000

  elsif house_value >= 200_000 && house_value < 1_000_000
    toy_price = 100

  else
    toy_price = 0
  end

  if behavior == 'naughty'
    subtotal = toy_price

  elsif toys.include?('Kaleidoscope')
    subtotal = toy_price * 5

  else
    subtotal = toy_price * 6
  end

  tax = (subtotal * 0.13).round
  total = subtotal + tax

  unless house_value < 200_000

    filename    = 'letters/invoices/' + name + '.txt'
    letter_text = ERB.new(invoice_letter, nil, '-').result(binding)

    puts "Writing #{filename}."
    File.write(filename, letter_text)

  end

end

puts 'Done!'
