# coding: UTF-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

### start -- populate skill-level ###

@skill_list = ["Practice this skill regularly as a hobby", "Mostly academic", "Current real-world, day-to-day experience", "Past real-world, day-to-day experience"]
def populate_skill_level

  for skill in @skill_list
    _skill = SkillLevel.find_by_name(skill)
    if _skill.blank?
      SkillLevel.create({:name=>skill})
    end
  end
end
populate_skill_level()

### end -- populate skill-level ###

### start -- populate desired employment ####
@employment_list = ["Full Time","Part Time","Contract / Freelance", "Temp", "Internship"]

def populate_employment
  @employment_list.each{|employment|
    _employment =  DesiredEmployment.find_by_name(employment)
    if _employment.blank?
      DesiredEmployment.create({:name=>employment})
    end
  }
end

populate_employment()


### end -- populate desired employment ####

### start -- populate desired location ####
@location_list = ["Local Only","Any"]

def populate_location
  @location_list.each{|location|
    _location =  DesiredLocation.find_by_name(location)
    if _location.blank?
      DesiredLocation.create({:name=>location})
    end
  }
end

populate_location()


### end -- populate desired location ####

### start -- populate languages ####

@language_arr = ["Arabic","Chinese","Danish","Dutch","English (U.S.A)","English (British)","Filipino (Tagalog)","French","German","Greek","Hindi","Indonesian","Irish","Italian","Japanese","Korean","Latin","Pashto","Persian","Polish","Russian","Spanish (Latin Amer.)","Spanish (Spain)","Swahili","Swedish","Thai","Turkish","Vietnamese","Welsch"]

def populate_language
  @language_arr.each{|lang|
    _language =  Language.find_by_name(lang)
    if _language.blank?
      Language.create({:name=>lang})
    end
  }
end

populate_language()

### end -- populate languages ####


### start -- populate certificates ####

@certificate_arr = ["Apple Aperture 2 Level One","Apple Certified Media Administrator","Apple Certified Specialist - Deployment 10.6","Apple Certified Specialist - Directory Services 10.6*","Apple Certified Specialist - Security and Mobility 10.6","Apple Certified Support Professional (ACSP) 10.6","Apple Certified System Administrator (ACSA 10.6)","Apple Certified Technical Coordinator (ACTC) 10.6","Apple Color Correction in Final Cut Studio Level One","Apple Compressor 3.5 Level One","Apple DVD Studio Pro 4 Level One","Apple Final Cut Express 4 Level One","Apple Final Cut Pro 7 Level One","Apple Final Cut Pro 7 Level Two","Apple Final Cut Server Level One","Apple Final Cut Studio Master Pro","Apple Final Cut Studio Master Trainer","Apple Logic Pro 9 Level One","Apple Logic Pro 9 Level Two","Apple Logic Studio Master Pro","Apple Logic Studio Master Trainer","Apple Motion 4 Level One","Apple Sound Editing in Final Cut Studio Level One","Apple Xsan 2 Administrator","Cisco Advanced IP Communications Sales Specialist","Cisco Advanced Wireless LAN Design Specialist","Cisco Advanced Wireless LAN Field Specialist","Cisco Advanced Wireless LAN Sales Specialist","Cisco ASA Specialist","Cisco Data Center Application Services Design Specialist","Cisco Data Center Application Services Support Specialist","Cisco Data Center Networking Infrastructure Design Specialist","Cisco Data Center Networking Infrastructure Support Specialist","Cisco Data Center Networking Sales Specialist","Cisco Data Center Storage Networking Design Specialist","Cisco Data Center Storage Networking Sales Specialist","Cisco Data Center Storage Networking Support Specialist","Cisco Data Center Unified Computing Design Specialist","Cisco Data Center Unified Computing Support Specialist","Cisco Express Foundation Design Specialist","Cisco Express Foundation Field Specialist","Cisco Express Foundation Sales Specialist","Cisco IP Communications Express Sales Specialist","Cisco IP Communications Express Specialist","Cisco IP Contact Center Express Specialist","Cisco IP Telephony Design Specialist","Cisco IPS Specialist","Cisco MeetingPlace Design Specialist","Cisco MeetingPlace Sales Specialist","Cisco MeetingPlace Support Specialist","Cisco Network Admission Control Specialist","Cisco Rich Media Communications Specialist","Cisco Routing and Switching Field Specialist","Cisco Routing and Switching Sales Specialist","Cisco Routing and Switching Solutions Specialist","Cisco Security Sales Specialist","Cisco Security Solutions and Design Specialist","Cisco TelePresence Installations Specialist","Cisco TelePresence Solutions Specialist","Cisco Unified Presence Specialist","Cisco Unity Design Specialist","Cisco Unity Support Specialist","Microsoft Certified Application Developer (MCAD)","Microsoft Certified Application Specialist (MCAS)","Microsoft Certified Architect","Microsoft Certified Business Management Solutions Professional","Microsoft Certified Business Management Solutions Specialist","Microsoft Certified Database Administrator (MCDBA)","Microsoft Certified Desktop Support Technician (MCDST)","Microsoft Certified IT Professional (MCITP)","Microsoft Certified Learning Consultant (MCLC)","Microsoft Certified Master","Microsoft Certified Professional Developer (MCPD)","Microsoft Certified Solution Developer (MCSD)","Microsoft Certified Systems Administrator (MCSA)","Microsoft Certified Systems Engineer (MCSE)","Microsoft Certified Technology Specialist (MCTS)","Microsoft Certified Trainer (MCT)","Microsoft Office Specialist (MOS)","MCITP: Enterprise Desktop Support Technician 7","MCITP: Enterprise Desktop Administrator 7","MCITP: Consumer Support Technician","MCITP: Enterprise Support Technician","MCITP: Enterprise Administrator","MCAS: Windows Vista for the Business Worker","MCAS: Microsoft Office Word 2007","MCAS: Microsoft Office Excel 2007","MCAS: Microsoft Office PowerPoint 2007","MCAS: Microsoft Office Outlook 2007","MCAS: Microsoft Office Access 2007"]

