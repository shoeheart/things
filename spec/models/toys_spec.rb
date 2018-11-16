# frozen_string_literal: true

require "rails_helper"

RSpec.describe Toy, type: :model do
  it { should belong_to( :animal ) }
  it { should belong_to( :toy_type ) }
  it { should validate_presence_of( :acquired_on ) }
end
