class CreateAskers < ActiveRecord::Migration
  def change
    create_table :askers do |t|
      t.string :number, null: false
      t.string :question, null: true
      t.boolean :ready, null: false, default: false
      t.boolean :claimed, null: false, default: false

      t.boolean :answered, null: false, default: false

      t.timestamps null: false
    end
  end
end
