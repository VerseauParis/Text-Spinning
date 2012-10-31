# -*- coding: utf-8 -*-
require 'test/unit'
$: << File.expand_path(File.dirname(__FILE__) + '/../lib')
require 'text_spinning'

class TestArray < Test::Unit::TestCase

  def test_permutations
    assert_equal ['11','12'], [['1'],
                 ['1','2']].permutations
    assert_equal ['11','12','21','22'],
                 [['1','2'],['1','2']].permutations
    assert_equal ['111','112','121','122','131','132'],
                 [['1',],['1','2','3'],['1','2']].permutations
  end

end # class TestArray

class TextSpinningTest < Test::Unit::TestCase

  def setup
    @text_spinning = TextSpinning.new
  end

  def test_parse
    assert_equal ["a",["b","c"]], @text_spinning.parse("a{b|c}")
    assert_equal ["a",["b",["c"]]], @text_spinning.parse("a{b|{c}}")
    assert_equal [["a","b","c"]], @text_spinning.parse("{a|b|c}")
    assert_equal ["a",["b","c"],"d"], @text_spinning.parse("a{b|c}d")
    assert_equal ["a",["b","c"],"d",["e",["f","g"]],"z"],
                 @text_spinning.parse("a{b|c}d{e|{f|g}}z")
    assert_raise(RuntimeError) { @text_spinning.parse("a}b") }
    assert_raise(RuntimeError) { @text_spinning.parse("a{b") }
    assert_raise(RuntimeError) { @text_spinning.parse("a|b") }
    assert_equal [["sélectionné une large choix de"]],
                 @text_spinning.parse("{sélectionné une large choix de}")
  end

  def test_versions
    assert_equal ["ab","ac"], @text_spinning.versions(["a",["b","c"]])
    assert_equal ["acd","ace","bcd","bce"],
                 @text_spinning.versions([["a","b"],["c",["d","e"]]])
    assert_equal ["abdefz", "abdegz", "acdefz", "acdegz"],
                 @text_spinning.versions(["a",["b","c"],"d",["e",["f","g"]],"z"])
  end

end # class TextSpinningTest
