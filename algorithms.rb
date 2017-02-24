require 'benchmark'
require 'pry'

def insertion_sort(array)
  1.upto(array.length - 1) do |index|
    value_to_insert = array.delete_at(index)

    insertion_index = index
    insertion_index -= 1 while insertion_index > 0 && value_to_insert < array[insertion_index - 1]

    array.insert(insertion_index, value_to_insert)
  end

  array
end

def quicksort(array)
  if array.length <= 1
    return array
  else
    pivot   = array.delete_at(rand(array.size))
    lt, gte = array.partition { |value| pivot > value }

    quicksort(lt) + [pivot] + quicksort(gte)
  end
end

def radix_sort(array)
  nr_of_elements = array.max

  output = Array.new(nr_of_elements)

  array.each { |value| output[value] = value }

  output.compact
end

sorted   = (1..ARGV[0].to_i).to_a
shuffled = sorted.shuffle
reversed = sorted.reverse

if ARGV.include? 'insertion'
  puts
  puts "<<<< Insertion sort >>>>"
  puts

  Benchmark.bmbm do |x|
    x.report("insertion sort [sorted array]") { insertion_sort(sorted) }
    x.report("insertion sort [shuffled array]") { insertion_sort(shuffled) }
    x.report("insertion sort [reversed order array]") { insertion_sort(reversed) }
  end
end

if ARGV.include? 'quicksort'
  puts
  puts "<<<< Quick sort >>>>"
  puts

  Benchmark.bmbm do |x|
    x.report("quick sort [sorted array]") { quicksort(sorted) }
    x.report("quick sort [shuffled array]") { quicksort(shuffled) }
    x.report("quick sort [reversed order array]") { quicksort(reversed) }
  end
end

if ARGV.include? 'radix'
  puts
  puts "<<<< Radix sort >>>>"
  puts

  Benchmark.bmbm do |x|
    x.report("radix sort [sorted array]") { radix_sort(sorted) }
    x.report("radix sort [shuffled array]") { radix_sort(shuffled) }
    x.report("radix sort [reversed order array]") { radix_sort(reversed) }
  end
end
