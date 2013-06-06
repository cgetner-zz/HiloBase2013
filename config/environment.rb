# coding: UTF-8

# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Hilo::Application.initialize!

ActionView::Base.field_error_proc = proc { |input, instance| input }

BIRKMAN_API_KEY = "e3291d1b1c85c94f428743f182a43e08"

#~ COSIDERING_COST = 0.11
#~ INTERESTED_COST = 0.15

REGISTRATION_COST = 19.99
ACCOUNT_SETUP_STEP = 1
QUESTIONNAIRE_STEP = 2
PAIRING_CREDENTIALS_STEP = 3
PAIRING_BASICS_STEP = 4
PAYMENT_STEP = 5

WEEKLY_EMAIL = 2
DAILY_EMAIL = 3
ON_EVENT_EMAIL = 4

#set to 1 if we have to exclude payment options otherwise 0
EXCLUDE_PAYMENT = 1

PAYMENT_SESSION_TIMER = 900

JOB_DETAIL_VIEW_COST = 0.99
JOB_EXPRESS_INTEREST_COST = 0.99
JOB_WILD_CARD_COST = 9.99
CREDIT_AMOUNT = 5.00

GIFT_CARD_AMOUNT = 19.99
PROMO_COST = 22.99

PSYCHOMETRIC_CONSTANT = 1.0
SALARY_FIT_CONSTATNT = 1.0
SKILLS_MATCH_CONSTANT = 1.0
LANGUAGE_CONSTANT = 0.5
CERTIFICATION_CONSTANT = 0.5
GEOGRAPHICAL_CONSTANT = -0.5
ROLES_CONSTANT = 1.0

$compensation_values =[20,30,40,50,60,70,80,90,100,125,150,200,250,300]
$desired_paid_time =[0,1,2,3,4,5,6]
$desired_commute_radius =[0,5,10,20,30,40,50]
$work_exp_range = [0,1,2,3,4,5,6,7,8,9,10]

EMPLOYER_REGISTRATION_COST = 9.99
EMPLOYER_ACCOUNT_SETUP_STEP = 1
EMPLOYER_PAYMENT_STEP = 2

BIRKMAN_PDF_PATH = "public/system/birkman_report"

SEEKER_ACCOUNT_JOBS_PER_PAGE = 10

DATE_FORMAT = "%m/%d/%Y"

BIRKMAN_STEP_CITIZENSHIP = 1
BIRKMAN_STEP_WORKENV = 2
BIRKMAN_STEP_TEST_ONE = 3
BIRKMAN_STEP_TEST_TWO = 4
BIRKMAN_STEP_TEST_THREE = 5
BIRKMAN_SET_ONE_LAST_ID = 125
BIRKMAN_SET_TWO_LAST_ID = 250
BIRKMAN_SET_THREE_LAST_ID = 192

SHARE_PLATFORM_TWITTER_ID = 1
SHARE_PLATFORM_FACEBOOK_ID = 2
SHARE_PLATFORM_LINKEDIN_ID = 3
SHARE_PLATFORM_HILO_ID = 5

PURCHASE_PROFILE_COST = 9.99
PURCHASED_PROFILE_VALIDITY = 31
if Rails.env.production?
  RIGHT_COMPANY_ID = 92
elsif Rails.env.staging?
  RIGHT_COMPANY_ID = 7
elsif Rails.env.development?
  RIGHT_COMPANY_ID = 133
end

