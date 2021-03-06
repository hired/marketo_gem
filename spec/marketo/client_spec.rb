require File.expand_path('../spec_helper', File.dirname(__FILE__))

module Rapleaf
  module Marketo

    describe Client do

      let(:email) { "some@email.com" }
      let(:idnum) { 29 }
      let(:first) { 'Joe' }
      let(:last) { 'Smith' }
      let(:company) { 'Rapleaf' }
      let(:mobile) { '415 123 456' }
      let(:api_key) { 'API123KEY' }

      context 'Client interaction' do
        it "should have the correct body format on get_lead_by_idnum" do
          savon_client          = double('savon_client')
          authentication_header = double('authentication_header')
          client                = Rapleaf::Marketo::Client.new(savon_client, authentication_header)
          response_hash         = {
              :success_get_lead => {
                  :result => {
                      :count            => 1,
                      :lead_record_list => {
                          :lead_record => {
                              :email                 => email,
                              :lead_attribute_list   => {
                                  :attribute => [
                                      {:attr_name => 'name1', :attr_type => 'string', :attr_value => 'val1'},
                                      {:attr_name => 'name2', :attr_type => 'string', :attr_value => 'val2'},
                                      {:attr_name => 'name3', :attr_type => 'string', :attr_value => 'val3'},
                                      {:attr_name => 'name4', :attr_type => 'string', :attr_value => 'val4'}
                                  ]
                              },
                              :foreign_sys_type      => nil,
                              :foreign_sys_person_id => nil,
                              :id                    => idnum.to_s
                          }
                      }
                  }
              }
          }
          expect_request(savon_client,
                         authentication_header,
                         equals_matcher(:lead_key => {
                             :key_value => idnum,
                             :key_type  => LeadKeyType::IDNUM
                         }),
                         'ns1:paramsGetLead',
                         response_hash)
          expected_lead_record = LeadRecord.new(email, idnum)
          expected_lead_record.set_attribute('name1', 'val1')
          expected_lead_record.set_attribute('name2', 'val2')
          expected_lead_record.set_attribute('name3', 'val3')
          expected_lead_record.set_attribute('name4', 'val4')
          client.get_lead_by_idnum(idnum).should == expected_lead_record
        end

        it "should have the correct body format on get_lead_by_email" do
          savon_client          = double('savon_client')
          authentication_header = double('authentication_header')
          client                = Rapleaf::Marketo::Client.new(savon_client, authentication_header)
          response_hash         = {
              :success_get_lead => {
                  :result => {
                      :count            => 1,
                      :lead_record_list => {
                          :lead_record => {
                              :email                 => email,
                              :lead_attribute_list   => {
                                  :attribute => [
                                      {:attr_name => 'name1', :attr_type => 'string', :attr_value => 'val1'},
                                      {:attr_name => 'name2', :attr_type => 'string', :attr_value => 'val2'},
                                      {:attr_name => 'name3', :attr_type => 'string', :attr_value => 'val3'},
                                      {:attr_name => 'name4', :attr_type => 'string', :attr_value => 'val4'}
                                  ]
                              },
                              :foreign_sys_type      => nil,
                              :foreign_sys_person_id => nil,
                              :id                    => idnum.to_s
                          }
                      }
                  }
              }
          }
          expect_request(savon_client,
                         authentication_header,
                         equals_matcher({:lead_key => {
                             :key_value => email,
                             :key_type  => LeadKeyType::EMAIL}}),
                         'ns1:paramsGetLead',
                         response_hash)
          expected_lead_record = LeadRecord.new(email, idnum)
          expected_lead_record.set_attribute('name1', 'val1')
          expected_lead_record.set_attribute('name2', 'val2')
          expected_lead_record.set_attribute('name3', 'val3')
          expected_lead_record.set_attribute('name4', 'val4')
          client.get_lead_by_email(email).should == expected_lead_record
        end

        it "should have the correct body format on sync_lead_record" do
          savon_client          = double('savon_client')
          authentication_header = double('authentication_header')
          client                = Rapleaf::Marketo::Client.new(savon_client, authentication_header)
          response_hash         = {
              :success_sync_lead => {
                  :result => {
                      :lead_id     => idnum,
                      :sync_status => {
                          :error   => nil,
                          :status  => 'UPDATED',
                          :lead_id => idnum
                      },
                      :lead_record => {
                          :email                 => email,
                          :lead_attribute_list   => {
                              :attribute => [
                                  {:attr_name => 'name1', :attr_type => 'string', :attr_value => 'val1'},
                                  {:attr_name => 'name2', :attr_type => 'string', :attr_value => 'val2'},
                                  {:attr_name => 'name3', :attr_type => 'string', :attr_value => 'val3'},
                                  {:attr_name => 'name4', :attr_type => 'string', :attr_value => 'val4'}
                              ]
                          },
                          :foreign_sys_type      => nil,
                          :foreign_sys_person_id => nil,
                          :id                    => idnum.to_s
                      }
                  }
              }
          }
          expect_request(savon_client,
                         authentication_header,
                         (Proc.new do |actual|
                             retval = true
                             retval = false unless actual[:return_lead]
                             retval = false unless actual[:lead_record][:email].equal?(email)
                             retval = false unless actual[:lead_record][:lead_attribute_list][:attribute].size == 5
                             retval = false unless actual[:lead_record][:lead_attribute_list][:attribute].include?({:attr_value => email, :attr_name => "Email", :attr_type => "string"})
                             retval = false unless actual[:lead_record][:lead_attribute_list][:attribute].include?({:attr_value => "val1", :attr_name => "name1", :attr_type => "string"})
                             retval = false unless actual[:lead_record][:lead_attribute_list][:attribute].include?({:attr_value => "val2", :attr_name => "name2", :attr_type => "string"})
                             retval = false unless actual[:lead_record][:lead_attribute_list][:attribute].include?({:attr_value => "val3", :attr_name => "name3", :attr_type => "string"})
                             retval = false unless actual[:lead_record][:lead_attribute_list][:attribute].include?({:attr_value => "val4", :attr_name => "name4", :attr_type => "string"})
                             retval.should == true
                         end),
                         'ns1:paramsSyncLead',
                         response_hash)
          lead_record = LeadRecord.new(email, idnum)
          lead_record.set_attribute('name1', 'val1')
          lead_record.set_attribute('name2', 'val2')
          lead_record.set_attribute('name3', 'val3')
          lead_record.set_attribute('name4', 'val4')

          client.sync_lead_record(lead_record).should == lead_record
        end

        it "should have the correct body format on sync_lead" do
          savon_client          = double('savon_client')
          authentication_header = double('authentication_header')
          client                = Rapleaf::Marketo::Client.new(savon_client, authentication_header)
          response_hash         = {
              :success_sync_lead => {
                  :result => {
                      :lead_id     => idnum,
                      :sync_status => {
                          :error   => nil,
                          :status  => 'UPDATED',
                          :lead_id => idnum
                      },
                      :lead_record => {
                          :email                 => email,
                          :lead_attribute_list   => {
                              :attribute => [
                                  {:attr_name => 'name1', :attr_type => 'string', :attr_value => 'val1'},
                                  {:attr_name => 'name2', :attr_type => 'string', :attr_value => 'val2'},
                                  {:attr_name => 'name3', :attr_type => 'string', :attr_value => 'val3'},
                                  {:attr_name => 'name4', :attr_type => 'string', :attr_value => 'val4'}
                              ]
                          },
                          :foreign_sys_type      => nil,
                          :foreign_sys_person_id => nil,
                          :id                    => idnum.to_s
                      }
                  }
              }
          }

          expect_request(savon_client,
                         authentication_header,
                         Proc.new { |actual|
                           actual_attribute_list                                  = actual[:lead_record][:lead_attribute_list][:attribute]
                           actual[:lead_record][:lead_attribute_list][:attribute] = nil
                           expected                                               = {
                               :return_lead => true,
                               :lead_record => {
                                   :email               => "some@email.com",
                                   :lead_attribute_list =>
                                       {
                                           :attribute => nil}}
                           }
                           actual.should == expected
                           actual_attribute_list.should =~ [
                               {:attr_value => first,
                                :attr_name  => "FirstName",
                                :attr_type  => "string"},
                               {:attr_value => last,
                                :attr_name  => "LastName",
                                :attr_type  => "string"},
                               {:attr_value => email,
                                :attr_name  =>"Email",
                                :attr_type  => "string"},
                               {:attr_value => company,
                                :attr_name  => "Company",
                                :attr_type  => "string"},
                               {:attr_value => mobile,
                                :attr_name  => "MobilePhone",
                                :attr_type  => "string"}
                           ]
                         },
                         'ns1:paramsSyncLead',
                         response_hash)
          expected_lead_record = LeadRecord.new(email, idnum)
          expected_lead_record.set_attribute('name1', 'val1')
          expected_lead_record.set_attribute('name2', 'val2')
          expected_lead_record.set_attribute('name3', 'val3')
          expected_lead_record.set_attribute('name4', 'val4')
          client.sync_lead(email, first, last, company, mobile).should == expected_lead_record
        end

        context "list operations" do
          LIST_KEY = 'awesome leads list'

          before(:each) do
            @savon_client          = double('savon_client')
            @authentication_header = double('authentication_header')
            @client                = Rapleaf::Marketo::Client.new(@savon_client, @authentication_header)
          end

          it "should have the correct body format on add_to_list" do
            response_hash = {} # TODO
            expect_request(@savon_client,
                           @authentication_header,
                           equals_matcher({
                                              :list_operation   => ListOperationType::ADD_TO,
                                              :list_key         => LIST_KEY,
                                              :strict           => 'false',
                                              :list_member_list => {
                                                  :lead_key => [
                                                      {
                                                          :key_type  => 'EMAIL',
                                                          :key_value => email
                                                      }
                                                  ]
                                              }
                                          }),
                           'ns1:paramsListOperation',
                           response_hash)

            @client.add_to_list(LIST_KEY, email).should == response_hash
          end

          it "should have the correct body format on remove_from_list" do
            response_hash = {} # TODO
            expect_request(@savon_client,
                           @authentication_header,
                           equals_matcher({
                                              :list_operation   => ListOperationType::REMOVE_FROM,
                                              :list_key         => LIST_KEY,
                                              :strict           => 'false',
                                              :list_member_list => {
                                                  :lead_key => [
                                                      {
                                                          :key_type  => 'EMAIL',
                                                          :key_value => email
                                                      }
                                                  ]
                                              }
                                          }),
                           'ns1:paramsListOperation',
                           response_hash)

            @client.remove_from_list(LIST_KEY, email).should == response_hash
          end

          it "should have the correct body format on is_member_of_list?" do
            response_hash = {} # TODO
            expect_request(@savon_client,
                           @authentication_header,
                           equals_matcher({
                                              :list_operation   => ListOperationType::IS_MEMBER_OF,
                                              :list_key         => LIST_KEY,
                                              :strict           => 'false',
                                              :list_member_list => {
                                                  :lead_key => [
                                                      {
                                                          :key_type  => 'EMAIL',
                                                          :key_value => email
                                                      }
                                                  ]
                                              }
                                          }),
                           'ns1:paramsListOperation',
                           response_hash)

            @client.is_member_of_list?(LIST_KEY, email).should == response_hash
          end
        end
      end

      private

      def equals_matcher(expected)
        Proc.new { |actual|
          actual.should == expected
        }
      end

      def expect_request(savon_client, authentication_header, expected_body_matcher, expected_namespace, response_hash)
        header_hash       = double('header_hash')
        soap_response     = double('soap_response')
        request_namespace = double('namespace')
        request_header    = double('request_header')
        soap_request      = double('soap_request')
        authentication_header.should_receive(:set_time)
        authentication_header.should_receive(:to_hash).and_return(header_hash)
        request_namespace.should_receive(:[]=).with("xmlns:ns1", "http://www.marketo.com/mktows/")
        request_header.should_receive(:[]=).with("ns1:AuthenticationHeader", header_hash)
        soap_request.should_receive(:namespaces).and_return(request_namespace)
        soap_request.should_receive(:header).and_return(request_header)
        soap_request.should_receive(:body=) do |actual_body|
          expected_body_matcher.call(actual_body)
        end
        soap_response.should_receive(:to_hash).and_return(response_hash)
        savon_client.should_receive(:request).with(expected_namespace).and_yield(soap_request).and_return(soap_response)
      end
    end

    describe ListOperationType do
      it 'should define the correct types' do
        ListOperationType::ADD_TO.should == 'ADDTOLIST'
        ListOperationType::IS_MEMBER_OF.should == 'ISMEMBEROFLIST'
        ListOperationType::REMOVE_FROM.should == 'REMOVEFROMLIST'
      end
    end
  end
end