class CreateHeadings < ActiveRecord::Migration[6.0]
  def change
    create_table :headings do |t|
      t.integer :member_id
      t.text :content

      t.timestamps
    end
  end
end
