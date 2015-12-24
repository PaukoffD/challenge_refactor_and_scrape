# == Schema Information
#
# Table name: delivery_companies
#
#  id           :integer          not null, primary key
#  name         :string           not null
#  url          :string           not null
#  form_name    :string
#  form_action  :string
#  field_name   :string           not null
#  extra_fields :string
#  extra_values :string
#  submit       :string
#  xpath        :string
#  css          :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

# Model DeliveryCompany keeps the data needed to
# process the request about delivery status.
#
class DeliveryCompany < ActiveRecord::Base

  validates :name, presence: true, uniqueness: true
  validates :url, :field_name, :submit, :xpath, presence: true
  validates :form_action, presence: {unless: :form_name?}
  validates :form_name, presence: {unless: :form_action?}
  validates :extra_values, presence: {if: :extra_fields?}
  validates_each :url do |record, attr, value|
    uri = URI value rescue nil
    if uri
      record.errors.add attr, :not_http unless uri.is_a? URI::HTTP
      record.errors.add attr, :no_host unless uri.host.present?
    else
      record.errors.add attr, :not_url
    end
    if record.errors.blank?
      uri.path = '/' if uri.path.blank?
      uri.host.downcase!
      value.sub! /.*/, uri.to_s
      if DeliveryCompany.select(1).where.not(id: record.id).find_by url: uri.to_s
        record.errors.add attr, :taken
      end
    end
  end

  scope :ordered, -> { order(:name) }

end
