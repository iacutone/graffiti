class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
    	t.string :created_date
    	t.string :closed_date
    	t.string :resolution_action
    	t.string :status
    	t.string :incident_address_display
    	t.string :borough
    	t.string :x_coordinate
    	t.string :y_coordinate

      t.timestamps
    end
  end
end
