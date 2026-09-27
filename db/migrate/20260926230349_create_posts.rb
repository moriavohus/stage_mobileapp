class CreatePosts < ActiveRecord::Migration[8.1]
  def change
    create_table :posts do |t|
      t.references :category, null: false, foreign_key: true
      t.string :title, null: false
      t.string :slug, null: false
      t.string :kind, null: false, default: "article"
      t.text :summary
      t.text :body
      t.integer :duration_minutes
      t.string :cover_url
      t.string :video_url
      t.boolean :published, null: false, default: false
      t.datetime :published_at

      t.timestamps
    end
    add_index :posts, :slug, unique: true
    add_index :posts, [ :published, :published_at ]
    add_index :posts, :kind
  end
end
