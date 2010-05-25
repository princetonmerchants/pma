module ConfigProtection
  def protected?
    key.match(/[p|P]ass[word]?/)
  end
  
  def protected_value
    if protected?
      return "********"
    else
      return value
    end
  end
end