# frozen_string_literal: true

require "rails_helper"

RSpec.describe ToyType, type: :model do
  it { should have_many( :toys ) }
end
