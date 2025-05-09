class CurrentCondition < ApplicationModel
  attribute :zip_code, :string

  attribute :temperature, :integer
  attribute :feels_like, :integer
  attribute :high, :integer
  attribute :low, :integer
end
