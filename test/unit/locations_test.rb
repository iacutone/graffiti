# == Schema Information
#
# Table name: locations
#
#  id                       :integer          not null, primary key
#  created_date             :string(255)
#  closed_date              :string(255)
#  resolution_action        :string(255)
#  status                   :string(255)
#  incident_address_display :string(255)
#  borough                  :string(255)
#  x_coordinate             :string(255)
#  y_coordinate             :string(255)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

require 'test_helper'

class LocationsTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