$work_env_score_map = {
	0=>1, 1=>3, 2=>5,3=>7,4=>9,5=>11,6=>13,7=>15,8=>17,9=>19,10=>21,11=>23,12=>25,13=>27,14=>29,15=>31,16=>33,17=>35,18=>37,19=>39,
	20=>41,21=>43,22=>45,23=>47,24=>49,25=>51,26=>53,27=>55,28=>57,29=>59,30=>61,31=>63,32=>65,33=>67,34=>69,35=>71,36=>73,37=>75,
	38=>77,39=>79,40=>81,41=>83,42=>85,43=>87,44=>89,45=>91,46=>93,47=>95,48=>97,49=>98,50=>99
}
$role_score_map_x = {
	0=>1, 1=>3, 2=>5,3=>7,4=>9,5=>11,6=>12,7=>14,8=>16,9=>18,10=>20,11=>22,12=>24,13=>26,14=>28,15=>30,16=>31,17=>33,18=>35,19=>37,
	20=>39,21=>41,22=>43,23=>45,24=>47,25=>49,26=>50,27=>52,28=>54,29=>56,30=>58,31=>60,32=>62,33=>64,34=>66,35=>68,36=>70,37=>71,
	38=>73,39=>75,40=>77,41=>79,42=>81,43=>83,44=>85,45=>87,46=>89,47=>90,48=>92,49=>94,50=>96,51=>98,52=>99
}
$role_score_map_y = {
	0=>1, 1=>3, 2=>5,3=>6,4=>8,5=>10,6=>12,7=>13,8=>15,9=>17,10=>19,11=>20,12=>22,13=>24,14=>26,15=>28,16=>29,17=>31,18=>33,19=>35,
	20=>36,21=>38,22=>40,23=>42,24=>43,25=>45,26=>47,27=>49,28=>50,29=>52,30=>54,31=>56,32=>58,33=>59,34=>61,35=>63,36=>65,37=>66,
	38=>68,39=>70,40=>72,41=>73,42=>75,43=>77,44=>79,45=>81,46=>82,47=>84,48=>86,49=>88,50=>89,51=>91,52=>93,53=>95,54=>96,55=>98,56=>99
}
$work_env_map_x = {
  0=>1, 1=>4, 2=>6,3=>9,4=>11,5=>14,6=>16,7=>19,8=>21,9=>24,10=>26,11=>29,12=>31,13=>34,14=>36,15=>39,16=>41,17=>44,18=>46,19=>49,
  20=>51,21=>54,22=>56,23=>59,24=>61,25=>64,26=>66,27=>69,28=>71,29=>74,30=>76,31=>79,32=>81,33=>84,34=>86,35=>89,36=>91,37=>94,
  38=>96,39=>97,40=>99
}
$work_env_map_y = {
  0=>1, 1=>4, 2=>7,3=>10,4=>14,5=>17,6=>20,7=>23,8=>26,9=>29,10=>32,11=>35,12=>39,13=>42,14=>45,15=>48,16=>51,17=>54,18=>57,19=>60,
  20=>64,21=>67,22=>70,23=>73,24=>76,25=>79,26=>82,27=>85,28=>89,29=>92,30=>95,31=>98,32=>99
}
$work_red = { :left => ["Action","Routine","Work on tactical, short term projects","Direct involvement with projects","Clear boundaries of authority and responsibility","Some autonomy","Practical problem solving"],
  :right =>  ["Delays","Frequent changes","Long term projects & goals","Indirect involvement","Informal, unstated lines of authority","Micro-management","Ambiguity"]
}
$work_green = {:left => ["A flexible schedule", "Flexible rules and policies", "Autonomy", "High levels of communication and candor", "Collaborative efforts", "Personalized benefits", "Competition", "High energy"],
  :right => ["A defined, enforced schedule", "Strict, unbending rules and policies","Micromanagement","Low levels of communication","Facing obstacles alone","Group rewards","Non-competitiveness","Low energy"]
}
$work_yellow = {:left => ["Delegative or democratic style management", "Stability", "Defined roles and authority", "Group rewards and compensation", "The ability to work from a plan", "A detailed approach", "The ability to work on short term, tactical projects", "Calculated risks"],
  :right =>   ["Consensus style management", "Frequent changes", "Unclear boundaries and roles", "Individual rewards and compensation", "Free-wheeling approach to tasks", "A global approach"]
}
$work_blue = {:left => ["Consensus management", "Novelty and variety", "Shared rewards and compensation", "Non-competitiveness", "Flexibility", "Creativity and ideas", "Collaborative efforts", "Subjectivity and sensitivity"],
  :right => ["Directive management", "Routine", "Individual rewards and compensation", "Competition"]
}
$role_red = {:left=>  ["The ability to be hands on with your work", "The ability to complete tasks", "Being goal-driven", "The ability to measure your success through results", "Defined activities", "The ability to focus on the task at hand"],
  :right=> ["Influence of feelings", "Job ambiguity", "Close supervision/management", "Dynamic priorities", "Project or task ambiguity", "Focus on people/clients"]
}
$role_green = {:left=> ["The ability for you to work with others directly", "The ability for you to use persuasive language", "The ability to generate results by working with people", "The ability to deal with present or short term goals", "Organized support to achieve your goals", "Relationship building", "The opportunity to help others"],
  :right=> ["Independent work with little or no interaction with others", "Specific repetitive tasks", "Rigid routine", "Long range/long-term goals"]
}
$role_yellow = {:left=> ["Working with practical information", "Working with numbers and detailed information", "Getting results through systems", "Dealing with the past", "Agreeable solutions and outcomes"],
  :right=> ["Use of persuasion", "Interaction with large groups", "Flexible operation procedures", "Immediate goals", "Direct confrontation", "Frequent change"]
}
$role_blue = {:left=> ["Working with ideas and theories", "Getting results through innovation", "The ability to be innovative and creative", "Dealing with future planning", "Dealing with people indirectly", "You the ability to make an individual contribution", "Consensus"],
  :right=> ["Focus on operational details", "Setting up operational procedures", "Hands on physical work", "Focus on immediate goals", "Interaction with large groups"]
}
$role_red_position = ["Implement","See a finished product","Solve practical problems","Work through people","Deal in the present or short-term","Apply technical knowledge and expertise to solution","Manage the tasks of others"]

$role_green_position = ["Sell and promote","Persuade others","Motivate others","Work with people","Try new methods and ways of doing things","Negotiate"]

$role_yellow_position = ["Stick to a schedule and routine","Work in the details","Work with numbers","Work with systems","Analyze","Administrate","Work from facts","Use what worked before","Be systematic"]

$role_blue_position = ["Be involved with coming up with the idea or plan (but not the implementation)","Dealing with more abstract concepts and theories","Create novel approaches and methodologies","Innovate and create","Pay attention to aesthetics","Expand, add and modify existing plans and ideas of others"]

$payment_mode = { :pro=> "pro",
  :express=>"express",
  :promo_code=>"promo_code",
  :pro_promo=>"pro_promo_code",
  :express_promo=>"express_promo_code",
  :ref_transaction=>"ref_transaction",
  :ref_transaction_promo=>"ref_transaction_promo_code",
  :hilo_transaction => "hilo_transaction"
}

$payment_purpose = {:seeker_registration => "seeker_registration",
  :gift => "gift",
  :employer_registration =>"employer_registration",
  :job_detail_view => "job_detail_view",
  :job_interest => "job_interest",
  :job_wild => "job_wild",
  :purchase_profile => "purchase_profile"
}


$promo_code_origination ={
  :beta_code_request => "beta_code_request",
  :gift_coupon => "gift_coupon",
  :credit_coupon => "credit_coupon",
  :site_activation_credit => "site_activation_credit"
}