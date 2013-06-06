# To change this template, choose Tools | Templates
# and open the template in the editor.
# config/initializers/delayed_job_config.rb
Delayed::Worker.destroy_failed_jobs = false
#Delayed::Worker.sleep_delay = 60
#Delayed::Worker.max_attempts = 3
Delayed::Worker.max_run_time = 48.hours
