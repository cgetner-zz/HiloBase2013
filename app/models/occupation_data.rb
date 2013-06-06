class OccupationData < ActiveRecord::Base
  self.table_name = 'occupation_data'
  attr_accessible :onetsoc_code, :title, :description

  has_many :added_roles, :foreign_key => "code", :dependent => :destroy
  has_many :job_seekers, :foreign_key => "code", :through => :added_roles
  has_many :jobs, :foreign_key => "code", :through => :added_roles
  has_many :lay_titles, :foreign_key=>"onetsoc_code"
  has_many :task_statements, :foreign_key=>"onetsoc_code"
  
  searchable :auto_index => false do
    text :title
    text :description

    text :task do |occupation_data|
      occupation_data.task_statements.map {|t| t.task}
    end

    text :lay_title do |occupation_data|
      occupation_data.lay_titles.map {|l| l.lay_title}
    end

    string :sort_title do
      title.downcase
    end
	
    boolean :banned do |occupation_data|
      career_cluster = CareerCluster.where("code = ?", occupation_data.onetsoc_code).first
      if career_cluster.nil?
        true
      else
        false
	    end
    end
  end

end
