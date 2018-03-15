require 'rails_helper'

RSpec.describe Animal, type: :model do
  it "saves an animal" do
    animal = create( :animal )
    animal.save!
    expect( animal.name ).to match( /animal_\d+/ )
    expect( animal.id).to be > 0
  end
end
