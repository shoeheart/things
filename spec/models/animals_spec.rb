# frozen_string_literal: true

require "rails_helper"

RSpec.describe Animal, type: :model do
  it "saves an animal" do
    animal = nil
    Logidze.with_meta(responsible_id: "test@codebarn.com") {
      animal = create(:animal)
      animal.save!
    }
    expect(animal.name).to match(/animal_\d+/)
    expect(animal.id).to be > 0
  end

  it { should have_one( :animal_adoption ) }
  it { should have_one( :person ).through( :animal_adoption ) }
  it { should belong_to( :species ) }
  it { should have_many( :toys ) }
end
