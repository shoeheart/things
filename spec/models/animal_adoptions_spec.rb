# frozen_string_literal: true

require "rails_helper"

RSpec.describe AnimalAdoption, type: :model do
  it { should belong_to( :animal ) }
  it { should belong_to( :person ) }
end
