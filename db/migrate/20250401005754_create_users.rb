class CreateUsers < ActiveRecord::Migration[8.0]
  # extensao para postgresl apenas
  # enable_extension 'pgcrypto' if Rails.env.development? || Rails.env.production?
  
  def change

    create_table :users, id: :uuid do |t|
      t.string :name
      t.string :email
      t.string :password_digest

      t.timestamps
    end
  end
end
