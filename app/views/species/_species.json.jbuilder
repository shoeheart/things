# frozen_string_literal: true

json.extract! species, :id, :name, :name, :created_at, :updated_at
json.url species_url(species, format: :json)
