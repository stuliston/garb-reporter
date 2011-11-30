require 'spec_helper'

describe GarbReporter do
  
  before do

  	# get VCR to serve us up a previously-canned http response for successful login
  	VCR.use_cassette('garb authentication') do
		   Garb::Session.login('stuart@example.com', 'password')
		end

		# get VCR to serve us up a previously-canned http response for fetching profiles
		VCR.use_cassette('get profile') do
  		@profile = Garb::Management::Profile.all.detect { |p| p.web_property_id == 'UA-12345678-1' }
  	end

		@report = GarbReporter::Report.new(@profile)
  end

  describe 'build_class_name' do

  	it 'should capitalise the string' do
  		@report.send(:build_class_name, 'visits').should == 'Visits'
  	end

		it 'should strip out underscores' do
  		@report.send(:build_class_name, 'visits_by_office').should_not match(/_/)
  	end

  	it 'should handle really long strings' do
  		@report.send(:build_class_name, 'visits_and_pageviews_and_clicks_by_date_and_office').should == 'VisitsAndPageviewsAndClicksByDateAndOffice'
  	end
  end

  describe 'valid_method_name' do

  	it 'should not allow a blank string' do
  		@report.send(:valid_method_name?, '').should be_false
  	end

  	it 'should not allow more than one instance of "_by_"' do
  		@report.send(:valid_method_name?, 'visits_by_office_by_date').should be_false
  	end

  	it 'should not start or end with "_by_" or "_and_' do
  		@report.send(:valid_method_name?, '_by_date').should be_false
  		@report.send(:valid_method_name?, 'visits_by_').should be_false
  		@report.send(:valid_method_name?, '_and_date').should be_false
  		@report.send(:valid_method_name?, 'visits_and_').should be_false
  	end
  end

  describe 'extract_metrics' do

  	it 'should extract a single metric' do
  		@report.send(:extract_metrics, 'visits').should == [:visits]
  	end

		it 'should extract multiple metrics' do
			@report.send(:extract_metrics, 'visits_and_clicks_and_foo_and_bar').should == [:visits, :clicks, :foo, :bar]
  	end

  	it 'should ignore a dimension' do
  		@report.send(:extract_metrics, 'visits_and_clicks_by_date').should == [:visits, :clicks]
  	end

		it 'should ignore multiple dimensions' do
			@report.send(:extract_metrics, 'visits_and_clicks_by_date_and_office').should == [:visits, :clicks]
  	end
  end

  describe 'dimensions' do

  	it 'should know when there are no dimensions' do
  		@report.send(:extract_dimensions, 'visits').should == []
  	end

  	it 'should extract a single dimension' do
  		@report.send(:extract_dimensions, 'visits_by_date').should == [:date]
  	end

  	it 'should extract multiple dimensions' do
  		@report.send(:extract_dimensions, 'visits_by_date_and_office').should == [:date, :office]
  	end
  end

  describe 'build_new_report_class' do

    before do
      @klass = @report.send(:build_new_report_class, 'visits_by_date', 'VisitsByDate')
    end

    it 'it adds the class so the GarbReporter module' do
      @klass.to_s.should == 'GarbReporter::VisitsByDate'
    end

    it 'should give the new class the public "results" method from Garb::Model module' do
      @klass.respond_to?(:results, false).should be_true
    end

    it 'should apply the correct metrics' do
      report_params = @klass.instance_variable_get(:@metrics)
      report_params.instance_variable_get(:@elements).should == [ :visits ]
    end

    it 'should apply the correct dimensions' do
      report_params = @klass.instance_variable_get(:@dimensions)
      report_params.instance_variable_get(:@elements).should == [ :date ]
    end

  end

end