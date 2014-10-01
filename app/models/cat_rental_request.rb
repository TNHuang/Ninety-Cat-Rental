class CatRentalRequest < ActiveRecord::Base
  STATUS = ["PENDING", "DENIED", "APPROVED"]

  validates :cat_id, :start_date, :end_date, :status, presence: true
  validates_inclusion_of :status, in: STATUS
  # validate :overlapping_approved_requests

  # after_initialize :set_initial_pending

  belongs_to :cat,
    class_name: "Cat",
    foreign_key: :cat_id,
    primary_key: :id
    #
    def approve!
      unless self.has_conflict?
        self.update(status: "APPROVED")
      else
        #try to implement a flash msg to show there is a conflict
        errors[:base] << "Cannot approved overlapping request"
      end
    end

    def deny!
      self.update(status: "DENIED")
    end

    def has_conflict?
      overlap_sql = <<-SQL
        SELECT
          *
        FROM
          cat_rental_requests
        WHERE
          id != ?
          AND
           status = 'APPROVED'
          AND
          NOT (? > end_date OR start_date > ?)
      SQL
      overlaps = CatRentalRequest.find_by_sql(
          [overlap_sql, self.id, self.start_date, self.end_date])

      !overlaps.empty?
    end

  # def overlapping_requests
  #   overlap_sql = <<-SQL
  #   SELECT
  #     *
  #   FROM
  #     cat_rental_requests as a1
  #   JOIN
  #     cat_rental_requests as b1
  #     ON
  #       a1.cat_id = b1.cat_id
  #   WHERE
  #     a1.id != b1.id
  #     AND
  #      b1.status = 'APPROVED'
  #     AND
  #       NOT (a1.start_date > b1.end_date OR b1.start_date > a1.end_date)
  #   SQL
  #   overlaps = CatRentalRequest.find_by_sql([overlap_sql])
  # end



  private
  def overlapping_approved_requests
    return if overlapping_requests.empty?

    overlap_req = overlapping_requests.where('a1.status = "APPROVED" AND b1.status = "APPROVED"')
    unless overlap_req.empty?
      errors[:base] << "Cannot approved overlapping request"
    end
  end
  #redundant because database setup already set a default pending value
  # def set_initial_pending
  #   self.status ||= "PENDING"
  # end
end

