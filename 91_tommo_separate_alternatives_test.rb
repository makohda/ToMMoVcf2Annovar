#!/usr/bin/env ruby

require 'minitest/autorun'

class SeparateALternativesTest < Minitest::Test
  def test_separate
    expected = "1\t19878451\t19878451\tG\tA\tAC=4;AN=7104\n1\t19878618\t19878618\tC\tT\tAC=1;AN=7104\n1\t19878618\t19878618\tC\tA\tAC=3;AN=7104\n1\t26815020\t26815020\tG\tC\tAC=700;AN=6990\n1\t26815020\t26815020\tG\tA\tAC=1094;AN=6990\n1\t26815020\t26815020\tG\tT\tAC=1;AN=6990\n1\t19878451\t19878451\tG\tA\tAF=0.0006\n1\t19878618\t19878618\tC\tT\tAF=0.0001\n1\t19878618\t19878618\tC\tA\tAF=0.0003\n1\t26815020\t26815020\tG\tC\tAF=0.1001\n1\t26815020\t26815020\tG\tA\tAF=0.1565\n1\t26815020\t26815020\tG\tT\tAF=0.0001\n"
    parsed   = `ruby 10_tommo_separate_alternatives.rb 91_t_dir/tommo.test_data.180625.txt`
    puts "Parsed data"
    puts parsed

    puts "Expected data"
    puts expected

    assert_equal parsed, expected
  end
end
