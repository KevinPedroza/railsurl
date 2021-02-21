require 'singleton'

class MinifyUrlService
  include Singleton

  CHARACTERS = [*'0'..'9', *'a'..'z', *'A'..'Z'].freeze

  def url_encode(i)
    return CHARACTERS[0] if i == 0

    str = ''
    base = CHARACTERS.length

    while i > 0
      str << CHARACTERS[i.modulo(base)]
      i /= base
    end

    str.reverse
  end

  def url_decode(str)
    i = 0
    base = CHARACTERS.length
    str.each_char { |c| i = i * base + CHARACTERS.index(c) }
    i
  end
end