class  DailyForecast < ApplicationModel
  attribute :date, :date

  # TODO: Extract into a concern
  attribute :temperature, :integer
  attribute :feels_like, :integer
  attribute :high, :integer
  attribute :low, :integer
end
