class RemoveTokenFromUser < ActiveRecord::Migration[5.1]
  def up
    remove_column :users, :token
  end

  def down
    add_column :users, :token
    add_index :users, :token
  end
end
