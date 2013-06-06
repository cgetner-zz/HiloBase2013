# coding: UTF-8

namespace :zipcode_legacy_to_geocode do
  desc "Convert Zipcode to lat and Long"
  task(:data => :environment) do
    require "geocoder"
    
    # Convert Zipcode to Lat/long using geocoder
    # Handle legacy data for JobLocations table    
    def legacy_zipcode_to_geocode      
      @job_locations = JobLocation.find_by_sql("SELECT `job_locations`.* FROM `job_locations`  INNER JOIN jobs ON job_locations.id = jobs.job_location_id where job_locations.latitude is NULL and jobs.remote_work = 0")
      if !@job_locations.empty?
        for job in @job_locations
          state = Zipcode.where("zip = ? ",job.zip_code).first
          if state.nil?
            results = Geocoder.search(job.zip_code.to_s + ", US")
          else
            results = Geocoder.search(state.state.to_s + " "+ job.zip_code.to_s)
          end
          if !results.first.nil?
            latitude = results.first.latitude
            longitude = results.first.longitude
            city = results.first.city
            state = results.first.state
            country = results.first.country
            job.update_attributes(:latitude => latitude, :longitude => longitude, :city => city, :state => state, :country => country)
          end
        end
      end
 
      # Handle legacy data for JobSeekerDesiredLocations table     
      @job_seeker_desired_locations = JobSeekerDesiredLocation.where("desired_location_id = 1 and latitude IS NULL").all
      if !@job_seeker_desired_locations.empty?
        for job_seeker in @job_seeker_desired_locations
          results = Geocoder.search(job_seeker.pincode.to_s + ", US")
          latitude = results.first.latitude
          longitude = results.first.longitude
          city = results.first.city
          job_seeker.update_attributes(:latitude => latitude, :longitude => longitude, :city => city)
        end  
      end
       
      # Handle legacy data for Companies table
      @companies = Company.where("city IS NULL").all
      if !@companies.empty?
        for company in @companies
          zip = Zipcode.where("zip = ? ",company.zip).first
          state = State.where("id = ? ",company.state_id).first
          if state.nil?
            results = Geocoder.search(company.zip.to_s + ", US")
          else
            if !zip.nil?
              results = Geocoder.search(state.name.to_s + ",US " + zip.zip.to_s )
            else
              results = Geocoder.search(state.name.to_s + ",US, 11111 " )
            end
          end
          if !results.first.nil?
            city = results.first.city
            state = results.first.state
            country = results.first.country            
            company.update_attributes(:city => city, :state => state, :country => country)
          end
        end
      end
      
    end
    legacy_zipcode_to_geocode()
  end
end