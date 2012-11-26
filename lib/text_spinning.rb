require 'strscan'

class Array

  # Generate all permutations each elements of N arrays. _a_ must be an array
  # of arrays of strings. It returns an array of all possible permutation
  # string.
  #
  # Examples:
  #   [['1'],['1','2']].permutations            #=> ["11", "12"]
  #   [['1','2'],['1','2']].permutations        #=> ["11", "12", "21", "22"]
  def permutations
    # FIXME(Nicolas Despres): See if we could use the built-in
    # Array.permutation here.
    return [] if self.empty?
    x = self.first
    y = self[1..self.size-1].permutations
    return y if x.empty?
    return x if y.empty?
    r = []
    x.each do |i|
      y.each do |j|
        r << i + j
      end
    end
    r
  end

end # class Array

class TextSpinning

  def _add_text(tree, str)
    tree << str unless str.empty?
  end
  private :_add_text

  def _parse_curly_brackets(ss)
    tree = []
    str = ''
    until ss.eos?
      c = ss.scan(/./)
      if c == '{'
        _add_text(tree, str)
        tree << _parse_curly_brackets(ss)
        str = ''
      elsif c == '|'
        _add_text(tree, str)
        str = ''
      elsif c == '}'
        _add_text(tree, str)
        str = ''
        return tree
      else
        str << c
      end
    end
    raise "non-terminated words set"
  end
  private :_parse_curly_brackets

  # Parse a spinning text for {|} element and return an tree of arrays and
  # strings.
  def parse(text)
    ss = StringScanner.new(text)
    tree = []
    str = ''
    until ss.eos?
      c = ss.scan(/./)
      if c == '{'
        _add_text(tree, str)
        tree << _parse_curly_brackets(ss)
        str = ''
      elsif c == "|" || c == "}"
        raise "unexpected '#{c}' at #{ss.pos}"
      else
        str << c
      end
    end
    _add_text(tree, str)
    tree
  end

  # Return all versions from the given spinning _tree_. See _parse_.
  #
  # Examples:
  #   ts = TextSpinning.new
  #   ts.versions(["A", ["b", "c"], "d", ["e", ["f", "g"]], "Z"])
  #     #=> ["AbdefZ", "AbdegZ", "AcdefZ", "AcdegZ"]
  def versions(tree)
    if tree.class == Array
      has_child_array = false
      r = []
      tree.each do |x|
        has_child_array = true if x.class == Array
        r << versions(x)
      end
      if has_child_array
        r.permutations
      else
        r.flatten
      end
    elsif tree.class == String
      return [tree]
    else
      raise "unexpected tree element type #{x.class}"
    end
  end

end # class TextSpinning
