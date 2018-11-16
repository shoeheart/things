# frozen_string_literal: true

require "rails_helper"

RSpec.describe Person, type: :model do
  it "saves a person" do
    person = nil
    Logidze.with_meta(responsible_id: "test@codebarn.com") {
      person = create(:person)
      person.save!
    }
    expect(person.first_name).to match(/first_\d+/)
    expect(person.last_name).to match(/last_\d+/)
    expect(person.id).to be > 0
  end

  it { should have_many( :animal_adoptions ) }
  it { should have_many( :animals ).through( :animal_adoptions ) }
end
