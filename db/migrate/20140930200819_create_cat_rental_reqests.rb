class CreateCatRentalReqests < ActiveRecord::Migration
  def change
    create_table :cat_rental_reqests do |t|
      t.integer :cat_id, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.string :status, null: false, default: "PENDING"

      t.timestamps
    end

    add_index :cat_rental_reqests, :cat_id
  end
end