def populate_certificates
  @certificate_arr.each{|cert|
    _cert =  Certificate.find_by_name(cert)
    if _cert.blank?
      Certificate.create({:name=>cert,:activated=>true})
    end
  }
end

populate_certificates()

### end -- populate certificates ####



### start -- populate certificates ####
@proficiency_arr = ["Accounts Payable","Accounts Receivable","Accounts Receivable/Payable","Adobe Illustrator","Cashier","Microsoft Excel","Microsoft Office","Microsoft Powerpoint","Microsoft Word","Office Management","Project Management", "Quickbooks Pro","Salesperson"]

def populate_proficiencies
  @proficiency_arr.each{|prof|
    _prof =  Proficiency.find_by_name(prof)
    if _prof.blank?
      Proficiency.create({:name=>prof,:activated=>true})
    end
  }
end

populate_proficiencies()

### end -- populate certificates ####



### start -- populate ownership ####
@ownership_arr = ["Privately Owned","Publicly Traded"]

def populate_ownerships
  @ownership_arr.each{|owner|
    _ownership =  OwnerShipType.find_by_name(owner)
    if _ownership.blank?
      OwnerShipType.create({:name=>owner})
    end
  }
end

populate_ownerships()

### end -- populate ownership ####
#
### start -- populate platforms ####
  
@platform_arr = ["Twitter","Facebook","LinkedIn"]

def populate_platforms
  @platform_arr.each{|platform|
    _platform =  SharePlatform.find_by_name(platform)
    if _platform.blank?
      SharePlatform.create({:name=>platform})
    end
  }
end
populate_platforms()
### end -- populate platforms ####

# Commented as ADMIN removed
#### start -- default admin ####
#@default_admin = {:first_name=>"Chris",:last_name=>"Getner",:password=>"rohan123",:email=>"chris@getner.com"}
#def populate_default_admin
#  _admin = Admin.find(:first,:conditions=>["email = ?",@default_admin[:email]])
#  if _admin.blank?
#    Admin.create(@default_admin)
#  end
#end
#populate_default_admin()
#### end -- default admin ####
#


### start -- populate question set 1 ####
  
