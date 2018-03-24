require 'rails_helper'

RSpec.describe Person, type: :model do
  it "saves a person" do
    person = create( :person )
    person.save!
    expect( person.first_name ).to match( /first_\d+/ )
    expect( person.last_name ).to match( /last_\d+/ )
    expect( person.id ).to be > 0
    # puts person.class
    # puts person.attributes
    # puts person.instance_variables
    # puts person.first_name
    # puts person.last_name
  end
end
