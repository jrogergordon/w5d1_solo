require "byebug"
class MaxIntSet
  def initialize(max)
    @store = Array.new(max) {false}
  end

  def insert(num)
    raise "Out of bounds" if num > @store.length - 1 || num < 0
    @store[num] = true
  end

  def remove(num)
    @store[num] = false
  end

  def include?(num)
    @store[num]
  end

  attr_reader :store

  private

  def is_valid?(num)
  end

  def validate!(num)
  end
end


class IntSet
  def initialize(num_buckets = 20)
    @store = Array.new(num_buckets) { Array.new }
    @num_buckets = num_buckets
  end

  def insert(num)
    i = num % num_buckets
    @store[i] << num
  end

  def remove(num)
    i = num % num_buckets
    j = @store[i].delete(num)
  end

  def include?(num)
    i = num % num_buckets
    @store[i].each do |ele|
      return true if num == ele
    end
    false
  end

  private
  attr_reader :store, :num_buckets

  def [](num)
    i = num % num_buckets
    @store[i]
    # optional but useful; return the bucket corresponding to `num`
  end

  def num_buckets
    @store.length
  end
end

class ResizingIntSet
  attr_reader :store, :num_buckets, :count
  attr_writer :num_buckets, :store, :count

  def initialize(num_buckets = 20)
    @store = Array.new(num_buckets) { Array.new }
    @count = 0
    @num_buckets = num_buckets
  end

  def change_count(num)
    @count += num
  end

  def insert(num)
    if @count + 1 == @num_buckets
      resize!
    end
    i = num % @num_buckets
    if !@store[i].include?(num)
      @store[i] << num
      change_count(1)
    end
  end

  def remove(num)
    i = num % num_buckets
    if @store[i].include?(num)
      @store[i] -= [num]
      change_count(-1)
    end
    return
  end

  def include?(num)
    i = num % num_buckets
    return true if @store[i].include?(num)
    false
  end

  private

  def [](num)
    # optional but useful; return the bucket corresponding to `num`
  end

  def num_buckets
    @store.length
  end

  def resize!
    # puts "above"
    # debugger
    # puts "below"
    @count = 0
    store_2 = @store
    @num_buckets *= 2
    @store = Array.new(@num_buckets) { Array.new }
    store_2.each_with_index do |ele, idx|
      ele.each_with_index do |ele_1, idx_1|
        @store.insert(ele_1)
      end
    end
  end
end
