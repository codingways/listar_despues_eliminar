class Hipotesis
  attr_accessor :valores

  def initialize(valores)
    @valores = valores
  end

  def consistente(ejemplo)
    if ejemplo.clasificacion == true and acepta(ejemplo)
      return true
    elsif ejemplo.clasificacion == false and !acepta(ejemplo)
      return true
    end
    return false
  end

  protected

  def acepta(ejemplo)
    @valores.each_with_index do |valor, i|
      if valor != '?' and valor != ejemplo.valores[i]
        return false
      end
    end
    return true
  end
end