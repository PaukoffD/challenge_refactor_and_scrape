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

require 'rails_helper'

describe DeliveryCompany, type: :model do

  subject { create :delivery_company }

  it { should be_valid }

  it {should validate_presence_of :name}
  it {should validate_presence_of :url}
  it {should validate_presence_of :field_name}
  it {should validate_presence_of :submit}
  it {should validate_presence_of :xpath}

  it {should validate_uniqueness_of :name}

  describe '#extra_values' do
    context 'when extra_fields is present' do
      subject { build :delivery_company, extra_fields: 'some_name', extra_values: nil}

      it 'validates presence' do
        expect(subject.extra_values).to be_blank
        expect(subject).not_to be_valid
        expect(subject.errors.messages[:extra_values]).to eq ["can't be blank"]
      end
    end   # when extra_fields is present

    context 'when extra_fields is blank' do
      subject { build :delivery_company, extra_fields: '', extra_values: nil}

      it 'allows it to be blenk' do
        expect(subject.extra_values).to be_blank
        expect(subject).to be_valid
      end
    end   # when extra_fields is blank
  end   #extra_values

  describe '#form_action' do
    context 'when form_name is present' do
      subject { build :delivery_company, form_action: nil, form_name: 'some_name'}

      it 'allows it to be blenk' do
        expect(subject.form_action).to be_blank
        expect(subject).to be_valid
      end
    end   # when form_name is present

    context 'when form_name is blank' do
      subject { build :delivery_company, form_action: nil, form_name: ''}

      it 'validates presence' do
        expect(subject.form_action).to be_blank
        expect(subject).not_to be_valid
        expect(subject.errors.messages[:form_action]).to eq ["can't be blank"]
      end
    end   # when form_name is blank
  end   #form_action

   describe '#form_name' do
    context 'when form_action is present' do
      subject { build :delivery_company, form_name: nil, form_action: '/path'}

      it 'allows it to be blenk' do
        expect(subject.form_name).to be_blank
        expect(subject).to be_valid
      end
    end   # when form_name is present

    context 'when form_action is blank' do
      subject { build :delivery_company, form_name: nil, form_action: ''}

      it 'validates presence' do
        expect(subject.form_name).to be_blank
        expect(subject).not_to be_valid
        expect(subject.errors.messages[:form_name]).to eq ["can't be blank"]
      end
    end   # when form_name is blank
  end   #form_name

 describe '#url' do
    let(:url) {'Http://Google.com'}
    subject { build :delivery_company, url: url}

    describe 'before validation' do
      it 'applies downcase to protocol and host, and adds a path if missing' do
        expect(subject).to be_valid
        expect(subject.url).to eq 'http://google.com/'
      end
    end   # before validation

    it 'should validate_uniqueness' do
      subject.save
      new = build :delivery_company, url: url
      expect(new).not_to be_valid
      expect(new.errors.messages[:url]).to eq ['has already been taken']
    end

    it 'validates protocol' do
      subject = build :delivery_company, url: '//ya.ru'
      expect(subject).not_to be_valid
      expect(subject.errors.messages[:url]).to eq ['protocol must be http or https']
    end

    it 'validates host' do
      subject = build :delivery_company, url: 'http://?ya.ru'
      expect(subject).not_to be_valid
      expect(subject.errors.messages[:url]).to eq ['host is missing']
    end

    it 'validates format' do
      subject = build :delivery_company, url: '  http'
      expect(subject).not_to be_valid
      expect(subject.errors.messages[:url]).to eq ['wrong format']
    end
  end   #url

  describe '#pull' do
    subject do
      create :delivery_company,
          form_name: 'my_form',
          field_name: 'my_field',
          submit: 'my_submit',
          xpath: %q(//*[@id='answer'])
    end
    let(:html) {html_page 'empty_page'}
    let(:agent) {subject.send :agent}
    let(:param) {'123, 234'}
    let(:page) do   # TODO: REMOVE
      Mechanize::Page.new URI(subject.url), nil, html, 200, agent
    end

    before :each do
      allow(agent).to receive(:goto) {subject.url}
    end   # before

    it 'loads the url page via #agent' do
      expect(agent).to receive(:goto).with(subject.url) {subject.url}
      subject.pull param
    end
  end   #pull

  describe 'private methods' do
    describe '#agent' do
      it 'returns an instance of Mechanize' do
        expect(subject.send :agent).to be_a Watir::Browser
      end
    end   #agent
  end   # private methods

  describe :class do
    describe :scope do
      describe '.ordered' do
        it 'sort DeliveryCompany by :ordered' do
          create :delivery_company
          create :delivery_company
          expect(DeliveryCompany.ordered).to eq DeliveryCompany.order(:name)
        end
      end
    end
  end

end
