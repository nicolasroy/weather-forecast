module ApplicationHelper
  def kelvin_to_f(kelvin, precision: 0)
    ((kelvin - 273.15) * 9 / 5 + 32).round(precision)
  end

  def kelvin_to_c(kelvin, precision: 0)
    (kelvin - 273.15).round(precision)
  end
end
