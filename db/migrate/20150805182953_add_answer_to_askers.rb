class AddAnswerToAskers < ActiveRecord::Migration
  def change
    add_column :askers, :answer, :string
  end
end
