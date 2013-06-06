CREATE TABLE `abilities` (
  `onetsoc_code` char(10) collate utf8_bin NOT NULL,
  `element_id` varchar(20) collate utf8_bin NOT NULL,
  `scale_id` varchar(3) collate utf8_bin NOT NULL,
  `data_value` decimal(5,2) NOT NULL,
  `n` decimal(4,0) default NULL,
  `standard_error` decimal(5,2) default NULL,
  `lower_ci_bound` decimal(5,2) default NULL,
  `upper_ci_bound` decimal(5,2) default NULL,
  `recommend_suppress` char(1) collate utf8_bin default NULL,
  `not_relevant` char(1) collate utf8_bin default NULL,
  `date_updated` date NOT NULL,
  `domain_source` varchar(30) collate utf8_bin NOT NULL,
  KEY `onetsoc_code` (`onetsoc_code`),
  KEY `element_id` (`element_id`),
  KEY `scale_id` (`scale_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `access_levels` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `account_types` (
  `id` int(11) NOT NULL auto_increment,
  `account_type` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `added_degrees` (
  `id` int(11) NOT NULL auto_increment,
  `adder_id` int(11) default NULL,
  `adder_type` varchar(255) collate utf8_unicode_ci default NULL,
  `degree_id` int(11) default NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `degree_status` varchar(255) collate utf8_unicode_ci default NULL,
  `required_flag` tinyint(1) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=588 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `added_roles` (
  `id` int(11) NOT NULL auto_increment,
  `adder_id` int(11) default NULL,
  `adder_type` varchar(255) collate utf8_unicode_ci default NULL,
  `code` varchar(255) collate utf8_unicode_ci default '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `education_experience` varchar(255) collate utf8_unicode_ci default NULL,
  `experience_level_id` int(11) default NULL,
  `education_level_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8494 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `added_universities` (
  `id` int(11) NOT NULL auto_increment,
  `adder_id` int(11) default NULL,
  `adder_type` varchar(255) collate utf8_unicode_ci default NULL,
  `university_id` int(11) default NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=421 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `admin_access_levels` (
  `id` int(11) NOT NULL auto_increment,
  `administrator_id` int(11) default NULL,
  `access_level_id` int(11) default NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `administrators` (
  `id` int(11) NOT NULL auto_increment,
  `email` varchar(255) collate utf8_unicode_ci default NULL,
  `password_digest` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `first_name` varchar(255) collate utf8_unicode_ci default NULL,
  `last_name` varchar(255) collate utf8_unicode_ci default NULL,
  `active` tinyint(1) default NULL,
  `access_level_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `admins` (
  `id` int(11) NOT NULL auto_increment,
  `first_name` varchar(255) collate utf8_unicode_ci default NULL,
  `last_name` varchar(255) collate utf8_unicode_ci default NULL,
  `email` varchar(255) collate utf8_unicode_ci default NULL,
  `hashed_password` text collate utf8_unicode_ci,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `alerts` (
  `id` int(11) NOT NULL auto_increment,
  `job_seeker_id` int(11) default NULL,
  `text` text collate utf8_unicode_ci,
  `url` varchar(255) collate utf8_unicode_ci default NULL,
  `deleted` tinyint(1) default '0',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `audits` (
  `id` int(11) NOT NULL auto_increment,
  `auditable_id` int(11) default NULL,
  `auditable_type` varchar(255) collate utf8_unicode_ci default NULL,
  `user_id` int(11) default NULL,
  `user_type` varchar(255) collate utf8_unicode_ci default NULL,
  `username` varchar(255) collate utf8_unicode_ci default NULL,
  `action` varchar(255) collate utf8_unicode_ci default NULL,
  `audited_changes` text collate utf8_unicode_ci,
  `version` int(11) default '0',
  `created_at` datetime default NULL,
  `comment` varchar(255) collate utf8_unicode_ci default NULL,
  `remote_address` varchar(255) collate utf8_unicode_ci default NULL,
  `associated_id` int(11) default NULL,
  `associated_type` varchar(255) collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`id`),
  KEY `auditable_index` (`auditable_id`,`auditable_type`),
  KEY `user_index` (`user_id`,`user_type`),
  KEY `index_audits_on_created_at` (`created_at`),
  KEY `associated_index` (`associated_id`,`associated_type`)
) ENGINE=InnoDB AUTO_INCREMENT=57284 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `birkman_job_interest_responses` (
  `id` int(11) NOT NULL auto_increment,
  `birkman_job_interest_id` int(11) default NULL,
  `job_seeker_id` int(11) default NULL,
  `choice` varchar(15) collate utf8_unicode_ci default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26300 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `birkman_job_interest_translations` (
  `id` int(11) NOT NULL auto_increment,
  `birkman_job_interest_id` int(11) default NULL,
  `locale` varchar(255) collate utf8_unicode_ci default NULL,
  `statement` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `index_4f7a136d4b77981834bfa0644b268eafda7a3358` (`birkman_job_interest_id`),
  KEY `index_birkman_job_interest_translations_on_locale` (`locale`)
) ENGINE=InnoDB AUTO_INCREMENT=193 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `birkman_job_interests` (
  `id` int(11) NOT NULL auto_increment,
  `statement` varchar(255) collate utf8_unicode_ci default NULL,
  `set_number` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=193 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `birkman_question_responses` (
  `id` int(11) NOT NULL auto_increment,
  `job_seeker_id` int(11) default NULL,
  `birkman_question_id` int(11) default NULL,
  `response` tinyint(1) default '0',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=73891 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `birkman_question_translations` (
  `id` int(11) NOT NULL auto_increment,
  `birkman_question_id` int(11) default NULL,
  `locale` varchar(255) collate utf8_unicode_ci default NULL,
  `question` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `index_birkman_question_translations_on_birkman_question_id` (`birkman_question_id`),
  KEY `index_birkman_question_translations_on_locale` (`locale`)
) ENGINE=InnoDB AUTO_INCREMENT=251 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `birkman_questions` (
  `id` int(11) NOT NULL auto_increment,
  `question` varchar(255) collate utf8_unicode_ci default NULL,
  `set_number` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=251 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `career_cluster` (
  `career_cluster` varchar(255) collate utf8_bin NOT NULL,
  `pathway` varchar(255) collate utf8_bin NOT NULL,
  `code` char(10) collate utf8_bin NOT NULL,
  `descripton` varchar(255) collate utf8_bin NOT NULL,
  FULLTEXT KEY `career_cluster` (`career_cluster`,`pathway`,`descripton`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `career_seeker_saved_searches` (
  `id` int(11) NOT NULL auto_increment,
  `job_seeker_id` int(11) default NULL,
  `keyword` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `deleted` tinyint(1) default '0',
  `name` varchar(255) collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `certificates` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `activated` tinyint(1) default '0',
  `created_by` int(11) default NULL,
  `user_type` varchar(255) collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=375 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `channel_managers` (
  `id` int(11) NOT NULL auto_increment,
  `job_id` int(11) default NULL,
  `facebook_count` int(11) default '0',
  `linkedin_count` int(11) default '0',
  `twitter_count` int(11) default '0',
  `url_count` int(11) default '0',
  `hilo_count` int(11) default '0',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1155 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `coderequests` (
  `id` int(11) NOT NULL auto_increment,
  `email` varchar(255) collate utf8_unicode_ci default NULL,
  `promotional_code_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=548 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `companies` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `street_one` varchar(255) collate utf8_unicode_ci default NULL,
  `street_two` varchar(255) collate utf8_unicode_ci default NULL,
  `city` varchar(255) collate utf8_unicode_ci default NULL,
  `zip` varchar(255) collate utf8_unicode_ci default NULL,
  `state_id` int(11) default NULL,
  `phone` varchar(255) collate utf8_unicode_ci default NULL,
  `fax` varchar(255) collate utf8_unicode_ci default NULL,
  `founded_in` varchar(255) collate utf8_unicode_ci default NULL,
  `employee_strength` int(11) default NULL,
  `website` varchar(255) collate utf8_unicode_ci default NULL,
  `facebook_link` varchar(255) collate utf8_unicode_ci default NULL,
  `twitter_link` varchar(255) collate utf8_unicode_ci default NULL,
  `other_link_one` varchar(255) collate utf8_unicode_ci default NULL,
  `other_link_two` varchar(255) collate utf8_unicode_ci default NULL,
  `owner_ship_type_id` int(11) default NULL,
  `ticker_value` varchar(255) collate utf8_unicode_ci default NULL,
  `created_by` int(11) default NULL,
  `country` varchar(255) collate utf8_unicode_ci default NULL,
  `state` varchar(255) collate utf8_unicode_ci default NULL,
  `random_token` varchar(255) collate utf8_unicode_ci default NULL,
  `hilo_subscription` tinyint(1) default '0',
  `graphical_content` tinyint(1) default '1',
  `deleted_at` time default NULL,
  `ancestry` varchar(255) collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_companies_on_ancestry` (`ancestry`)
) ENGINE=InnoDB AUTO_INCREMENT=136 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `company_domains` (
  `id` int(11) NOT NULL auto_increment,
  `company_id` int(11) default NULL,
  `domain` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `company_groups` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_unicode_ci default NULL,
  `company_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `deleted` tinyint(1) default '0',
  `sort_index` int(11) default NULL,
  `employer_id` int(11) default NULL,
  `old_employer_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=418 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `company_postings` (
  `id` int(11) NOT NULL auto_increment,
  `company_id` int(11) default NULL,
  `hilo_count` int(11) default '0',
  `facebook_count` int(11) default '0',
  `twitter_count` int(11) default '0',
  `linkedin_count` int(11) default '0',
  `url_count` int(11) default '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `facebook_flag` tinyint(1) default '0',
  `linkedin_flag` tinyint(1) default '0',
  `twitter_flag` tinyint(1) default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=114 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `content_model_references` (
  `element_id` varchar(20) NOT NULL,
  `element_name` varchar(150) NOT NULL,
  `description` varchar(1500) NOT NULL,
  PRIMARY KEY  (`element_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `corporate_accounts` (
  `id` int(11) NOT NULL auto_increment,
  `first_name` varchar(255) collate utf8_unicode_ci default NULL,
  `last_name` varchar(255) collate utf8_unicode_ci default NULL,
  `email` varchar(255) collate utf8_unicode_ci default NULL,
  `company_name` varchar(255) collate utf8_unicode_ci default NULL,
  `contact` bigint(20) default NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `is_approved` tinyint(1) default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `countries` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_unicode_ci default NULL,
  `alpha2` varchar(255) collate utf8_unicode_ci default NULL,
  `alpha3` varchar(255) collate utf8_unicode_ci default NULL,
  `numeric` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=246 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `creative_samples` (
  `id` int(11) NOT NULL auto_increment,
  `type` varchar(255) collate utf8_unicode_ci default NULL,
  `upload_file_name` varchar(255) collate utf8_unicode_ci default NULL,
  `upload_content_type` varchar(255) collate utf8_unicode_ci default NULL,
  `upload_file_size` int(11) default NULL,
  `url` varchar(500) collate utf8_unicode_ci default NULL,
  `job_seeker_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `caption` varchar(255) collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `credits` (
  `id` int(11) NOT NULL auto_increment,
  `job_seeker_id` int(11) default NULL,
  `credit_value` float default '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=265 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `degrees` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `value` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `delayed_jobs` (
  `id` int(11) NOT NULL auto_increment,
  `priority` int(11) default '0',
  `attempts` int(11) default '0',
  `handler` text collate utf8_unicode_ci,
  `last_error` text collate utf8_unicode_ci,
  `run_at` datetime default NULL,
  `locked_at` datetime default NULL,
  `failed_at` datetime default NULL,
  `locked_by` varchar(255) collate utf8_unicode_ci default NULL,
  `queue` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `delayed_jobs_priority` (`priority`,`run_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `desired_employments` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `desired_locations` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `education_levels` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `score` float default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `education_training_experience` (
  `onetsoc_code` char(10) collate utf8_bin NOT NULL,
  `element_id` varchar(20) collate utf8_bin NOT NULL,
  `scale_id` varchar(3) collate utf8_bin NOT NULL,
  `category` decimal(3,0) default NULL,
  `data_value` decimal(5,2) NOT NULL,
  `n` decimal(4,0) default NULL,
  `standard_error` decimal(5,2) default NULL,
  `lower_ci_bound` decimal(5,2) default NULL,
  `upper_ci_bound` decimal(5,2) default NULL,
  `recommend_suppress` char(1) collate utf8_bin default NULL,
  `date_updated` date NOT NULL,
  `domain_source` varchar(30) collate utf8_bin NOT NULL,
  KEY `onetsoc_code` (`onetsoc_code`),
  KEY `scale_id` (`scale_id`),
  KEY `element_id` (`element_id`,`scale_id`,`category`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `employer_alerts` (
  `id` int(11) NOT NULL auto_increment,
  `job_id` int(11) default NULL,
  `job_seeker_id` int(11) default NULL,
  `purpose` varchar(255) collate utf8_unicode_ci default NULL,
  `read` tinyint(1) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `new` tinyint(1) default '1',
  `employer_id` bigint(20) default NULL,
  `deleted_employer_id` int(11) default NULL,
  `employer_job_activity` int(11) default NULL,
  `company_group_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2472 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `employer_privileges` (
  `id` int(11) NOT NULL auto_increment,
  `company_id` int(11) default NULL,
  `status` tinyint(1) default '0',
  `credit_value` float default '0',
  `discount_value` float default '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `employer_saved_searches` (
  `id` int(11) NOT NULL auto_increment,
  `employer_id` int(11) default NULL,
  `keyword` varchar(255) collate utf8_unicode_ci default NULL,
  `name` varchar(255) collate utf8_unicode_ci default NULL,
  `deleted` tinyint(1) default '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `employer_view_job_seekers` (
  `id` int(11) NOT NULL auto_increment,
  `job_seeker_id` int(11) default NULL,
  `employer_id` int(11) default NULL,
  `job_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `employers` (
  `id` int(11) NOT NULL auto_increment,
  `company_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `first_name` varchar(255) collate utf8_unicode_ci default NULL,
  `last_name` varchar(255) collate utf8_unicode_ci default NULL,
  `email` varchar(255) collate utf8_unicode_ci default NULL,
  `hashed_password` varchar(255) collate utf8_unicode_ci default NULL,
  `phone_one` varchar(255) collate utf8_unicode_ci default NULL,
  `phone_two` varchar(255) collate utf8_unicode_ci default NULL,
  `contact_email` varchar(255) collate utf8_unicode_ci default NULL,
  `zip_code` varchar(255) collate utf8_unicode_ci default NULL,
  `preferred_contact` varchar(255) collate utf8_unicode_ci default NULL,
  `completed_registration_step` int(11) default NULL,
  `activated` tinyint(1) default '0',
  `role_id` int(11) default NULL,
  `fpwd_code` varchar(255) collate utf8_unicode_ci default NULL,
  `last_login` datetime default NULL,
  `emp_admin` int(11) default NULL,
  `advanced_alert` tinyint(1) default '0',
  `alert_threshold` int(11) default '3',
  `alert_method` int(11) default '4',
  `notification_email_time` datetime default NULL,
  `ancestry` varchar(255) collate utf8_unicode_ci default NULL,
  `account_type_id` int(11) default '3',
  `deleted` tinyint(1) default '0',
  `suspended` tinyint(1) default '0',
  `tree_suspended` tinyint(1) default '0',
  `spending_flag` tinyint(1) default '0',
  `monthly_renew_flag` tinyint(1) default '0',
  `spending_limit_crossed_flag` tinyint(1) default '0',
  `monthly_renew_time` datetime default NULL,
  `request_deleted` tinyint(1) default '0',
  `nominated_employer_id` int(11) default NULL,
  `deleted_at` time default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_employers_on_ancestry` (`ancestry`)
) ENGINE=InnoDB AUTO_INCREMENT=204 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `ete_categories` (
  `element_id` varchar(20) NOT NULL,
  `scale_id` varchar(3) NOT NULL,
  `category` decimal(3,0) NOT NULL,
  `category_description` varchar(1000) NOT NULL,
  PRIMARY KEY  (`element_id`,`scale_id`,`category`),
  KEY `scale_id` (`scale_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `experience_levels` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_unicode_ci default NULL,
  `score` float default NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `gifts` (
  `id` int(11) NOT NULL auto_increment,
  `sender_name` varchar(255) collate utf8_unicode_ci default NULL,
  `sender_email` varchar(255) collate utf8_unicode_ci default NULL,
  `recipient_email` varchar(255) collate utf8_unicode_ci default NULL,
  `mail_text` text collate utf8_unicode_ci,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `promotional_code_id` int(11) default NULL,
  `recipient_name` varchar(255) collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `green_occupations` (
  `onetsoc_code` char(10) collate utf8_bin NOT NULL,
  `green_occupational_category` varchar(40) collate utf8_bin NOT NULL,
  KEY `onetsoc_code` (`onetsoc_code`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `green_task_statements` (
  `onetsoc_code` char(10) collate utf8_bin NOT NULL,
  `task_id` decimal(8,0) NOT NULL,
  `green_task_type` varchar(40) collate utf8_bin NOT NULL,
  KEY `onetsoc_code` (`onetsoc_code`),
  KEY `task_id` (`task_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `guest_job_seeker_workenv_questions` (
  `id` int(11) NOT NULL auto_increment,
  `guest_job_seeker_id` int(11) default NULL,
  `workenv_question_id` int(11) default NULL,
  `score` int(11) default NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=521 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `guest_job_seekers` (
  `id` int(11) NOT NULL auto_increment,
  `email` varchar(255) collate utf8_unicode_ci default NULL,
  `unique_identifier` varchar(255) collate utf8_unicode_ci default NULL,
  `birkman_user_id` varchar(255) collate utf8_unicode_ci default NULL,
  `responded_birkman_question_id` int(11) default NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `test_complete` tinyint(1) default NULL,
  `responded_birkman_set_number` int(11) default NULL,
  `us_citizen` mediumint(9) default NULL,
  `test_submitted` tinyint(1) default NULL,
  `grid_work_environment_x` mediumint(9) default NULL,
  `grid_work_environment_y` mediumint(9) default NULL,
  `grid_work_role_x` mediumint(9) default NULL,
  `grid_work_role_y` mediumint(9) default NULL,
  `pdf_saved` tinyint(1) default '0',
  `promo_code_sent` tinyint(1) default '0',
  `no_result_flag` tinyint(1) default '0',
  `js_work_env` varchar(255) collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `ics_types` (
  `id` int(11) NOT NULL auto_increment,
  `type` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `interests` (
  `onetsoc_code` char(10) collate utf8_bin NOT NULL,
  `element_id` varchar(20) collate utf8_bin NOT NULL,
  `scale_id` varchar(3) collate utf8_bin NOT NULL,
  `data_value` decimal(5,2) NOT NULL,
  `date_updated` date NOT NULL,
  `domain_source` varchar(30) collate utf8_bin NOT NULL,
  KEY `onetsoc_code` (`onetsoc_code`),
  KEY `element_id` (`element_id`),
  KEY `scale_id` (`scale_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `job_attachments` (
  `id` int(11) NOT NULL auto_increment,
  `job_id` int(11) default NULL,
  `attachment_file_name` varchar(255) collate utf8_unicode_ci default NULL,
  `attachment_content_type` varchar(255) collate utf8_unicode_ci default NULL,
  `attachment_file_size` int(11) default NULL,
  `attachment_title` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=82 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `job_criteria_certificates` (
  `id` int(11) NOT NULL auto_increment,
  `job_id` int(11) default NULL,
  `certificate_id` int(11) default NULL,
  `required_flag` tinyint(1) default '0',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `new_certificate_id` int(11) default NULL,
  `license_id` int(11) default NULL,
  `order` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=229 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `job_criteria_degrees` (
  `id` int(11) NOT NULL auto_increment,
  `job_id` int(11) default NULL,
  `degree_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `job_criteria_desired_employments` (
  `id` int(11) NOT NULL auto_increment,
  `job_id` int(11) default NULL,
  `desired_employment_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3945 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `job_criteria_desired_locations` (
  `id` int(11) NOT NULL auto_increment,
  `job_id` int(11) default NULL,
  `desired_location_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `job_criteria_languages` (
  `id` int(11) NOT NULL auto_increment,
  `job_id` int(11) default NULL,
  `language_id` int(11) default NULL,
  `proficiency_val` varchar(10) collate utf8_unicode_ci default NULL,
  `required_flag` tinyint(1) default '0',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3633 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `job_criteria_proficiencies` (
  `id` int(11) NOT NULL auto_increment,
  `job_id` int(11) default NULL,
  `proficiency_id` int(11) default NULL,
  `proficiency_val` varchar(10) collate utf8_unicode_ci default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=704 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `job_locations` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_unicode_ci default NULL,
  `country_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `street_one` varchar(255) collate utf8_unicode_ci default NULL,
  `street_two` varchar(255) collate utf8_unicode_ci default NULL,
  `city` varchar(255) collate utf8_unicode_ci default NULL,
  `zip_code` varchar(255) collate utf8_unicode_ci default NULL,
  `latitude` float default NULL,
  `longitude` float default NULL,
  `state` varchar(255) collate utf8_unicode_ci default NULL,
  `country` varchar(255) collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3663 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `job_profile_responsibilities` (
  `id` int(11) NOT NULL auto_increment,
  `job_id` int(11) default NULL,
  `profile_responsibility_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6524 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `job_role_questions` (
  `id` int(11) NOT NULL auto_increment,
  `role_question_id` int(11) default NULL,
  `job_id` int(11) default NULL,
  `score` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5926 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `job_seeker_awards` (
  `id` int(11) NOT NULL auto_increment,
  `job_seeker_id` int(11) default NULL,
  `title` varchar(500) collate utf8_unicode_ci default NULL,
  `upload_file_name` varchar(255) collate utf8_unicode_ci default NULL,
  `upload_content_type` varchar(255) collate utf8_unicode_ci default NULL,
  `upload_file_size` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `job_seeker_birkman_details` (
  `id` int(11) NOT NULL auto_increment,
  `job_seeker_id` int(11) default NULL,
  `unique_identifier` varchar(255) collate utf8_unicode_ci default NULL,
  `questionnaire_url` varchar(255) collate utf8_unicode_ci default NULL,
  `birkman_user_id` varchar(255) collate utf8_unicode_ci default NULL,
  `status` varchar(255) collate utf8_unicode_ci default NULL,
  `last_log` text collate utf8_unicode_ci,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `test_complete` tinyint(1) default '0',
  `pdf_saved` tinyint(1) default '0',
  `grid_work_environment_x` int(11) default NULL,
  `grid_work_environment_y` int(11) default NULL,
  `grid_work_role_x` int(11) default NULL,
  `grid_work_role_y` int(11) default NULL,
  `responded_birkman_question_id` int(11) default NULL,
  `responded_birkman_set_number` int(11) default NULL,
  `us_citizen` tinyint(1) default '0',
  `test_submitted` tinyint(1) default '0',
  `pass_through` tinyint(1) default '0',
  `pass_first_name` varchar(255) collate utf8_unicode_ci default NULL,
  `pass_last_name` varchar(255) collate utf8_unicode_ci default NULL,
  `pass_email` varchar(255) collate utf8_unicode_ci default NULL,
  `pass_birkman_code` varchar(255) collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `job_seeker_certificates` (
  `id` int(11) NOT NULL auto_increment,
  `job_seeker_id` int(11) default NULL,
  `certificate_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `new_certificate_id` int(11) default NULL,
  `license_id` int(11) default NULL,
  `order` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=650 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `job_seeker_certifications` (
  `id` int(11) NOT NULL auto_increment,
  `job_seeker_id` int(11) default NULL,
  `title` varchar(255) collate utf8_unicode_ci default NULL,
  `upload_file_name` varchar(255) collate utf8_unicode_ci default NULL,
  `upload_content_type` varchar(255) collate utf8_unicode_ci default NULL,
  `upload_file_size` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `new_certificate_id` int(11) default NULL,
  `license_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `job_seeker_degrees` (
  `id` int(11) NOT NULL auto_increment,
  `job_seeker_id` int(11) default NULL,
  `degree_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `job_seeker_desired_employments` (
  `id` int(11) NOT NULL auto_increment,
  `job_seeker_id` int(11) default NULL,
  `desired_employment_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1108 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `job_seeker_desired_locations` (
  `id` int(11) NOT NULL auto_increment,
  `job_seeker_id` int(11) default NULL,
  `desired_location_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `pincode` varchar(255) collate utf8_unicode_ci default NULL,
  `latitude` float default NULL,
  `longitude` float default NULL,
  `city` varchar(255) collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=521 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `job_seeker_education_levels` (
  `id` int(11) NOT NULL auto_increment,
  `job_seeker_id` int(11) default NULL,
  `education_level_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `job_seeker_follow_companies` (
  `id` int(11) NOT NULL auto_increment,
  `job_seeker_id` int(11) default NULL,
  `company_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=177 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `job_seeker_languages` (
  `id` int(11) NOT NULL auto_increment,
  `job_seeker_id` int(11) default NULL,
  `language_id` int(11) default NULL,
  `proficiency_val` varchar(10) collate utf8_unicode_ci default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=886 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `job_seeker_links` (
  `id` int(11) NOT NULL auto_increment,
  `job_seeker_id` int(11) default NULL,
  `url` text collate utf8_unicode_ci,
  `description` text collate utf8_unicode_ci,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `job_seeker_notifications` (
  `id` int(11) NOT NULL auto_increment,
  `job_seeker_id` int(11) default NULL,
  `notification_type_id` int(11) default NULL,
  `notification_message_id` int(11) default NULL,
  `visibility` tinyint(1) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `new` tinyint(1) default '1',
  `job_id` int(11) default NULL,
  `company_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14423 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `job_seeker_proficiencies` (
  `id` int(11) NOT NULL auto_increment,
  `job_seeker_id` int(11) default NULL,
  `proficiency_id` int(11) default NULL,
  `proficiency_val` varchar(10) collate utf8_unicode_ci default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `education_id` int(11) default NULL,
  `skill_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1102 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `job_seeker_skill_levels` (
  `id` int(11) NOT NULL auto_increment,
  `job_seeker_id` int(11) default NULL,
  `skill_level_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `job_seeker_watchlists` (
  `id` int(11) NOT NULL auto_increment,
  `job_seeker_id` int(11) default NULL,
  `job_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=155 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `job_seeker_workenv_questions` (
  `id` int(11) NOT NULL auto_increment,
  `job_seeker_id` int(11) default NULL,
  `workenv_question_id` int(11) default NULL,
  `score` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5186 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `job_seekers` (
  `id` int(11) NOT NULL auto_increment,
  `first_name` varchar(255) collate utf8_unicode_ci default NULL,
  `last_name` varchar(255) collate utf8_unicode_ci default NULL,
  `email` varchar(255) collate utf8_unicode_ci default NULL,
  `hashed_password` text collate utf8_unicode_ci,
  `phone_one` varchar(255) collate utf8_unicode_ci default NULL,
  `phone_two` varchar(255) collate utf8_unicode_ci default NULL,
  `contact_email` varchar(255) collate utf8_unicode_ci default NULL,
  `activated` tinyint(1) default '0',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `completed_registration_step` int(11) default NULL,
  `minimum_compensation_amount` float default '0',
  `desired_paid_offs` int(11) default '0',
  `desired_commute_radius` int(11) default '0',
  `work_exp_value` int(11) default '0',
  `video_url` varchar(255) collate utf8_unicode_ci default NULL,
  `summary` text collate utf8_unicode_ci,
  `preferred_contact` varchar(255) collate utf8_unicode_ci default NULL,
  `photo_file_name` varchar(255) collate utf8_unicode_ci default NULL,
  `photo_content_type` varchar(255) collate utf8_unicode_ci default NULL,
  `photo_file_size` int(11) default NULL,
  `resume_file_name` varchar(255) collate utf8_unicode_ci default NULL,
  `resume_content_type` varchar(255) collate utf8_unicode_ci default NULL,
  `resume_file_size` int(11) default NULL,
  `zip_code` varchar(255) collate utf8_unicode_ci default NULL,
  `fpwd_code` varchar(255) collate utf8_unicode_ci default NULL,
  `last_login` datetime default NULL,
  `armed_forces` tinyint(1) default '0',
  `area_code` varchar(255) collate utf8_unicode_ci default NULL,
  `js_admin` int(11) default NULL,
  `website_one` varchar(255) collate utf8_unicode_ci default NULL,
  `website_two` varchar(255) collate utf8_unicode_ci default NULL,
  `website_three` varchar(255) collate utf8_unicode_ci default NULL,
  `website_title_one` varchar(255) collate utf8_unicode_ci default NULL,
  `website_title_two` varchar(255) collate utf8_unicode_ci default NULL,
  `website_title_three` varchar(255) collate utf8_unicode_ci default NULL,
  `follow_check` tinyint(1) default '0',
  `city` varchar(255) collate utf8_unicode_ci default NULL,
  `advanced_alert` tinyint(1) default '0',
  `track_shared_job_id` varchar(255) collate utf8_unicode_ci default NULL,
  `bridge_response` varchar(255) collate utf8_unicode_ci default NULL,
  `track_platform_id` int(11) default NULL,
  `alert_threshold` int(11) default '3',
  `alert_method` int(11) default '4',
  `notification_email_time` datetime default NULL,
  `track_shared_company_id` varchar(255) collate utf8_unicode_ci default NULL,
  `ics_type_id` int(11) default '4',
  `company_id` int(11) default NULL,
  `email_verified` tinyint(1) default '1',
  `password_reset` tinyint(1) default '1',
  `deleted` tinyint(1) default '0',
  `request_deleted` tinyint(1) default '0',
  `deleted_at` time default NULL,
  `linkedin_crawl_data` text collate utf8_unicode_ci,
  `maximum_compensation_amount` float default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=621 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `job_statuses` (
  `id` int(11) NOT NULL auto_increment,
  `job_seeker_id` int(11) default NULL,
  `job_id` int(11) default NULL,
  `follow` tinyint(1) default NULL,
  `read` tinyint(1) default NULL,
  `considering` tinyint(1) default NULL,
  `interested` tinyint(1) default NULL,
  `wild_card` tinyint(1) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `archived` tinyint(1) default '0',
  `considered_on` datetime default NULL,
  `interested_on` datetime default NULL,
  `wildcard_on` datetime default NULL,
  `read_on` datetime default NULL,
  `cover_note` text collate utf8_unicode_ci,
  `deleted_at` time default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1133 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `job_workenv_questions` (
  `id` int(11) NOT NULL auto_increment,
  `workenv_question_id` int(11) default NULL,
  `job_id` int(11) default NULL,
  `score` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3951 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `job_zone_reference` (
  `job_zone` decimal(1,0) NOT NULL,
  `name` varchar(50) NOT NULL,
  `experience` varchar(300) NOT NULL,
  `education` varchar(500) NOT NULL,
  `job_training` varchar(300) NOT NULL,
  `examples` varchar(500) NOT NULL,
  `svp_range` varchar(25) NOT NULL,
  PRIMARY KEY  (`job_zone`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `job_zones` (
  `onetsoc_code` char(10) collate utf8_bin NOT NULL,
  `job_zone` decimal(1,0) NOT NULL,
  `date_updated` date NOT NULL,
  `domain_source` varchar(30) collate utf8_bin NOT NULL,
  KEY `onetsoc_code` (`onetsoc_code`),
  KEY `job_zone` (`job_zone`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `jobs` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_unicode_ci default NULL,
  `code` varchar(255) collate utf8_unicode_ci default NULL,
  `position` varchar(255) collate utf8_unicode_ci default NULL,
  `job_location_id` int(11) default NULL,
  `expire_at` datetime default NULL,
  `employer_id` int(11) default NULL,
  `marks` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `summary` text collate utf8_unicode_ci,
  `company_group_id` int(11) default NULL,
  `active` tinyint(1) default '0',
  `minimum_compensation_amount` float default '0',
  `desired_paid_offs` int(11) default '0',
  `desired_commute_radius` int(11) default '0',
  `work_exp_value` int(11) default '0',
  `basic_complete` tinyint(1) default '0',
  `credential_complete` tinyint(1) default '0',
  `personality_work_complete` tinyint(1) default '0',
  `personality_role_complete` tinyint(1) default '0',
  `overview_complete` tinyint(1) default '0',
  `detail_preview` tinyint(1) default '0',
  `grid_work_environment_x` int(11) default NULL,
  `grid_work_environment_y` int(11) default NULL,
  `grid_work_role_x` int(11) default NULL,
  `grid_work_role_y` int(11) default NULL,
  `company_id` int(11) default NULL,
  `deleted` tinyint(1) default '0',
  `sort_index` int(11) default NULL,
  `profile_complete` tinyint(1) default '0',
  `remote_work` tinyint(1) default NULL,
  `armed_forces` tinyint(1) default '1',
  `hiring_company` tinyint(1) default '1',
  `hiring_company_name` varchar(255) collate utf8_unicode_ci default NULL,
  `website_one` varchar(255) collate utf8_unicode_ci default NULL,
  `website_two` varchar(255) collate utf8_unicode_ci default NULL,
  `website_three` varchar(255) collate utf8_unicode_ci default NULL,
  `website_title_one` varchar(255) collate utf8_unicode_ci default NULL,
  `website_title_two` varchar(255) collate utf8_unicode_ci default NULL,
  `website_title_three` varchar(255) collate utf8_unicode_ci default NULL,
  `deactivated_for_new_credential` tinyint(1) default NULL,
  `internal` tinyint(1) default '0',
  `deleted_at` time default NULL,
  `old_employer_id` int(11) default NULL,
  `job_link` varchar(255) collate utf8_unicode_ci default NULL,
  `vendor_job_id` varchar(255) collate utf8_unicode_ci default NULL,
  `vendor_name` varchar(255) collate utf8_unicode_ci default NULL,
  `xml_import_pairing_logic` tinyint(1) default '0',
  `salary_not_disclosed` tinyint(1) default '0',
  `locked` tinyint(1) default '0',
  `maximum_compensation_amount` float default '0',
  `first_active` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3365 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `knowledge` (
  `onetsoc_code` char(10) collate utf8_bin NOT NULL,
  `element_id` varchar(20) collate utf8_bin NOT NULL,
  `scale_id` varchar(3) collate utf8_bin NOT NULL,
  `data_value` decimal(5,2) NOT NULL,
  `n` decimal(4,0) default NULL,
  `standard_error` decimal(5,2) default NULL,
  `lower_ci_bound` decimal(5,2) default NULL,
  `upper_ci_bound` decimal(5,2) default NULL,
  `recommend_suppress` char(1) collate utf8_bin default NULL,
  `not_relevant` char(1) collate utf8_bin default NULL,
  `date_updated` date NOT NULL,
  `domain_source` varchar(30) collate utf8_bin NOT NULL,
  KEY `onetsoc_code` (`onetsoc_code`),
  KEY `element_id` (`element_id`),
  KEY `scale_id` (`scale_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `languages` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `lay_titles` (
  `id` int(11) NOT NULL auto_increment,
  `soc_code` varchar(255) collate utf8_unicode_ci default NULL,
  `soc_title` varchar(255) collate utf8_unicode_ci default NULL,
  `onetsoc_code` varchar(255) collate utf8_unicode_ci default NULL,
  `onetsoc_title` varchar(255) collate utf8_unicode_ci default NULL,
  `lay_title` varchar(255) collate utf8_unicode_ci default NULL,
  `title_type` varchar(255) collate utf8_unicode_ci default NULL,
  `source` float default NULL,
  PRIMARY KEY  (`id`),
  FULLTEXT KEY `lay_title` (`lay_title`)
) ENGINE=MyISAM AUTO_INCREMENT=57868 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `level_scale_anchors` (
  `element_id` varchar(20) NOT NULL,
  `scale_id` varchar(3) NOT NULL,
  `anchor_value` decimal(3,0) NOT NULL,
  `anchor_description` varchar(1000) NOT NULL,
  KEY `element_id` (`element_id`),
  KEY `scale_id` (`scale_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `licenses` (
  `id` int(11) NOT NULL auto_increment,
  `occupation` varchar(255) default NULL,
  `license_name` varchar(255) NOT NULL,
  `licensing_agency` varchar(255) default NULL,
  `state` varchar(255) default NULL,
  `license_description` text,
  `source_url` varchar(255) default NULL,
  `activated` tinyint(1) default '1',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=10386 DEFAULT CHARSET=latin1;

CREATE TABLE `lists` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

CREATE TABLE `log_job_shares` (
  `id` int(11) NOT NULL auto_increment,
  `job_id` int(11) default NULL,
  `share_platform_id` int(11) default NULL,
  `job_seeker_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1172 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `log_shares` (
  `id` int(11) NOT NULL auto_increment,
  `job_id` int(11) default NULL,
  `share_platform_id` int(11) default NULL,
  `job_seeker_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=193 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `members` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_unicode_ci default NULL,
  `email` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `new_certificates` (
  `id` int(11) NOT NULL auto_increment,
  `occupation` varchar(255) default NULL,
  `sub_occupation` varchar(255) default NULL,
  `certification_name` varchar(255) NOT NULL,
  `certifying_organization` varchar(255) default NULL,
  `certification_description` text,
  `source_url` varchar(255) default NULL,
  `activated` tinyint(1) default '1',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=12009 DEFAULT CHARSET=latin1;

CREATE TABLE `notification_messages` (
  `id` int(11) NOT NULL auto_increment,
  `message` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `link` varchar(255) collate utf8_unicode_ci default 'javascript:void(0)',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `notification_types` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `occupation_data` (
  `onetsoc_code` char(10) NOT NULL,
  `title` varchar(150) NOT NULL,
  `description` varchar(1000) NOT NULL,
  PRIMARY KEY  (`onetsoc_code`),
  FULLTEXT KEY `title` (`title`,`description`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `occupation_level_metadata` (
  `onetsoc_code` char(10) NOT NULL,
  `item` varchar(150) NOT NULL,
  `response` varchar(75) default NULL,
  `n` decimal(4,0) default NULL,
  `percent` decimal(4,1) default NULL,
  `date_updated` date NOT NULL,
  KEY `onetsoc_code` (`onetsoc_code`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `owner_ship_types` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `pairing_logics` (
  `id` int(11) NOT NULL auto_increment,
  `job_seeker_id` int(11) default NULL,
  `job_id` int(11) default NULL,
  `pairing_value` float default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `deleted_at` time default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=511585 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `payments` (
  `id` int(11) NOT NULL auto_increment,
  `amount_charged` float default NULL,
  `id_of_transaction` varchar(255) collate utf8_unicode_ci default NULL,
  `paypal_status` varchar(255) collate utf8_unicode_ci default NULL,
  `log_message` text collate utf8_unicode_ci,
  `payment_success` tinyint(1) default NULL,
  `billing_address_one` text collate utf8_unicode_ci,
  `billing_address_two` text collate utf8_unicode_ci,
  `billing_city` varchar(255) collate utf8_unicode_ci default NULL,
  `billing_state` varchar(255) collate utf8_unicode_ci default NULL,
  `billing_zip` varchar(255) collate utf8_unicode_ci default NULL,
  `billing_country` varchar(255) collate utf8_unicode_ci default NULL,
  `payment_purpose` varchar(255) collate utf8_unicode_ci default NULL,
  `promotional_code_id` int(11) default NULL,
  `payment_mode` varchar(255) collate utf8_unicode_ci default NULL,
  `payer_id` varchar(255) collate utf8_unicode_ci default NULL,
  `token_value` varchar(255) collate utf8_unicode_ci default NULL,
  `job_seeker_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `employer_id` int(11) default NULL,
  `company_name` varchar(255) collate utf8_unicode_ci default NULL,
  `paypal_amount` float default NULL,
  `promotional_code_amount` float default NULL,
  `id_billing_agreement` varchar(255) collate utf8_unicode_ci default NULL,
  `job_id` int(11) default NULL,
  `card_number` varchar(255) collate utf8_unicode_ci default NULL,
  `profile_id` int(11) default NULL,
  `billing_contact` varchar(255) collate utf8_unicode_ci default NULL,
  `card_type` varchar(255) collate utf8_unicode_ci default NULL,
  `discount_amount` float default NULL,
  `credit_amount` float default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=820 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `postings` (
  `id` int(11) NOT NULL auto_increment,
  `hilo_share` tinyint(1) default NULL,
  `facebook_share` tinyint(1) default NULL,
  `linkedin_share` tinyint(1) default NULL,
  `twitter_share` tinyint(1) default NULL,
  `job_id` int(11) default NULL,
  `employer_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `hilo_count` int(11) default '0',
  `facebook_count` int(11) default '0',
  `twitter_count` int(11) default '0',
  `linkedin_count` int(11) default '0',
  `url_count` int(11) default '0',
  `url_share` tinyint(1) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2055 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `proficiencies` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `activated` tinyint(1) default '0',
  `created_by` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=552 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `profile_responsibilities` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1150 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `promotional_code_details` (
  `id` int(11) NOT NULL auto_increment,
  `promotional_code_id` int(11) default NULL,
  `source_name` varchar(255) collate utf8_unicode_ci default NULL,
  `origination` datetime default NULL,
  `expiration` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `promotional_codes` (
  `id` int(11) NOT NULL auto_increment,
  `code` text collate utf8_unicode_ci,
  `job_seeker_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `amount` float default NULL,
  `employer_id` int(11) default NULL,
  `given` tinyint(1) default '0',
  `consumed_amount` float NOT NULL default '0',
  `origination` varchar(255) collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1418 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `purchased_profiles` (
  `id` int(11) NOT NULL auto_increment,
  `job_seeker_id` int(11) default NULL,
  `employer_id` int(11) default NULL,
  `payment_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `job_id` int(11) default NULL,
  `company_id` int(11) default NULL,
  `deleted_at` time default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=401 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `references` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_unicode_ci default NULL,
  `position` varchar(255) collate utf8_unicode_ci default NULL,
  `company` varchar(255) collate utf8_unicode_ci default NULL,
  `email` varchar(255) collate utf8_unicode_ci default NULL,
  `comments` text collate utf8_unicode_ci,
  `job_seeker_id` int(11) default NULL,
  `upload_file_name` varchar(255) collate utf8_unicode_ci default NULL,
  `upload_content_type` varchar(255) collate utf8_unicode_ci default NULL,
  `upload_file_size` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `referral_fees` (
  `id` int(11) NOT NULL auto_increment,
  `job_seeker_id` int(11) default NULL,
  `job_id` int(11) default NULL,
  `share_platform_id` int(11) default NULL,
  `referral_fee_flag` tinyint(1) default '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `discount_amount` float default NULL,
  `credit_amount` float default NULL,
  `company_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `role_questions` (
  `id` int(11) NOT NULL auto_increment,
  `question` varchar(255) collate utf8_unicode_ci default NULL,
  `xscoring` varchar(5) collate utf8_unicode_ci default NULL,
  `yscoring` varchar(5) collate utf8_unicode_ci default NULL,
  `order` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `roles` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `scales_reference` (
  `scale_id` varchar(3) NOT NULL,
  `scale_name` varchar(50) NOT NULL,
  `minimum` decimal(1,0) NOT NULL,
  `maximum` decimal(3,0) NOT NULL,
  PRIMARY KEY  (`scale_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) collate utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `sessions` (
  `id` int(11) NOT NULL auto_increment,
  `session_id` text collate utf8_unicode_ci NOT NULL,
  `data` text collate utf8_unicode_ci,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_sessions_on_updated_at` (`updated_at`)
) ENGINE=InnoDB AUTO_INCREMENT=8976 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `share_platforms` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `skill_levels` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `skills` (
  `onetsoc_code` char(10) collate utf8_bin NOT NULL,
  `element_id` varchar(20) collate utf8_bin NOT NULL,
  `scale_id` varchar(3) collate utf8_bin NOT NULL,
  `data_value` decimal(5,2) NOT NULL,
  `n` decimal(4,0) default NULL,
  `standard_error` decimal(5,2) default NULL,
  `lower_ci_bound` decimal(5,2) default NULL,
  `upper_ci_bound` decimal(5,2) default NULL,
  `recommend_suppress` char(1) collate utf8_bin default NULL,
  `not_relevant` char(1) collate utf8_bin default NULL,
  `date_updated` date NOT NULL,
  `domain_source` varchar(30) collate utf8_bin NOT NULL,
  KEY `onetsoc_code` (`onetsoc_code`),
  KEY `element_id` (`element_id`),
  KEY `scale_id` (`scale_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `spending_limits` (
  `id` int(11) NOT NULL auto_increment,
  `employer_id` int(11) default NULL,
  `spend_limit` float default NULL,
  `setter_id` int(11) default NULL,
  `available_balance` float default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `states` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `survey_booklet_locations` (
  `element_id` varchar(20) NOT NULL,
  `survey_item_number` varchar(4) NOT NULL,
  `scale_id` varchar(3) NOT NULL,
  KEY `element_id` (`element_id`),
  KEY `scale_id` (`scale_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `task_categories` (
  `scale_id` varchar(3) NOT NULL,
  `category` decimal(3,0) NOT NULL,
  `category_description` varchar(1000) NOT NULL,
  PRIMARY KEY  (`scale_id`,`category`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `task_ratings` (
  `onetsoc_code` char(10) collate utf8_bin NOT NULL,
  `task_id` decimal(8,0) NOT NULL,
  `scale_id` varchar(3) collate utf8_bin NOT NULL,
  `category` decimal(3,0) default NULL,
  `data_value` decimal(5,2) NOT NULL,
  `n` decimal(4,0) default NULL,
  `standard_error` decimal(5,2) default NULL,
  `lower_ci_bound` decimal(5,2) default NULL,
  `upper_ci_bound` decimal(5,2) default NULL,
  `recommend_suppress` char(1) collate utf8_bin default NULL,
  `date_updated` date NOT NULL,
  `domain_source` varchar(30) collate utf8_bin NOT NULL,
  KEY `onetsoc_code` (`onetsoc_code`),
  KEY `task_id` (`task_id`),
  KEY `scale_id` (`scale_id`,`category`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `task_statements` (
  `onetsoc_code` char(10) collate utf8_bin NOT NULL,
  `task_id` decimal(8,0) NOT NULL,
  `task` varchar(1000) collate utf8_bin NOT NULL,
  `task_type` varchar(12) collate utf8_bin default NULL,
  `incumbents_responding` decimal(4,0) default NULL,
  `date_updated` date NOT NULL,
  `domain_source` varchar(30) collate utf8_bin NOT NULL,
  PRIMARY KEY  (`task_id`),
  KEY `onetsoc_code` (`onetsoc_code`),
  FULLTEXT KEY `task` (`task`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `tasks` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `done` tinyint(1) default NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `list_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

CREATE TABLE `testimonials` (
  `id` int(11) NOT NULL auto_increment,
  `testimonial_by` varchar(255) collate utf8_unicode_ci default NULL,
  `name` varchar(255) collate utf8_unicode_ci default NULL,
  `position` varchar(255) collate utf8_unicode_ci default NULL,
  `description` varchar(255) collate utf8_unicode_ci default NULL,
  `display` tinyint(1) default '0',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `universities` (
  `institution` varchar(255) character set utf8 NOT NULL,
  `id` int(11) NOT NULL auto_increment,
  `activated` tinyint(1) default '1',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=10640 DEFAULT CHARSET=latin1;

CREATE TABLE `work_activities` (
  `onetsoc_code` char(10) collate utf8_bin NOT NULL,
  `element_id` varchar(20) collate utf8_bin NOT NULL,
  `scale_id` varchar(3) collate utf8_bin NOT NULL,
  `data_value` decimal(5,2) NOT NULL,
  `n` decimal(4,0) default NULL,
  `standard_error` decimal(5,2) default NULL,
  `lower_ci_bound` decimal(5,2) default NULL,
  `upper_ci_bound` decimal(5,2) default NULL,
  `recommend_suppress` char(1) collate utf8_bin default NULL,
  `not_relevant` char(1) collate utf8_bin default NULL,
  `date_updated` date NOT NULL,
  `domain_source` varchar(30) collate utf8_bin NOT NULL,
  KEY `onetsoc_code` (`onetsoc_code`),
  KEY `element_id` (`element_id`),
  KEY `scale_id` (`scale_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `work_context` (
  `onetsoc_code` char(10) collate utf8_bin NOT NULL,
  `element_id` varchar(20) collate utf8_bin NOT NULL,
  `scale_id` varchar(3) collate utf8_bin NOT NULL,
  `category` decimal(3,0) default NULL,
  `data_value` decimal(5,2) NOT NULL,
  `n` decimal(4,0) default NULL,
  `standard_error` decimal(5,2) default NULL,
  `lower_ci_bound` decimal(5,2) default NULL,
  `upper_ci_bound` decimal(5,2) default NULL,
  `recommend_suppress` char(1) collate utf8_bin default NULL,
  `not_relevant` char(1) collate utf8_bin default NULL,
  `date_updated` date NOT NULL,
  `domain_source` varchar(30) collate utf8_bin NOT NULL,
  KEY `onetsoc_code` (`onetsoc_code`),
  KEY `scale_id` (`scale_id`),
  KEY `element_id` (`element_id`,`scale_id`,`category`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `work_context_categories` (
  `element_id` varchar(20) NOT NULL,
  `scale_id` varchar(3) NOT NULL,
  `category` decimal(3,0) NOT NULL,
  `category_description` varchar(1000) NOT NULL,
  PRIMARY KEY  (`element_id`,`scale_id`,`category`),
  KEY `scale_id` (`scale_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `work_styles` (
  `onetsoc_code` char(10) collate utf8_bin NOT NULL,
  `element_id` varchar(20) collate utf8_bin NOT NULL,
  `scale_id` varchar(3) collate utf8_bin NOT NULL,
  `data_value` decimal(5,2) NOT NULL,
  `n` decimal(4,0) default NULL,
  `standard_error` decimal(5,2) default NULL,
  `lower_ci_bound` decimal(5,2) default NULL,
  `upper_ci_bound` decimal(5,2) default NULL,
  `recommend_suppress` char(1) collate utf8_bin default NULL,
  `date_updated` date NOT NULL,
  `domain_source` varchar(30) collate utf8_bin NOT NULL,
  KEY `onetsoc_code` (`onetsoc_code`),
  KEY `element_id` (`element_id`),
  KEY `scale_id` (`scale_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `work_values` (
  `onetsoc_code` char(10) collate utf8_bin NOT NULL,
  `element_id` varchar(20) collate utf8_bin NOT NULL,
  `scale_id` varchar(3) collate utf8_bin NOT NULL,
  `data_value` decimal(5,2) NOT NULL,
  `date_updated` date NOT NULL,
  `domain_source` varchar(30) collate utf8_bin NOT NULL,
  KEY `onetsoc_code` (`onetsoc_code`),
  KEY `element_id` (`element_id`),
  KEY `scale_id` (`scale_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `workenv_question_translations` (
  `id` int(11) NOT NULL auto_increment,
  `workenv_question_id` int(11) default NULL,
  `locale` varchar(255) collate utf8_unicode_ci default NULL,
  `question` varchar(255) collate utf8_unicode_ci default NULL,
  `description_left` text collate utf8_unicode_ci,
  `description_right` text collate utf8_unicode_ci,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `index_workenv_question_translations_on_workenv_question_id` (`workenv_question_id`),
  KEY `index_workenv_question_translations_on_locale` (`locale`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `workenv_questions` (
  `id` int(11) NOT NULL auto_increment,
  `order` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `question` varchar(255) collate utf8_unicode_ci default NULL,
  `xscoring` varchar(5) collate utf8_unicode_ci default NULL,
  `yscoring` varchar(5) collate utf8_unicode_ci default NULL,
  `description_left` text collate utf8_unicode_ci,
  `description_right` text collate utf8_unicode_ci,
  `for_emp` tinyint(1) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `zipcodes` (
  `id` int(11) NOT NULL auto_increment,
  `zip` int(11) default NULL,
  `zipcodetype` varchar(255) collate utf8_unicode_ci default NULL,
  `city` varchar(255) collate utf8_unicode_ci default NULL,
  `state` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=42523 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO schema_migrations (version) VALUES ('20100203052736');

INSERT INTO schema_migrations (version) VALUES ('20100203055727');

INSERT INTO schema_migrations (version) VALUES ('20100203060225');

INSERT INTO schema_migrations (version) VALUES ('20100203060909');

INSERT INTO schema_migrations (version) VALUES ('20100210065318');

INSERT INTO schema_migrations (version) VALUES ('20100217080028');

INSERT INTO schema_migrations (version) VALUES ('20100228064758');

INSERT INTO schema_migrations (version) VALUES ('20100228070315');

INSERT INTO schema_migrations (version) VALUES ('20100228070400');

INSERT INTO schema_migrations (version) VALUES ('20100303065629');

INSERT INTO schema_migrations (version) VALUES ('20100303065716');

INSERT INTO schema_migrations (version) VALUES ('20100303065747');

INSERT INTO schema_migrations (version) VALUES ('20100303065808');

INSERT INTO schema_migrations (version) VALUES ('20100303065822');

INSERT INTO schema_migrations (version) VALUES ('20100303065851');

INSERT INTO schema_migrations (version) VALUES ('20100303065903');

INSERT INTO schema_migrations (version) VALUES ('20100303065928');

INSERT INTO schema_migrations (version) VALUES ('20100304171808');

INSERT INTO schema_migrations (version) VALUES ('20100310071721');

INSERT INTO schema_migrations (version) VALUES ('20100312043851');

INSERT INTO schema_migrations (version) VALUES ('20100312043931');

INSERT INTO schema_migrations (version) VALUES ('20100312044100');

INSERT INTO schema_migrations (version) VALUES ('20100312044335');

INSERT INTO schema_migrations (version) VALUES ('20100312044440');

INSERT INTO schema_migrations (version) VALUES ('20100312045336');

INSERT INTO schema_migrations (version) VALUES ('20100322093030');

INSERT INTO schema_migrations (version) VALUES ('20100324053725');

INSERT INTO schema_migrations (version) VALUES ('20100329041000');

INSERT INTO schema_migrations (version) VALUES ('20100329041010');

INSERT INTO schema_migrations (version) VALUES ('20100329162938');

INSERT INTO schema_migrations (version) VALUES ('20100329170750');

INSERT INTO schema_migrations (version) VALUES ('20100330063002');

INSERT INTO schema_migrations (version) VALUES ('20100405145253');

INSERT INTO schema_migrations (version) VALUES ('20100406092354');

INSERT INTO schema_migrations (version) VALUES ('20100407051304');

INSERT INTO schema_migrations (version) VALUES ('20100411143141');

INSERT INTO schema_migrations (version) VALUES ('20100416091443');

INSERT INTO schema_migrations (version) VALUES ('20100419084931');

INSERT INTO schema_migrations (version) VALUES ('20100420040351');

INSERT INTO schema_migrations (version) VALUES ('20100422125446');

INSERT INTO schema_migrations (version) VALUES ('20100423081532');

INSERT INTO schema_migrations (version) VALUES ('20100425062354');

INSERT INTO schema_migrations (version) VALUES ('20100425064502');

INSERT INTO schema_migrations (version) VALUES ('20100425093546');

INSERT INTO schema_migrations (version) VALUES ('20100425104452');

INSERT INTO schema_migrations (version) VALUES ('20100425104601');

INSERT INTO schema_migrations (version) VALUES ('20100425133534');

INSERT INTO schema_migrations (version) VALUES ('20100425142736');

INSERT INTO schema_migrations (version) VALUES ('20100426055551');

INSERT INTO schema_migrations (version) VALUES ('20100501061543');

INSERT INTO schema_migrations (version) VALUES ('20100501061801');

INSERT INTO schema_migrations (version) VALUES ('20100501062047');

INSERT INTO schema_migrations (version) VALUES ('20100501062618');

INSERT INTO schema_migrations (version) VALUES ('20100501063037');

INSERT INTO schema_migrations (version) VALUES ('20100501063135');

INSERT INTO schema_migrations (version) VALUES ('20100504113807');

INSERT INTO schema_migrations (version) VALUES ('20100505061616');

INSERT INTO schema_migrations (version) VALUES ('20100505061634');

INSERT INTO schema_migrations (version) VALUES ('20100505061651');

INSERT INTO schema_migrations (version) VALUES ('20100505061702');

INSERT INTO schema_migrations (version) VALUES ('20100510053950');

INSERT INTO schema_migrations (version) VALUES ('20100512084039');

INSERT INTO schema_migrations (version) VALUES ('20100520052015');

INSERT INTO schema_migrations (version) VALUES ('20100523111957');

INSERT INTO schema_migrations (version) VALUES ('20100523161228');

INSERT INTO schema_migrations (version) VALUES ('20100529125945');

INSERT INTO schema_migrations (version) VALUES ('20100618050730');

INSERT INTO schema_migrations (version) VALUES ('20100619130248');

INSERT INTO schema_migrations (version) VALUES ('20100620164235');

INSERT INTO schema_migrations (version) VALUES ('20100628035557');

INSERT INTO schema_migrations (version) VALUES ('20100628093304');

INSERT INTO schema_migrations (version) VALUES ('20100707050849');

INSERT INTO schema_migrations (version) VALUES ('20100713152105');

INSERT INTO schema_migrations (version) VALUES ('20100719122337');

INSERT INTO schema_migrations (version) VALUES ('20100802095644');

INSERT INTO schema_migrations (version) VALUES ('20100814090434');

INSERT INTO schema_migrations (version) VALUES ('20100814090510');

INSERT INTO schema_migrations (version) VALUES ('20100825041228');

INSERT INTO schema_migrations (version) VALUES ('20101011050905');

INSERT INTO schema_migrations (version) VALUES ('20101024100819');

INSERT INTO schema_migrations (version) VALUES ('20101024101004');

INSERT INTO schema_migrations (version) VALUES ('20101024101413');

INSERT INTO schema_migrations (version) VALUES ('20101024104643');

INSERT INTO schema_migrations (version) VALUES ('20101109075113');

INSERT INTO schema_migrations (version) VALUES ('20101109075149');

INSERT INTO schema_migrations (version) VALUES ('20101118054940');

INSERT INTO schema_migrations (version) VALUES ('20101123040115');

INSERT INTO schema_migrations (version) VALUES ('20101223151758');

INSERT INTO schema_migrations (version) VALUES ('20101223152826');

INSERT INTO schema_migrations (version) VALUES ('20101225093423');

INSERT INTO schema_migrations (version) VALUES ('20101229110824');

INSERT INTO schema_migrations (version) VALUES ('20101229111032');

INSERT INTO schema_migrations (version) VALUES ('20110105064756');

INSERT INTO schema_migrations (version) VALUES ('20110209092442');

INSERT INTO schema_migrations (version) VALUES ('20110227133547');

INSERT INTO schema_migrations (version) VALUES ('20110227134620');

INSERT INTO schema_migrations (version) VALUES ('20110227142316');

INSERT INTO schema_migrations (version) VALUES ('20110413093853');

INSERT INTO schema_migrations (version) VALUES ('20110504062904');

INSERT INTO schema_migrations (version) VALUES ('20110523110614');

INSERT INTO schema_migrations (version) VALUES ('20110523111422');

INSERT INTO schema_migrations (version) VALUES ('20110523112027');

INSERT INTO schema_migrations (version) VALUES ('20110525060617');

INSERT INTO schema_migrations (version) VALUES ('20110620095457');

INSERT INTO schema_migrations (version) VALUES ('20110713124608');

INSERT INTO schema_migrations (version) VALUES ('20110714060938');

INSERT INTO schema_migrations (version) VALUES ('20110801111835');

INSERT INTO schema_migrations (version) VALUES ('20110802104254');

INSERT INTO schema_migrations (version) VALUES ('20110804074259');

INSERT INTO schema_migrations (version) VALUES ('20110809052052');

INSERT INTO schema_migrations (version) VALUES ('20110901125442');

INSERT INTO schema_migrations (version) VALUES ('20111017075141');

INSERT INTO schema_migrations (version) VALUES ('20111020123253');

INSERT INTO schema_migrations (version) VALUES ('20111103131550');

INSERT INTO schema_migrations (version) VALUES ('20111109121549');

INSERT INTO schema_migrations (version) VALUES ('20111109122839');

INSERT INTO schema_migrations (version) VALUES ('20111109123232');

INSERT INTO schema_migrations (version) VALUES ('20111109123254');

INSERT INTO schema_migrations (version) VALUES ('20111111122540');

INSERT INTO schema_migrations (version) VALUES ('20111114091420');

INSERT INTO schema_migrations (version) VALUES ('20111114113757');

INSERT INTO schema_migrations (version) VALUES ('20111114131119');

INSERT INTO schema_migrations (version) VALUES ('20111125114650');

INSERT INTO schema_migrations (version) VALUES ('20111129074301');

INSERT INTO schema_migrations (version) VALUES ('20111129074332');

INSERT INTO schema_migrations (version) VALUES ('20111129074410');

INSERT INTO schema_migrations (version) VALUES ('20111130100859');

INSERT INTO schema_migrations (version) VALUES ('20111202102413');

INSERT INTO schema_migrations (version) VALUES ('20111208112913');

INSERT INTO schema_migrations (version) VALUES ('20111215062811');

INSERT INTO schema_migrations (version) VALUES ('20111215102233');

INSERT INTO schema_migrations (version) VALUES ('20111223063253');

INSERT INTO schema_migrations (version) VALUES ('20111223100800');

INSERT INTO schema_migrations (version) VALUES ('20120112135214');

INSERT INTO schema_migrations (version) VALUES ('20120112135959');

INSERT INTO schema_migrations (version) VALUES ('20120127070127');

INSERT INTO schema_migrations (version) VALUES ('20120127100902');

INSERT INTO schema_migrations (version) VALUES ('20120130121039');

INSERT INTO schema_migrations (version) VALUES ('20120221074905');

INSERT INTO schema_migrations (version) VALUES ('20120224051655');

INSERT INTO schema_migrations (version) VALUES ('20120224065544');

INSERT INTO schema_migrations (version) VALUES ('20120225055135');

INSERT INTO schema_migrations (version) VALUES ('20120225055243');

INSERT INTO schema_migrations (version) VALUES ('20120225081503');

INSERT INTO schema_migrations (version) VALUES ('20120225081520');

INSERT INTO schema_migrations (version) VALUES ('20120301104551');

INSERT INTO schema_migrations (version) VALUES ('20120301121508');

INSERT INTO schema_migrations (version) VALUES ('20120302073407');

INSERT INTO schema_migrations (version) VALUES ('20120302073938');

INSERT INTO schema_migrations (version) VALUES ('20120306052251');

INSERT INTO schema_migrations (version) VALUES ('20120312141053');

INSERT INTO schema_migrations (version) VALUES ('20120314051914');

INSERT INTO schema_migrations (version) VALUES ('20120320065713');

INSERT INTO schema_migrations (version) VALUES ('20120323064956');

INSERT INTO schema_migrations (version) VALUES ('20120323133003');

INSERT INTO schema_migrations (version) VALUES ('20120326091051');

INSERT INTO schema_migrations (version) VALUES ('20120326094042');

INSERT INTO schema_migrations (version) VALUES ('20120327112442');

INSERT INTO schema_migrations (version) VALUES ('20120327112458');

INSERT INTO schema_migrations (version) VALUES ('20120329113106');

INSERT INTO schema_migrations (version) VALUES ('20120330053917');

INSERT INTO schema_migrations (version) VALUES ('20120330061802');

INSERT INTO schema_migrations (version) VALUES ('20120402124153');

INSERT INTO schema_migrations (version) VALUES ('20120402134809');

INSERT INTO schema_migrations (version) VALUES ('20120405094517');

INSERT INTO schema_migrations (version) VALUES ('20120418104016');

INSERT INTO schema_migrations (version) VALUES ('20120418111827');

INSERT INTO schema_migrations (version) VALUES ('20120426093559');

INSERT INTO schema_migrations (version) VALUES ('20120430074059');

INSERT INTO schema_migrations (version) VALUES ('20120507095747');

INSERT INTO schema_migrations (version) VALUES ('20120507101253');

INSERT INTO schema_migrations (version) VALUES ('20120508102742');

INSERT INTO schema_migrations (version) VALUES ('20120508112543');

INSERT INTO schema_migrations (version) VALUES ('20120508114322');

INSERT INTO schema_migrations (version) VALUES ('20120509074359');

INSERT INTO schema_migrations (version) VALUES ('20120510061514');

INSERT INTO schema_migrations (version) VALUES ('20120510063338');

INSERT INTO schema_migrations (version) VALUES ('20120514091446');

INSERT INTO schema_migrations (version) VALUES ('20120514092747');

INSERT INTO schema_migrations (version) VALUES ('20120515065737');

INSERT INTO schema_migrations (version) VALUES ('20120515110048');

INSERT INTO schema_migrations (version) VALUES ('20120515110222');

INSERT INTO schema_migrations (version) VALUES ('20120515112724');

INSERT INTO schema_migrations (version) VALUES ('20120515112757');

INSERT INTO schema_migrations (version) VALUES ('20120516095426');

INSERT INTO schema_migrations (version) VALUES ('20120517082020');

INSERT INTO schema_migrations (version) VALUES ('20120517110923');

INSERT INTO schema_migrations (version) VALUES ('20120520161116');

INSERT INTO schema_migrations (version) VALUES ('20120520211304');

INSERT INTO schema_migrations (version) VALUES ('20120520211610');

INSERT INTO schema_migrations (version) VALUES ('20120521071852');

INSERT INTO schema_migrations (version) VALUES ('20120521090834');

INSERT INTO schema_migrations (version) VALUES ('20120521120812');

INSERT INTO schema_migrations (version) VALUES ('20120521130941');

INSERT INTO schema_migrations (version) VALUES ('20120522104311');

INSERT INTO schema_migrations (version) VALUES ('20120523100446');

INSERT INTO schema_migrations (version) VALUES ('20120523114404');

INSERT INTO schema_migrations (version) VALUES ('20120523114823');

INSERT INTO schema_migrations (version) VALUES ('20120524052900');

INSERT INTO schema_migrations (version) VALUES ('20120524121958');

INSERT INTO schema_migrations (version) VALUES ('20120525071646');

INSERT INTO schema_migrations (version) VALUES ('20120525071806');

INSERT INTO schema_migrations (version) VALUES ('20120529092648');

INSERT INTO schema_migrations (version) VALUES ('20120530110515');

INSERT INTO schema_migrations (version) VALUES ('20120530110747');

INSERT INTO schema_migrations (version) VALUES ('20120530112443');

INSERT INTO schema_migrations (version) VALUES ('20120530112526');

INSERT INTO schema_migrations (version) VALUES ('20120601063312');

INSERT INTO schema_migrations (version) VALUES ('20120612065142');

INSERT INTO schema_migrations (version) VALUES ('20120613095432');

INSERT INTO schema_migrations (version) VALUES ('20120626055849');

INSERT INTO schema_migrations (version) VALUES ('20120626060855');

INSERT INTO schema_migrations (version) VALUES ('20120626074806');

INSERT INTO schema_migrations (version) VALUES ('20120627060709');

INSERT INTO schema_migrations (version) VALUES ('20120628061332');

INSERT INTO schema_migrations (version) VALUES ('20120702062655');

INSERT INTO schema_migrations (version) VALUES ('20120706092027');

INSERT INTO schema_migrations (version) VALUES ('20120723071604');

INSERT INTO schema_migrations (version) VALUES ('20120803064702');

INSERT INTO schema_migrations (version) VALUES ('20120803070844');

INSERT INTO schema_migrations (version) VALUES ('20120803073022');

INSERT INTO schema_migrations (version) VALUES ('20120803075251');

INSERT INTO schema_migrations (version) VALUES ('20120803105059');

INSERT INTO schema_migrations (version) VALUES ('20120806065948');

INSERT INTO schema_migrations (version) VALUES ('20120807125722');

INSERT INTO schema_migrations (version) VALUES ('20120808064847');

INSERT INTO schema_migrations (version) VALUES ('20120808110111');

INSERT INTO schema_migrations (version) VALUES ('20120808112805');

INSERT INTO schema_migrations (version) VALUES ('20120810121157');

INSERT INTO schema_migrations (version) VALUES ('20120813123355');

INSERT INTO schema_migrations (version) VALUES ('20120813123818');

INSERT INTO schema_migrations (version) VALUES ('20120814124003');

INSERT INTO schema_migrations (version) VALUES ('20120816070444');

INSERT INTO schema_migrations (version) VALUES ('20120816073155');

INSERT INTO schema_migrations (version) VALUES ('20120816081144');

INSERT INTO schema_migrations (version) VALUES ('20120816093108');

INSERT INTO schema_migrations (version) VALUES ('20120823090635');

INSERT INTO schema_migrations (version) VALUES ('20120823130602');

INSERT INTO schema_migrations (version) VALUES ('20120823131810');

INSERT INTO schema_migrations (version) VALUES ('20120824082657');

INSERT INTO schema_migrations (version) VALUES ('20120827071314');

INSERT INTO schema_migrations (version) VALUES ('20120828092040');

INSERT INTO schema_migrations (version) VALUES ('20120828104959');

INSERT INTO schema_migrations (version) VALUES ('20120828104960');

INSERT INTO schema_migrations (version) VALUES ('20120828104961');

INSERT INTO schema_migrations (version) VALUES ('20120828104962');

INSERT INTO schema_migrations (version) VALUES ('20120828110033');

INSERT INTO schema_migrations (version) VALUES ('20120828125140');

INSERT INTO schema_migrations (version) VALUES ('20120830103244');

INSERT INTO schema_migrations (version) VALUES ('20120920105446');

INSERT INTO schema_migrations (version) VALUES ('20120920105604');

INSERT INTO schema_migrations (version) VALUES ('20120920112501');

INSERT INTO schema_migrations (version) VALUES ('20120920113943');

INSERT INTO schema_migrations (version) VALUES ('20120925064343');

INSERT INTO schema_migrations (version) VALUES ('20120927063619');

INSERT INTO schema_migrations (version) VALUES ('20121001064737');

INSERT INTO schema_migrations (version) VALUES ('20121003064506');

INSERT INTO schema_migrations (version) VALUES ('20121003064633');

INSERT INTO schema_migrations (version) VALUES ('20121003080321');

INSERT INTO schema_migrations (version) VALUES ('20121003115120');

INSERT INTO schema_migrations (version) VALUES ('20121003123038');

INSERT INTO schema_migrations (version) VALUES ('20121004083013');

INSERT INTO schema_migrations (version) VALUES ('20121004113252');

INSERT INTO schema_migrations (version) VALUES ('20121004113921');

INSERT INTO schema_migrations (version) VALUES ('20121005081818');

INSERT INTO schema_migrations (version) VALUES ('20121005095354');

INSERT INTO schema_migrations (version) VALUES ('20121008080920');

INSERT INTO schema_migrations (version) VALUES ('20121024093044');

INSERT INTO schema_migrations (version) VALUES ('20121025063314');

INSERT INTO schema_migrations (version) VALUES ('20121026120726');

INSERT INTO schema_migrations (version) VALUES ('20121108080643');

INSERT INTO schema_migrations (version) VALUES ('20121108090617');

INSERT INTO schema_migrations (version) VALUES ('20121108093556');

INSERT INTO schema_migrations (version) VALUES ('20121109070425');

INSERT INTO schema_migrations (version) VALUES ('20121109074607');

INSERT INTO schema_migrations (version) VALUES ('20121109104241');

INSERT INTO schema_migrations (version) VALUES ('20121109110659');

INSERT INTO schema_migrations (version) VALUES ('20121109113204');

INSERT INTO schema_migrations (version) VALUES ('20121109114525');

INSERT INTO schema_migrations (version) VALUES ('20121115082658');

INSERT INTO schema_migrations (version) VALUES ('20121115125214');

INSERT INTO schema_migrations (version) VALUES ('20121119093103');

INSERT INTO schema_migrations (version) VALUES ('20121120120015');

INSERT INTO schema_migrations (version) VALUES ('20121122115454');

INSERT INTO schema_migrations (version) VALUES ('20121123094419');

INSERT INTO schema_migrations (version) VALUES ('20121126130638');

INSERT INTO schema_migrations (version) VALUES ('20121127113623');

INSERT INTO schema_migrations (version) VALUES ('20121207110756');

INSERT INTO schema_migrations (version) VALUES ('20121207112402');

INSERT INTO schema_migrations (version) VALUES ('20121220093140');

INSERT INTO schema_migrations (version) VALUES ('20121224074605');

INSERT INTO schema_migrations (version) VALUES ('20121224093914');

INSERT INTO schema_migrations (version) VALUES ('20130115053814');

INSERT INTO schema_migrations (version) VALUES ('20130115055238');

INSERT INTO schema_migrations (version) VALUES ('20130115084357');

INSERT INTO schema_migrations (version) VALUES ('20130116065017');

INSERT INTO schema_migrations (version) VALUES ('20130122073744');

INSERT INTO schema_migrations (version) VALUES ('20130130113837');

INSERT INTO schema_migrations (version) VALUES ('20130205093659');

INSERT INTO schema_migrations (version) VALUES ('20130218060836');

INSERT INTO schema_migrations (version) VALUES ('20130221115303');

INSERT INTO schema_migrations (version) VALUES ('20130225092923');

INSERT INTO schema_migrations (version) VALUES ('20130225105700');

INSERT INTO schema_migrations (version) VALUES ('20130226050105');

INSERT INTO schema_migrations (version) VALUES ('20130228073815');

INSERT INTO schema_migrations (version) VALUES ('20130301104241');