@ques_set_arr = [
  'seldom change their minds once they\'ve decided something',
  'think about things before making decisions',
  'seldom have ready answers',
  'do not like to talk or ask questions in front of a crowd',
  'are happy go lucky most of the time',
  'fool other people to get what they want',
  'like to do the big job first and leave the little ones till later',
  'have to try hard to avoid being shy',
  'have lots of energy most of the time',
  'have big ups and downs between feeling very sad and very happy',
  'would rather have money than for people to like them',
  'have a really warm and friendly feeling toward other people',
  'like working for someone who insists that they follow directions',
  'find it is hard to get rid of or to say "no" to a nice salesperson',
  'tell people when they bother them',
  'have found it it hard to break bad habits',
  'speak right up when they believe others are wrong',
  'make up their minds quickly',
  'are shy around important people',
  'want to be early for meetings or dates',
  'find it harder to be accurate than to be fast',
  'feel it is all right to make fun of people who have unusual ideas',
  'are easily excited',
  'are easy to get to know',
  'often feel tired',
  'are easily made to feel ashamed of themselves',
  'have felt sad and no good at all',
  'often feel tired and find it hard to start doing things',
  'like to work where they can move around',
  'do what they want to do no matter what others think',
  'always finish the things they start',
  'avoid trouble by blaming someone else for their own mistakes',
  'like to make wild bets on games or races',
  'talk a great deal, even around strangers',
  'feel tired in their minds some days and find it hard to think',
  'keep things straight and orderly and do them the way they should be done',
  'like to work fast',
  'like to try to work hard problems',
  'sometimes worry themselves sick',
  'like to keep other people guessing',
  'are afraid or have been afraid of "growing up"',
  'daydream about things that cannot come true',
  'often feel bitter about things in general',
  'like to finish one job at a time even though it may anger others',
  'put things off until the last minute',
  'get restless when they have to wait around',
  'find that tears come to their eyes easily',
  'are embarrassed when they say or do something wrong around others',
  'lose their tempers easily',
  'feel nervous when they cannot finish something they have started',
  'will lie a little if necessary to get ahead in the world',
  'laugh out loud easily',
  'find it hard to talk to strangers',
  'have come close to slapping or hitting another adult',
  'really want to do one job right before they start another one',
  'have trouble keeping their minds on what they are doing',
  'do not want someone else to get the attention they deserve',
  'love to talk at parties or in groups of people',
  'do everything the way it should be done',
  'have trouble relaxing',
  'sometimes say the first thing they think of',
  'make promises they don\'t mean to keep',
  'enjoy teasing or "picking" at friends',
  'anger easily',
  'will not argue with someone even when they know they are right',
  'feel they should get even if someone takes advantage of them',
  'feel uneasy or nervous when they are around important people',
  'believe that they help friends when they tell them their faults',
  'enjoy it when they can make someone look foolish',
  'sometimes feel that things are just hopeless',
  'plan their time for a week or longer and then stick to their plan',
  'have felt sad without knowing why',
  'tell other people the truth when they are trying to sell or buy something',
  'get nervous about introducing people in groups',
  'stand or sit quietly at most parties',
  'find it hard to make up their minds about things',
  'can laugh at themselves when they do something silly',
  'find it easy to make a party more fun',
  'can handle their feelings when they get upset or sad',
  'sometimes feel irritable for days at a time',
  'have headaches or feel tightness in their head when things go wrong',
  'prefer routine over variety',
  'can get along with about five hours or less sleep each night',
  'sometimes have so many problems they don\'t know what to do',
  'make excuses for their mistakes',
  'will argue with you if you tell them they are wrong',
  'will tell you what they really think of you when you make them angry',
  'often feel tired in their minds',
  'change their interests often',
  'believe nothing is more important than money',
  'have trouble sitting still',
  'often feel sad and unhappy',
  'like things to stay the same',
  'have been told that they get angry too easily',
  'have been bothered by thoughts of wanting to escape it all',
  'feel it is all right for employees to take little things when they need them',
  'usually praise others',
  'want to win games very much',
  'wish they could get people to notice and think more of them',
  'keep their word even when it hurts',
  'get very sad and unhappy',
  'like everything that has to do with money -- bargaining, selling, trading',
  'talk and visit with many people',
  'would rather do without something than take advantage of someone',
  'have been so sad that they felt there was no use to hope for anything',
  'will argue to get what\'s theirs',
  'try to stay out of trouble by making things they do wrong sound like they are all right',
  'do not like to wait for traffic lights to change',
  'like to work carefully no matter what',
  'do some things that are a little wrong to get what they want',
  'have to stay busy all the time',
  'can get along easily with about 6 hours or less sleep each night',
  'think much more slowly on some days than on others',
  'feel very depressed some days',
  'are very interested in almost everything they do',
  'like to sleep before they make decisions about something new or different',
  'have their feelings hurt easily when they are blamed for something',
  'are very restless',
  'think everything through carefully one thing at a time',
  'get very excited about what they do',
  'do not like to sell',
  'expect too much from me',
  'have a good memory',
  'have trouble keeping close friends',
  'do not like change'
]

