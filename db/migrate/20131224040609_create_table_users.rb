class CreateTableUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :fname
      t.string :lname
      t.string :uname
      t.string :pword
      t.text   :bio

      t.timestamps
    end
  end

  def down
    drop_table :users
  end
end
