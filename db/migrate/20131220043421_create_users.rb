class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email, unique: true, index: true
      t.string :token, unique: true, index: true
      t.string :password_digest
      t.string :password_salt
      t.timestamps
    end
  end
end
