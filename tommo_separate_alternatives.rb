#!/usr/bin/env ruby -wU

begin
  def parse(alts, info)
#    p alts # T,A            # debug
#    p info # AC=1,3;AN=7104 # debug
    array = []
    case alts
    when /,/ # tri-allelic, tetra-allelic # C,A,T; AC=700,1094,1;AN=6990; AF=0.1001,0.1565,0.0001
      case info
      when /AC=/
        ac, an = info.split(/;/)
        ac.sub(/AC=/, '').split(/,/).each do |alt_ac|
          array << "AC=#{alt_ac};#{an}"
        end
      when /AF=/
        af = info
        af.sub(/AF=/, '').split(/,/).each do |alt_af|
          array << "AF=#{alt_af}"
        end
      end
    else # bi-allelic
      array << info
    end
    return array
  end

  def run()
    io = File.open(ARGV.shift)
    io.each do |line|
      line.chomp!
      chr, left, right, ref, alts, info = line.split(/\t/)

      array = parse(alts, info)

      alts.split(/,/).each_with_index do |alt, ind|
        puts [chr, left, right, ref, alt, array[ind]].join("\t")
      end
    end
    io.close 
  end

  if __FILE__ == $0
    run()
  end

rescue Exception => e
  p e
end

# refs.
#1 19878618  19878618  C T,A # tri-allelic
#1  26815020  26815020  G C,A,T # bi-allelic