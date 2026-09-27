class CreateCircles < ActiveRecord::Migration[8.1]
  def change
    create_table :circles do |t|
      t.references :category, null: false, foreign_key: true
      t.string :name, null: false
      t.string :slug, null: false
      t.text :description
      t.integer :members_count, null: false, default: 0
      t.integer :position, null: false, default: 0
      t.timestamps
    end
    add_index :circles, :slug, unique: true
  end
end
