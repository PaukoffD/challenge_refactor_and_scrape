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
    let(:page) do
      Mechanize::Page.new URI(subject.url), nil, html, 200, agent
    end
    let(:param) {'123, 234'}

    it 'loads the url page via Mechanize' do
      expect(agent).to receive(:get).with(URI subject.url) {page}
      subject.pull param
    end

    context 'when page at url' do
      before :each do
        allow(agent).to receive(:get) {page}
      end   # before

      context 'is not a Mechanize::Page' do
        let(:page) {Mechanize::File.new}

        it 'returns a hash {not_a_page_at_url: [url, page]}' do
          expect(subject.pull param).to eq not_a_page_at_url: [subject.url, page]
        end
      end   # is not a Mechanize::Page

      context 'is a Mechanize::Page' do
        it 'looks up the form by #form_name' do
          expect(page.forms).to receive(:find)
          subject.pull param
        end

        context 'and the specified form is not found' do
          it 'returns Hash {no_form: url}' do
            expect(subject.pull param).to eq no_form: subject.url
          end
        end   # and the specified form is not found

        context 'and the specified form is found' do
          let(:html) {html_page 'form_without_field'}
          let(:form) {page.forms.first}

          it 'looks up the field with the name = #field_name' do
            expect(form.fields).to receive(:find).and_call_original
            subject.pull param
          end

          it 'returns a hash {no_field: field_name} if the field is not found' do
            expect(subject.pull param).to eq no_field: subject.field_name
          end

          context 'and the specified field is found' do
            let(:html) {html_page 'form_with_submit'}
            let(:field) {form.fields.first}
            let(:submit) {form.submits.first}
            let(:answer) {html_page 'empty_page'}
            before :each do
              allow(form).to receive(:submit) do
                Mechanize::Page.new URI(subject.url), nil, answer, 200, agent
              end
            end

            it 'the field should receive :value= with the parameter' do
              expect(field).to receive(:value=).with('123').and_call_original
              subject.pull param
            end

            it 'looks up the submit button with name = #submit' do
              expect(form.submits).to receive(:find).and_call_original
              subject.pull param
            end

            context 'when button is not found' do
              let(:html) {html_page 'form_with_field_without_submit'}

              it 'the form is submitted with nil' do
                expect(form).to receive(:submit).with(nil)
                subject.pull param
              end
            end   # when button is not found

            context 'when button is found' do
              it 'the form is submitted with the submit' do
                expect(submit).to be_a_kind_of Mechanize::Form::Submit
                expect(form).to receive(:submit).with(submit)
                subject.pull param
              end
            end   # when button is found

            describe 'the form is submitted and the answer' do
              context 'is not a Mechanize::Page' do
                let(:returned) {Mechanize::File.new}
                it 'returns a hash {not_a_page: [url, page]}' do
                  expect(form).to receive(:submit) {returned}
                  expect(subject.pull param)
                    .to eq not_a_page: ['my_submit', returned]
                end
              end   # is not a Mechanize::Page

              context 'is a Mechanize::Page' do
                context 'when xpath is not found' do
                  it 'returns a hash {no_xpath: xpath}' do
                    expect(subject.pull param).to eq no_xpath: subject.xpath
                  end
                end   # when xpath is not found

                context 'when xpath is found' do
                  let(:answer) {html_page 'answer'}
                  it 'returns the found content' do
                    expect(subject.pull param)
                      .to eq "<div id=\"answer\">\n      <h2>Hoorah</h2>\n    </div>"
                  end
                end   # when xpath is found
              end   # is a Mechanize::Page
            end   # the form is submitted and the answer
          end   # and the specified field is found
        end   # and the specified form is found
      end   # is a Mechanize::Page
    end   # when page at url
  end   #pull

  describe 'private methods' do
    describe '#agent' do
      it 'returns an instance of Mechanize' do
        expect(subject.send :agent).to be_a_kind_of Mechanize
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
