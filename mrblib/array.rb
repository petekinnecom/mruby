##
# Array
#
# ISO 15.2.12
class Array
  ##
  # call-seq:
  #   array.each {|element| ... } -> self
  #   array.each -> Enumerator
  #
  # Calls the given block for each element of +self+
  # and pass the respective element.
  #
  # ISO 15.2.12.5.10
  def each(&block)
    return to_enum :each unless block

    idx = 0
    while idx < length
      block.call(self[idx])
      idx += 1
    end
    self
  end

  ##
  # call-seq:
  #   array.each_index {|index| ... } -> self
  #   array.each_index -> Enumerator
  #
  # Calls the given block for each element of +self+
  # and pass the index of the respective element.
  #
  # ISO 15.2.12.5.11
  def each_index(&block)
    return to_enum :each_index unless block

    idx = 0
    while idx < length
      block.call(idx)
      idx += 1
    end
    self
  end

  ##
  # call-seq:
  #   array.collect! {|element| ... } -> self
  #   array.collect! -> new_enumerator
  #
  # Calls the given block for each element of +self+
  # and pass the respective element. Each element will
  # be replaced by the resulting values.
  #
  # ISO 15.2.12.5.7
  def collect!(&block)
    return to_enum :collect! unless block

    idx = 0
    len = size
    while idx < len
      self[idx] = block.call(self[idx])
      idx += 1
    end
    self
  end

  ##
  # call-seq:
  #   array.map! {|element| ... } -> self
  #   array.map! -> new_enumerator
  #
  # Alias for collect!
  #
  # ISO 15.2.12.5.20
  alias map! collect!

  ##
  # call-seq:
  #   array <=> other_array -> -1, 0, or 1
  #
  #  Comparison---Returns an integer (-1, 0, or +1)
  #  if this array is less than, equal to, or greater than <i>other_ary</i>.
  #  Each object in each array is compared (using <=>). If any value isn't
  #  equal, then that inequality is the return value. If all the
  #  values found are equal, then the return is based on a
  #  comparison of the array lengths. Thus, two arrays are
  #  "equal" according to <code>Array#<=></code> if and only if they have
  #  the same length and the value of each element is equal to the
  #  value of the corresponding element in the other array.
  #
  def <=>(other)
    other = self.__ary_cmp(other)
    return 0 if 0 == other
    return nil if nil == other

    len = self.size
    n = other.size
    len = n if len > n
    i = 0
    begin
      while i < len
        n = (self[i] <=> other[i])
        return n if n.nil? || n != 0
        i += 1
      end
    rescue NoMethodError
      return nil
    end
    len = self.size - other.size
    if len == 0
      0
    elsif len > 0
      1
    else
      -1
    end
  end

  ##
  # call-seq:
  #   array.delete(obj) -> deleted_object
  #   array.delete(obj) {|nosuch| ... } -> deleted_object or block_return
  #
  # Delete element with index +key+
  def delete(key, &block)
    len = self.length
    ret = self.__delete(key)
    return block&.call(key) if len == self.length

    ret
  end

  ##
  # call-seq:
  #   array.sort -> new_array
  #   array.sort {|a, b| ... } -> new_array
  #
  # Returns a new Array whose elements are those from +self+, sorted.
  def sort(&block)
    self.dup.sort!(&block)
  end

  ##
  # call-seq:
  #   array.to_a -> self
  #
  # Returns self, no need to convert.
  def to_a
    self
  end
  alias entries to_a

  ##
  # Array is enumerable
  # ISO 15.2.12.3
  include Enumerable
end
