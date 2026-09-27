class CreateSubscribers < ActiveRecord::Migration[8.1]
  def change
    create_table :subscribers do |t|
      t.string :email, null: false
      t.string :source, null: false, default: "landing"

      t.timestamps
    end
    add_index :subscribers, :email, unique: true
  end
end
