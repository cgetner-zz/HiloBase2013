# coding: UTF-8
# Important Note: This command has to run on each fresh machine or on a server.

namespace :share_platforms do
    desc "Populate share platforms data"
    task(:data => :environment) do
    
    @platform_arr = ["URL", "HILO", "Email"]

    def populate_share_platforms
       @platform_arr.each{|platform|
          _platform =  SharePlatform.find_by_name(platform)
          if _platform.blank?
              SharePlatform.create({:name=>platform})
          end
      }
    end
    populate_share_platforms()
    end
end