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

  # Loads the page from +url+, finds the form, fills the field named +field_name+,
  # submits the form via button +submit+, and returns the fragment at +xpath+ of
  # the answer.
  def pull(query)
    return {blank_query: query.to_s} unless query.present?
    query = query.split(/(,| )\s*/)
    page = agent.get URI url
    return {not_a_page_at_url: [url, page]} unless page.is_a? Mechanize::Page
    form = page.forms.find do |form|
      if form_name.present?
        form.name == form_name
      else
        form.action == form_action
      end
    end or return {no_form: url}
    field = form.fields.find do |field|
      field.name == field_name
    end or return {no_field: field_name}
    # here we can loop to get multiple requests an once ;-)
    field.value = query.first
    button = form.submits.find do |button|
      button.name == submit
    end
    logger.debug "DeliveryCompany@#{__LINE__}#pull #{button.inspect}" if logger.debug?
    result = form.submit button
    return {not_a_page: [button.try(:name), result]} unless result.is_a? Mechanize::Page
    result = result.xpath xpath
    return {no_xpath: xpath} if result.blank?
    result.to_html
  end   # pull

  private

  # Initializes and returns Mechanize agent
  def agent
    @agent and return @agent
    @agent = Mechanize.new
    @agent.log = logger if logger.debug?
    @agent
  end
end
