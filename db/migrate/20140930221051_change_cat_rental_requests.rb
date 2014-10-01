class ChangeCatRentalRequests < ActiveRecord::Migration
  def change
    rename_table :cat_rental_reqests, :cat_rental_requests
  end
end
