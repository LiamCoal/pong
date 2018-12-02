
class WordWrapper
  def slowsay(text, nline = false, spd = 0.05)
    text.chars.each do |char|
      print char
      sleep spd
    end
    if nline
      puts
    end
  end
end
