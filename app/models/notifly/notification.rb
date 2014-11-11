module Notifly
  class Notification < ActiveRecord::Base
    paginates_per 10

    belongs_to :target, polymorphic: true
    belongs_to :sender, polymorphic: true
    belongs_to :receiver, polymorphic: true

    before_validation :convert_data

    scope :all_from,    ->(receiver) { where(receiver: receiver) }
    scope :unread_from, ->(receiver) { where(receiver: receiver, read: false) }

    validates :receiver, :template, presence: true

    def data
      YAML.load(read_attribute(:data))
    end

    private
      def convert_data
        self.data = read_attribute(:data).to_json
      end
  end
end