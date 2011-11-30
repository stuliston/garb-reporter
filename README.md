Garb-Reporter

	https://github.com/stuliston/garb-reporter

Description

  Small wrapper to compliment the excellent Garb gem (http://github.com/vigetlabs/garb). Please have a glance over their documentation as it covers some imprtant Google Analytics stuff too.

Background

  Traditionally with Garb, you'll create a class for every report that you want. So a report that pulls back
  visits might look like this:

	class Visits
		extend Garb::Model

		metrics :visits
	end

  and one that gets visits and page view might look like this:

	class VisitsAndPageViews
		extend Garb::Model

		metrics :visits, :pageviews
	end

  The you would use the report classes like this:

  	> Garb::Session.login(username, password) # this is only one option, please see Garb docs
  	> profile = Garb::Management::Profile.all.detect {|p| p.web_property_id == 'UA-XXXXXXX-X'}
  	> Visits.results(profile)

  My idea was that, it would be nice to be able to avoid creating the report classes up-front by
  utilising a common querying API (like a poor man's ActiveRecord API, if you will).

Usage

	So, when you have garb-reporter in your project, you no longer have to create those classes 
	(Visits or VisitsAndPageViews above) up-front.

	The authentication and profile retrieval steps remain the same:

		> Garb::Session.login(username, password) # this is only one option, please see Garb docs
  	> profile = Garb::Management::Profile.all.detect {|p| p.web_property_id == 'UA-XXXXXXX-X'}

  But thereafter we just have to create a GarbReporter::Report instance with the profile:

  	> report = GarbReporter::Report.new(profile)

  Then we can bust out some (albeit limit at this stage) querying awesomesauce:

  	> report.visits
  	> report.pageviews
  	> report.pageviews_and_visits
  	> report.pageviews_and_visits_by_date
  	> report.organicsearches
  	> report.organicsearches_by_source

  You can probably see the pattern, but as long as you keep it legal with The Big G, a la:

  	http://code.google.com/apis/analytics/docs/gdata/dimsmets/dimsmets.html
  
  ...and format your methods like this:

  	> [metric]_and_[metric]_and_[metric]_by_[dimension]_and_[dimension]

  you should be laughing.

 
TODOS

	* Integrate passing-through additional options to Garb

Run-time Requirements

  * Garb (tested against version 0.9.1)

Requirements for Testing

  * rspec
  * i18n
  * vcr
  * fakeweb

Install

    gem install garb-reporter OR with bundler: gem 'garb-reporter' and `bundle install`

Contributors

	* Stu Liston (https://twitter.com/stuliston)
	* Eric Harrison (https://twitter.com/gzminiz)

Thanks especially to the Garb core contributors. This tiny gem relies heavily on the great work they've produced

License
-------

  (The MIT License)

  Copyright (c) 2011 Stuart Liston

  Permission is hereby granted, free of charge, to any person obtaining
  a copy of this software and associated documentation files (the
  'Software'), to deal in the Software without restriction, including
  without limitation the rights to use, copy, modify, merge, publish,
  distribute, sublicense, and/or sell copies of the Software, and to
  permit persons to whom the Software is furnished to do so, subject to
  the following conditions:

  The above copyright notice and this permission notice shall be
  included in all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
  CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
