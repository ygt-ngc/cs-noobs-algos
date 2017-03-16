require 'benchmark'
require 'pry'

def insertion_sort(array)
  array = array.dup

  1.upto(array.length - 1) do |index|
    value_to_insert = array.delete_at(index)

    insertion_index = index
    while insertion_index > 0 && value_to_insert < array[insertion_index - 1]
      insertion_index -= 1
    end

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

def make_array(size, variant = nil)
  @array ||= {}

  case variant
  when :ascending
    @array[variant] ||= {}
    @array[variant][size] ||= 1.upto(size).to_a.freeze
  when :descending
    @array[variant] ||= {}
    @array[variant][size] ||= size.downto(1).to_a.freeze
  when :repeated
    @array[variant] ||= {}
    @array[variant][size] ||= 1.upto(size).to_a.map { 42 }.freeze
  when :shuffled
    @array[variant] ||= {}
    @array[variant][size] ||= 1.upto(size).to_a.shuffle.freeze
  else
    @array[:random] ||= {}
    @array[:random][size] ||= 1.upto(size).to_a.map { rand(size) }.freeze
  end
end

def make_default_arrays
  [100, 500, 1000, 2000, 4000, 8000, 16000, 32000, 100000, 500000].map { |size| [size, make_array(size)] }
end

def sort_with(algo, array = nil)
  if !array
    arrays = make_default_arrays
  else
    arrays = [[array.length, array]]
  end

  arrays.each do |(size, array)|
    t = Thread.new do
      print "sorting array of #{size} items using #{algo}... ";
      time = Benchmark.realtime do
        method(algo).call(array.dup)
      end

      print "done in #{time} seconds!\n"
    end

    Thread.new do
      sleep 30
      if t.status == "run"
        print "didn't finish within 30 seconds!\n"
        t.kill
      end
    end

    t.join
  end

  :done
end
