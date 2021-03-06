require File.expand_path('../spec_helper', File.dirname(__FILE__))

module Rapleaf
  module Marketo
    describe LeadRecord do
      let(:email) { 'some@email.com' }
      let(:idnum) { 93480938 }

      it "should store the idnum" do
        lead_record = LeadRecord.new(email, idnum)
        lead_record.idnum.should == idnum
      end

      it "should store the email" do
        LeadRecord.new(email, idnum).email.should == email
      end

      it "should implement == sensibly" do
        lead_record1 = LeadRecord.new(email, idnum)
        lead_record1.set_attribute('favourite color', 'red')
        lead_record1.set_attribute('age', '100')

        lead_record2 = LeadRecord.new(email, idnum)
        lead_record2.set_attribute('favourite color', 'red')
        lead_record2.set_attribute('age', '100')

        lead_record1.should == lead_record2
      end

      it "should store when attributes are set" do
        lead_record = LeadRecord.new(email, idnum)
        lead_record.set_attribute('favourite color', 'red')
        lead_record.get_attribute('favourite color').should == 'red'
      end

      it "should store when attributes are updated" do
        lead_record = LeadRecord.new(email, idnum)
        lead_record.set_attribute('favourite color', 'red')
        lead_record.set_attribute('favourite color', 'green')
        lead_record.get_attribute('favourite color').should == 'green'
      end

      it "should yield all attributes through each_attribute_pair" do
        lead_record = LeadRecord.new(email, idnum)
        lead_record.set_attribute('favourite color', 'red')
        lead_record.set_attribute('favourite color', 'green')
        lead_record.set_attribute('age', '99')

        pairs       = []
        lead_record.each_attribute_pair do |attribute_name, attribute_value|
          pairs << [attribute_name, attribute_value]
        end

        pairs.size.should == 3
        pairs.should include(['favourite color', 'green'])
        pairs.should include(['age', '99'])
        pairs.should include(['Email', email])
      end

      it "should be instantiable from a savon hash" do
        savon_hash = {
            :email => email,
            :foreign_sys_type => nil,
            :lead_attribute_list => {
                :attribute => [
                  { :attr_name => 'Company', :attr_type => 'string', :attr_value => 'Rapleaf'},
                  { :attr_name => 'FirstName', :attr_type => 'string', :attr_value => 'James'},
                  { :attr_name => 'LastName', :attr_type => 'string', :attr_value => 'O\'Brien'}
                ]
            },
            :foreign_sys_person_id => nil,
            :id => idnum
        }

        actual = LeadRecord.from_hash(savon_hash)

        expected = LeadRecord.new(email, idnum)
        expected.set_attribute('Company', 'Rapleaf')
        expected.set_attribute('FirstName', 'James')
        expected.set_attribute('LastName', 'O\'Brien')

        actual.should == expected
      end

      it "should be instantiable from a savon hash with only a single attribute" do
        savon_hash = {
          :email => email,
          :foreign_sys_type => nil,
          :lead_attribute_list => {
            :attribute =>
              {:attr_name=>"usertype", :attr_type=>"string", :attr_value=>"Lead"}
          },
          :foreign_sys_person_id => nil,
          :id => idnum
        }

        actual = LeadRecord.from_hash(savon_hash)
        expected = LeadRecord.new(email, idnum)
        expected.set_attribute('usertype', 'Lead')
        actual.should == expected
      end
    end
  end
end