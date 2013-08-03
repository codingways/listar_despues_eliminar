require_relative 'atributo'
require_relative 'ejemplo'
require_relative 'hipotesis'
require 'benchmark'

class ListarDespuesEliminar
  attr_accessor :atributos, :ejemplos

  def initialize(atributos, ejemplos)
    @atributos, @ejemplos = atributos, ejemplos
  end

  def run
    espacio_versiones = []

    @atributos.each do |atributo|
      atributo.instancias.push "?", "0"
    end
    
    # Construir espacio de versiones (Todas las combinaciones entre instancias de atributos)
    @atributos[0].instancias.each do |attr1|
      @atributos[1].instancias.each do |attr2|
        @atributos[2].instancias.each do |attr3|
          @atributos[3].instancias.each do |attr4|
            @atributos[4].instancias.each do |attr5|
              @atributos[5].instancias.each do |attr6|
                espacio_versiones << Hipotesis.new([attr1, attr2, attr3, attr4, attr5, attr6])
              end
            end
          end  
        end
      end
    end

    # Eliminar hipotesis no consistentes con alguno de los ejemplos
    ejemplos.each do |ejemplo|
      espacio_versiones.select! { |hipotesis| hipotesis.consistente(ejemplo) }
    end

    max_generalidad = espacio_versiones.map { |hipotesis| hipotesis.generalidad }.max
    max_especificidad = espacio_versiones.map { |hipotesis| hipotesis.generalidad }.min

    espacio_versiones.select! { |hipotesis| hipotesis.generalidad == max_generalidad or hipotesis.generalidad == max_especificidad}

    espacio_versiones.map {|hipotesis| hipotesis.valores} 
  end
end

cielo = Atributo.new('cielo',["soleado","nublado","lluvioso"])
temp_aire = Atributo.new('temp_aire',["templada","fria"])
humedad = Atributo.new('humedad',["normal","alta"])
viento = Atributo.new('viento',["fuerte","debil"])
temp_agua = Atributo.new('temp_agua',["templada","fria"])
pronostico = Atributo.new('pronostico',["igual","cambia"])

ej1 = Ejemplo.new(["soleado","templada","normal","fuerte","templada","igual"], true)
ej2 = Ejemplo.new(["soleado","templada","alta","fuerte","templada","igual"], true)
ej3 = Ejemplo.new(["lluvioso","fria","alta","fuerte","templada","cambia"], false)
ej4 = Ejemplo.new(["soleado","templada","alta","fuerte","fria","cambia"], true)

lde = ListarDespuesEliminar.new([cielo,temp_aire,humedad,viento,temp_agua,pronostico], [ej1,ej2,ej3,ej4])
res = nil
Benchmark.bm do |b|
  b.report("Eliminacion del candidato:") { res = lde.run }
end
puts res.inspect