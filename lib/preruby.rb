module P
  module Bin
    extend self
    # oc = One's Complement

    # doesn't account for negative zero
    # https://en.wikipedia.org/wiki/Ones%27_complement
    def to_oc(int)
      bits = to_byte(int.abs % 128)
      int < 0 ? self.~(bits) : bits
    end

    def oc_add(a, b)
      a, b = same_lengths(a, b)
      zipped = a.split('').zip(b.split('')).map { |x, y| [x.to_i, y.to_i] }.reverse
      carry = 0
      sum = zipped.map do |x, y|
        s = x + y + carry
        carry = 0
        if s > 1
          carry = s - 1
          s = s % 2
        end
        s
      end.reverse.map(&:to_s).join('')
      return oc_add(sum, to_oc(carry)) if carry > 0
      sum
    end

    def &(a, b)
      a, b = same_lengths(a, b)
      a.split('').zip(b.split('')).map { |x, y| x == y ? x : '0' }.join('')
    end

    def ~(a)
      a.split('').map { |x| x == '1' ? '0' : '1' }.join('')
    end

    def same_lengths(a, b)
      a_ = a.rjust(b.length, '0')
      b_ = b.rjust(a.length, '0')
      return [a_, b_]
    end

    # 123 -> "01111011"
    # 257 -> "00000001"
    def to_byte(int)
      (int.to_i % 256).to_s(2).rjust(8, '0')
    end
  end
  module Net
    extend self
    def ip_to_binary(ip)
      ip.split('.').map{|x| P::Bin.to_byte(x) }.join('.')
    end
  end
end
