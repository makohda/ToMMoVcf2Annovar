#!/usr/bin/env ruby

require 'minitest/autorun'

class SeparateALternativesTest < Minitest::Test
  def test_separate
    expected = "1\t19878451\t19878451\tG\tA\tAC=5;AN=9004\n1\t19878618\t19878618\tC\tT\tAC=11;AN=7104\n1\t19878618\t19878618\tC\tA\tAC=23;AN=7104\n1\t26815020\t26815020\tG\tC\tAC=800;AN=6990\n1\t26815020\t26815020\tG\tA\tAC=1194;AN=6990\n1\t26815020\t26815020\tG\tT\tAC=1;AN=6990\n1\t19878451\t19878451\tG\tA\tAF=0.0007\n1\t19878618\t19878618\tC\tT\tAF=0.0011\n1\t19878618\t19878618\tC\tA\tAF=0.0005\n1\t26815020\t26815020\tG\tC\tAF=0.1111\n1\t26815020\t26815020\tG\tA\tAF=0.1765\n1\t26815020\t26815020\tG\tT\tAF=0.0111\n"
    parsed   = `ruby tommo_separate_alternatives.rb 91_t_dir/tommo.test_data.180625.txt`

    puts "Input data"
    puts `cat 91_t_dir/tommo.test_data.180625.txt`

    puts "Parsed data"
    puts parsed

    assert_equal parsed, expected
  end
end
