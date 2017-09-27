
class Hash
  def join(keyvaldelim=$,, entrydelim=$,)
    map {|e| e.join(keyvaldelim) }.join(entrydelim)
  end
end