def populate_question_set_one
  @ques_set_arr.each{|q|
    _question =  BirkmanQuestion.find_by_question(q)
    if _question.blank?
      BirkmanQuestion.create({:question=> q, :set_number => 2})
    end
  }
end
populate_question_set_one()
### end -- populate question set 1 ####


### start -- populate question set 2 ####
  
@ques_set2_arr =  [
  'I day dream about things that cannot come true',
  'I like to do the big job first and leave the little ones till later',
  'I like working for someone who insists that I follow directions',
  'I am shy around important people',
  'I often feel tired',
  'I always finish the things I start',
  'I like to work fast',
  'I think about things before making decisions',
  'I have to try hard to avoid being shy',
  'I find it is hard to get rid of or say "no" to a nice salesperson',
  'I want to be early for meetings or dates',
  'I am easily made to feel ashamed of myself',
  'I avoid trouble by blaming someone else for my own mistakes',
  'I like to try to work hard problems',
  'I seldom have ready answers',
  'I have lots of energy most of the time',
  'I tell people when they bother me',
  'I find it is harder to be accurate than to be fast',
  'I have felt sad and no good at all',
  'I like to make wild bets on games or races',
  'I sometimes worry myself sick',
  'I don\'t like to talk or ask questions in front of a crowd',
  'I have big ups and downs between feeling very sad and very happy',
  'I have found it hard to break bad habits',
  'I feel it is all right to make fun of people who have unusual ideas',
  'I often feel tired and find it is hard to start doing things',
  'I often talk a great deal, even around strangers',
  'I like to keep other people guessing',
  'I am happy-go-lucky most of the time',
  'I would rather have money than for people to like me',
  'I speak right up when I believe others are wrong',
  'I am easily excited',
  'I like work where I can move around',
  'I feel tired in my mind some days and find it hard to think',
  'I am afraid or have been afraid of "growing up"',
  'I fool other people to get what I want',
  'I have a really warm and friendly feeling toward other people',
  'I make up my mind quickly',
  'I am easy to get to know',
  'I do what I want no matter what others think',
  'I keep things straight and orderly and do them the the way they should be done',
  'I seldom change my mind once I have decided something',
  'I sometimes have so many problems I do not know what to do',
  'I lose my temper easily',
  'I really want to do one job right before I start another one',
  'I sometimes say the first thing that I think of',
  'I feel uneasy or nervous when I am around important people',
  'I tell other people the truth when I am trying to sell or buy something',
  'I can handle my feelings when I get upset or sad',
  'I like to finish one job at a time even though it may anger others',
  'I feel nervous when I cannot finish something I have started',
  'I have trouble keeping my mind on what I am doing',
  'I make promises I don\'t mean to keep',
  'I believe that I help friends when I tell them their faults',
  'I get nervous about introducing people in groups',
  'I sometimes feel irritable days at a time',
  'I put things off until the last minute',
  'I will lie a little if necessary to get ahead in the world',
  'I do not want someone else to get the attention I deserve',
  'I enjoy teasing or "picking" at friends',
  'I enjoy it when I can make someone look foolish',
  'I stand or sit quietly at the parties',
  'I have headaches or feel a tightness in my head when things go wrong',
  'I get restless when I have to wait around',
  'I laugh out loud easily',
  'I love to talk at parties or in groups of people',
  'I anger easily',
  'I sometimes feel that things are just hopeless',
  'I find it hard to make up my mind about things',
  'I prefer routine over variety',
  'I find that tears come to my eyes easily',
  'I find it hard to talk to strangers',
  'I do everything the way it should be done',
  'I will not argue with someone even when I know I am right',
  'I plan my time for a week or longer and then stick to the plan',
  'I can laugh at myself when I do something silly',
  'I can get along with about about five hours or less sleep each night',
  'I am embarrassed when I say or do something wrong around others',
  'I have come close to slapping or hitting another adult',
  'I have trouble relaxing',
  'I feel I should get even if someone takes advantages of me',
  'I have felt sad without knowing why',
  'I find it easy to make a party more fun',
  'I often feel bitter about things in general',
  'I do not like changes',
  'I have trouble sitting still',
  'I usually praise others',
  'I talk and visit with many people',
  'I like to work carefully no matter what',
  'I am very interested in almost everything I do',
  'I do not like to sell',
  'I will argue with you if you tell me I am wrong',
  'I often feel sad and unhappy',
  'I want to win games very much',
  'I would rather do without something than take advantage of someone',
  'I do some things that are a little wrong to get what I want',
  'I like to sleep before I make decisions about something new or different',
  'I expect too much of myself',
  'I will tell others what I really think of them when they make me angry',
  'I like things to stay the same',
  'I wish I could get people to notice and think more of me',
  'I have been so sad that I felt there was no use to hope for anything',
  'I have to stay busy all the time',
  'I have my feelings hurt easily when I am blamed for something',
  'I have a good memory',
  'I often feel tired in my mind',
  'I have been told that I get angry too easily',
  'I keep my word even when it hurts',
  'I will argue to get what is mine',
  'I can get along easily with about 6 hours or less of sleep each night',
  'I am very restless',
  'I have trouble keeping close friends',
  'I change my interests often',
  'I have been bothered by thoughts of wanting to escape it all',
  'I get very sad and unhappy',
  'I try to stay out of trouble by making things I do wrong sound like they are all right',
  'I think much more slowly on some days than on others',
  'I think everything through carefully one thing at a time',
  'I make excuses for my mistakes',
  'I believe nothing is more important than money',
  'I feel it is all right for employees to take little things when they need them',
  'I like everything that has to do with money - bargaining, selling, trading',
  'I do not like to wait for traffic lights to change',
  'I feel very depressed some days',
  'I get very excited about what I do'
]

