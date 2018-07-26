# frozen_string_literal: true

module SoftDelete
  # takes instance methods of what i'm extending
  # and they become class method of self. on then
  # module we're defining
  extend ActiveSupport::Concern

  included do
    # any class that includes this module
    # will have the following added to it
    def destroy
      # instead of deleting a row, set the is_deleted instead
      update_attributes(is_deleted: true)
    end

    def delete
      # instead of deleting a row, set the is_deleted instead
      update_attributes(is_deleted: true)
    end

    # TODO: how to actually raise the postgres delete trigger
    #       so its seen by ActiveRecord
    # TODO: responsible party isn't being set right in logdize trigger
    def self.delete_all
      update_all(is_deleted: true)
    end

    def self.destroy_all
      update_all(is_deleted: true)
    end

    scope :deleted, -> { where(is_deleted: true) }
    scope :not_deleted, -> { where(is_deleted: false) }
    default_scope { not_deleted }
  end
end
