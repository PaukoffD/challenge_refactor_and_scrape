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

FactoryGirl.define do
  factory :delivery_company do
    sequence(:name) {|n| "DeliveryCompany ##{n}" }
    sequence(:url) {|n| "http://example#{n}.com/"}
    sequence(:form_name) {|n| "DeliveryCompany_Form#{n}" }
    form_action ""
    sequence(:field_name) {|n| "DeliveryCompany_Field#{n}" }
    extra_fields ""
    extra_values ""
    sequence(:submit) {|n| "submit#{n}"}
    sequence(:xpath) {|n| "//patrh/to/content#{n}"}
    css 'color: blue'
  end
end