def populate_question_set_two
  @ques_set2_arr.each{|q|
    _question =  BirkmanQuestion.find_by_question(q)
    if _question.blank?
      BirkmanQuestion.create({:question=> q, :set_number => 3})
    end
  }
end
populate_question_set_two()
### end -- populate question set 2 ####


### start -- populate question set 3 ####
@ques_set3_arr = [
  {:set_no => 1 ,:options=> ["Electrician","Accountant","Detective","Scout Leader"]},
  {:set_no => 2 ,:options=> ["Farmer","Secretary","Dentist","Librarian"]},
  {:set_no => 3 ,:options=> ["Welder","Clerk","Sign Painter","Child Welfare Work"]},
  {:set_no => 4 ,:options=> ["Plumber","Office Manager","Reporter","Youth Club Work"]},
  {:set_no => 5 ,:options=> ["Safety Inspector","Airline Agent","Writer","Health Counselor"]},
  {:set_no => 6 ,:options=> ["Radio Operator","Office Worker","Singer","Youth Sports Worker"]},
  {:set_no => 7 ,:options=> ["Store Manager","Cabinet Maker","Buyer for Store","Pharmacist" ]},
  {:set_no => 8 ,:options=> ["Politician","Dairy Farmer","Mathematician","Laboratory Worker"]},
  {:set_no => 9 ,:options=> ["Advertising Agent","Telephone Repairer","Chief Clerk","Interior Designer"]},
  {:set_no => 10 ,:options=> ["Radio Announcer","Animal Trainer","Cashier","Printer"]},
  {:set_no => 11 ,:options=> ["Sales Manager","Engineer","Mathematics Teacher","Author"]},
  {:set_no => 12 ,:options=> ["Police Work","Carpenter","Typist","Music Librarian"]},
  {:set_no => 13 ,:options=> ["Scientist","Clergy","Forester","Accountant"]},
  {:set_no => 14 ,:options=> ["Photographer","Camp Counselor","Rancher","Postal Worker"]},
  {:set_no => 15 ,:options=> ["Architect","School Principal","Machinist","Office Worker"]},
  {:set_no => 16 ,:options=> ["Writer","Job Counselor","Commercial Fishing","General Office Clerk"]},
  {:set_no => 17 ,:options=> ["Song Writer","High School Teacher","Farmer","Store Cashier"]},
  {:set_no => 18 ,:options=> ["Musician","Social Worker","Toolmaker","Shipping Clerk"]},
  {:set_no => 19 ,:options=> ["Bank Teller","Weather Expert","Hotel Manager","Mechanic"]},
  {:set_no => 20 ,:options=> ["Accountant","Florist","Sales Person","Fish, Game Warden"]},
  {:set_no => 21 ,:options=> ["Bookkeeper","Artist","Actor","Gardener"]},
  {:set_no => 22 ,:options=> ["Tax Lawyer","Magazine Editor","Law Enforcement Officer","Floral Worker"]},
  {:set_no => 23 ,:options=> ["File Clerk","Piano Tuner","Store Clerk","Agricultural Worker"]},
  {:set_no => 24 ,:options=> ["Law Clerk","Member of Orchestra","Insurance Adjuster","Landscape Worker"]},
  {:set_no => 25 ,:options=> ["Electronics Specialists","Radio Announcer","Photographer","Advertising Planner"]},
  {:set_no => 26 ,:options=> ["Cost Analyst","Forester","Insurance Adjuster","Song Writer"]},
  {:set_no => 27 ,:options=> ["Magazine Writer","Tax Lawyer","Surgeon","Job Counselor"]},
  {:set_no => 28 ,:options=> ["Law Enforcement Officer","Reporter","Shipping Clerk","Machinist"]},
  {:set_no => 29 ,:options=> ["Ship's Officer","Hotel Manager","Psychologist","Purchasing Agent"]},
  {:set_no => 30 ,:options=> ["General Office Clerk","Cabinet Maker","Store Clerk","Musician"]},
  {:set_no => 31 ,:options=> ["Research Director","Office Manager","Production Manager ","Sales Manager"]},
  {:set_no => 32 ,:options=> ["Clergy","Art Critic","Auditor","Law Enforcement Officer"]},
  {:set_no => 33 ,:options=> ["Veterinarian","Social Worker","Architect","Accountant"]},
  {:set_no => 34 ,:options=> ["Chief Clerk","Toolmaker","Constable","Performing Musician"]},
  {:set_no => 35 ,:options=> ["Psychiatrist","Company Controller","Military Career","Trial Lawyer"]},
  {:set_no => 36 ,:options=> ["Member, Training Staff","Layout Artist","Statistician","Printer"]},
  {:set_no => 37 ,:options=> ["Vocational Trainer","Personnel Worker","Librarian","Pharmacist"]},
  {:set_no => 38 ,:options=> ["Financial Manager","Factory Manager","Advertising Manager","Managing Editor"]},
  {:set_no => 39 ,:options=> ["Architect","Mathematician","Physicist","Sales Promotion"]},
  {:set_no => 40 ,:options=> ["Youth Club Worker","Sign Painter","Postal Worker","Gardener"]},
  {:set_no => 41 ,:options=> ["Builder","High School Teacher","Choral Director","Legal Clerk"]},
  {:set_no => 42 ,:options=> ["Financial Expert","Engineer","Store Manager","Dentist"]},
  {:set_no => 43 ,:options=> ["Commercial Artist","Bookkeeper","Plumber","Claims Adjuster"]},
  {:set_no => 44 ,:options=> ["Social Worker","Interior Designer","Secretary","Computer Programmer"]},
  {:set_no => 45 ,:options=> ["Laboratory Worker","Job Counselor","Reporter","Mathematician"]},
  {:set_no => 46 ,:options=> ["Auditor","Fish, Game Warden","Politician","Detective"]},
  {:set_no => 47 ,:options=> ["Weather Forecaster","Airline Agent","Car Dealer","Insurance Salesperson"]},
  {:set_no => 48 ,:options=> ["Teacher","Interior Decorator","Bank Cashier","Optometrist"]}
]
def populate_question_set_three
  @ques_set3_arr.each{|q|
    _question =  BirkmanJobInterest.find(:first,:conditions=>["set_number = ? ",q[:set_no]])
    if _question.blank?
      q[:options].each{|s|
        BirkmanJobInterest.create({:statement=> s, :set_number => q[:set_no]})
      }
    end
  }
