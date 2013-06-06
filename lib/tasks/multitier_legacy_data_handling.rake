# coding: UTF-8
# Important Note: Please don't run this command on the fresh machine or on the fresh server. This task has already ran as a part of the previous release.

require 'ancestry'
namespace :multitier_legacy_data_handling do
  
  [:staging, :production].each do |env|
    task env=>:environment do

      def get_hash(env)
        h = Hash.new
        case env.to_s
        when "staging"
          h["that97@that.com"] = ["that90@that.com","that92@that.com"]
          h["that92@that.com"] = ["that91@that.com", "that90@that.com"]
          h["that90@that.com"] = ["that89@that.com"]
        when "production"
          h["james@deltaconstruction.com"] = ["james.mclane@spartans.ut.edu"]
          h["swati__joshi@hotmail.com"] = ["raviasnani123@gmail.com","sheena.leekha@gmail.com", "amit27.17@gmail.com"]
        end
        h
      end
      
      def legacy_data(env)
        h = get_hash(env)
        h.each do |k,v|
          root = Employer.find_by_email(k.to_s)
          v.each do |email|
            sub = Employer.find_by_email(email.to_s)
            sub.parent = root
            sub.account_type_id = 2

            JobSeekerFollowCompany.where(:company_id => sub.company_id).each do |jsfc|
              jsfc.company_id = root.company_id
              jsfc.save(:validate=>false)
            end

            Job.where(:employer_id =>sub.id).each do |j|
              JobSeekerNotification.where(:job_id =>j.id).each do |jsn|
                jsn.company_id = root.company_id
                jsn.save(:validate=>false)
              end
              j.company_id = root.company_id
              j.save(:validate=>false)
            end

            Company.find_by_id(sub.company_id).destroy
            
            sub.company_id = root.company_id
            sub.save(:validate=>false)
            r = sub.root
            r.account_type_id = 1
            r.save(:validate=>false)
          end
        end
      end
      
      legacy_data(env)
    end
  end
end