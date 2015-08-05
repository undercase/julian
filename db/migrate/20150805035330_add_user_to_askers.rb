class AddUserToAskers < ActiveRecord::Migration
  def change
    add_reference :askers, :user, index: true, foreign_key: true
  end
end