end
populate_question_set_three()
### end -- populate question set 3 ####

### Added for notification type ###

@notification_type_list = ["Profile", "Downloads", "Opportunities", "Analytics", "Account"]
def populate_notification_type

  for notification_type in @notification_type_list
    _notification_type = NotificationType.find_by_name(notification_type)
    if _notification_type.blank?
      NotificationType.create({:name=>notification_type})
    end
  end
end

populate_notification_type()

### Notification Type End ###

### Added for notification Messages ###

@notification_message_list = ["You must complete your profile to be visible to employers.", "View and download your Career Forward Guide.", "Put interesting opportunities into your watchlist for later review.", "Access the entire database through our graphic user interface."]
def populate_notification_message

  for notification_message in @notification_message_list
    _notification_message = NotificationMessage.find_by_message(notification_message)
    if _notification_message.blank?
      NotificationMessage.create({:message=>notification_message})
    end
  end

  _notification_message = NotificationMessage.find_by_message("purchased your profile for a")
  if _notification_message.blank?
    new_message = NotificationMessage.new(:message=>"purchased your profile for a", :link=>"showJobForNotification")
    new_message.save
  end

  _notification_message = NotificationMessage.find_by_message("posted a new position for a")
  if _notification_message.blank?
    new_message = NotificationMessage.new(:message=>"posted a new position for a", :link=>"showJobForNotification")
    new_message.save
  end

  _notification_message = NotificationMessage.find_by_message("You are a")
  if _notification_message.blank?
    new_message = NotificationMessage.new(:message=>"You are a", :link=>"showJobForNotification")
    new_message.save
  end

  _notification_message = NotificationMessage.find_by_message("You were actually a")
  if _notification_message.blank?
    new_message = NotificationMessage.new(:message=>"You were actually a", :link=>"showJobForNotification")
    new_message.save
  end

  _notification_message = NotificationMessage.find_by_message("Update your information on the redesigned CREDENTIALS section.")
  if _notification_message.blank?
    new_message = NotificationMessage.new(:message=>"Update your information on the redesigned CREDENTIALS section.", :link=>"openCredentialsForUpdate()")
    new_message.save
  end
	
  e = NotificationMessage.find_by_message("View and download your Career Forward Guide.");
	if not e.nil?
		e.link = "birkman_report.request_pdf()"
		e.save
	end

  _notification_message = NotificationMessage.find_by_message("Best Fit")
  if _notification_message.blank?
    new_message = NotificationMessage.new(:message=>"Best Fit")
    new_message.save
  end

  _notification_message = NotificationMessage.find_by_message("Better Fit")
  if _notification_message.blank?
    new_message = NotificationMessage.new(:message=>"Better Fit")
    new_message.save
  end

  _notification_message = NotificationMessage.find_by_message("Good Fit")
  if _notification_message.blank?
    new_message = NotificationMessage.new(:message=>"Good Fit")
    new_message.save
  end

  _notification_message = NotificationMessage.find_by_message("Position Closed")
  if _notification_message.blank?
    new_message = NotificationMessage.new(:message=>"Position Closed")
    new_message.save
  end

  _notification_message = NotificationMessage.find_by_message("Best Fit-Edit")
  if _notification_message.blank?
    new_message = NotificationMessage.new(:message=>"Best Fit-Edit")
    new_message.save
  end

  _notification_message = NotificationMessage.find_by_message("Better Fit-Edit")
  if _notification_message.blank?
    new_message = NotificationMessage.new(:message=>"Better Fit-Edit")
    new_message.save
  end

  _notification_message = NotificationMessage.find_by_message("Good Fit-Edit")
  if _notification_message.blank?
    new_message = NotificationMessage.new(:message=>"Good Fit-Edit")
    new_message.save
  end

  _notification_message = NotificationMessage.find_by_message("Following-Edit")
  if _notification_message.blank?
    new_message = NotificationMessage.new(:message=>"Following-Edit")
    new_message.save
  end
end

populate_notification_message()

### Notification Type End ###

### Initial Administrator Account
def add_admin
  admin = Administrator.find_by_email("chris@thehiloproject.com")
  if admin.nil?
    Administrator.create(:email=>"chris@thehiloproject.com", :password=>"admin123", :first_name=> "Christopher", :last_name=> "Getner", :active=>false)
  end
  admin = Administrator.find_by_email("amit.gupta2@globallogic.com")
  if admin.nil?
    Administrator.create(:email=>"amit.gupta2@globallogic.com", :password=>"admin123", :first_name=> "Amit", :last_name=> "Gupta", :active=>false)
  end
end

add_admin()