class CreateCirclePosts < ActiveRecord::Migration[8.1]
  def change
    create_table :circle_posts do |t|
      t.references :circle, null: false, foreign_key: true
      t.string :author_nick, null: false
      t.text :body, null: false
      t.integer :supports_count, null: false, default: 0
      t.boolean :published, null: false, default: true
      t.datetime :published_at
      t.timestamps
    end
    add_index :circle_posts, [:circle_id, :published_at]
  end
end
