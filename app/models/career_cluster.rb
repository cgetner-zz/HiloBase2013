class CareerCluster < ActiveRecord::Base
  self.table_name = 'career_cluster'
  attr_accessible :career_cluster, :pathway, :descripton

  def self.search_all_roles_for_seeker(search_role, order, sensitivity)
    #where("career_cluster LIKE ? OR pathway LIKE ? OR descripton LIKE ?", '%'+search_role+'%', '%'+search_role+'%', '%'+search_role+'%')
=begin
    find_by_sql("SELECT MATCH(occupation_data.title, occupation_data.description) AGAINST('\"#{search_role}\"') AS 'Score',
                occupation_data.onetsoc_code AS 'Code',
                career_cluster.career_cluster AS 'Career_Cluster',
                career_cluster.pathway AS 'Career_Pathway',
                occupation_data.title AS 'Role',
                occupation_data.description AS 'Description'
      FROM career_cluster INNER JOIN occupation_data ON career_cluster.code = occupation_data.onetsoc_code
      WHERE MATCH(occupation_data.title, occupation_data.description) AGAINST('\"#{search_role}\"') OR MATCH(career_cluster.career_cluster, career_cluster.pathway, career_cluster.descripton) AGAINST('\"#{search_role}\"')
      ORDER BY Score DESC, career_cluster.career_cluster ASC")
=end
=begin
    find_by_sql("SELECT MATCH(occupation_data.title, occupation_data.description) AGAINST('\"#{search_role}\"') AS 'Score',
                occupation_data.onetsoc_code AS 'Code',
                career_cluster.career_cluster AS 'Career_Cluster',
                career_cluster.pathway AS 'Career_Pathway',
                occupation_data.title AS 'Role',
                occupation_data.description AS 'Description'
      FROM career_cluster
      INNER JOIN occupation_data ON career_cluster.code = occupation_data.onetsoc_code
      INNER JOIN lay_titles ON career_cluster.code = lay_titles.onetsoc_code
      WHERE MATCH(occupation_data.title, occupation_data.description) AGAINST('\"#{search_role}\"') OR MATCH(career_cluster.career_cluster, career_cluster.pathway, career_cluster.descripton) AGAINST('\"#{search_role}\"') OR MATCH(lay_titles.lay_title) AGAINST('\"#{search_role}\"')
      ORDER BY Score DESC, career_cluster.career_cluster ASC")

      ############### Fourth last query ##########################
      find_by_sql("SELECT Score, Code, Career_Cluster, Career_Pathway, Role, Description
        FROM
        (
        SELECT MATCH(occupation_data.title, occupation_data.description) AGAINST('\"#{search_role}\"') AS 'Score',
            occupation_data.onetsoc_code AS 'Code',
            career_cluster.career_cluster AS 'Career_Cluster',
            career_cluster.pathway AS 'Career_Pathway',
            occupation_data.title AS 'Role',
            occupation_data.description AS 'Description'
        FROM career_cluster
        INNER JOIN occupation_data ON career_cluster.code = occupation_data.onetsoc_code
        WHERE MATCH(occupation_data.title, occupation_data.description) AGAINST('\"#{search_role}\"')
        UNION
        SELECT MATCH(occupation_data.title, occupation_data.description) AGAINST('\"#{search_role}\"') AS 'Score',
            occupation_data.onetsoc_code AS 'Code',
            career_cluster.career_cluster AS 'Career_Cluster',
            career_cluster.pathway AS 'Career_Pathway',
            occupation_data.title AS 'Role',
            occupation_data.description AS 'Description'
        FROM career_cluster
        INNER JOIN occupation_data ON career_cluster.code = occupation_data.onetsoc_code
        WHERE MATCH(career_cluster.career_cluster, career_cluster.pathway, career_cluster.descripton) AGAINST('\"#{search_role}\"')
        UNION
        SELECT MATCH(occupation_data.title, occupation_data.description) AGAINST('\"#{search_role}\"') AS 'Score',
            occupation_data.onetsoc_code AS 'Code',
            career_cluster.career_cluster AS 'Career_Cluster',
            career_cluster.pathway AS 'Career_Pathway',
            occupation_data.title AS 'Role',
            occupation_data.description AS 'Description'
        FROM career_cluster
        INNER JOIN occupation_data ON career_cluster.code = occupation_data.onetsoc_code
        INNER JOIN lay_titles ON career_cluster.code = lay_titles.onetsoc_code
        WHERE MATCH(lay_titles.lay_title) AGAINST('\"#{search_role}\"')
        ) as sub_query
        ORDER BY Role ASC, Score DESC, Career_Cluster ASC")

    ############### Third last query ##########################
    find_by_sql("SELECT Score, Code, Role, Description
        FROM
        (
        SELECT MATCH(occupation_data.title, occupation_data.description) AGAINST('\"#{search_role}\"') AS 'Score',
            occupation_data.onetsoc_code AS 'Code',
            occupation_data.title AS 'Role',
            occupation_data.description AS 'Description'
        FROM occupation_data
        INNER JOIN task_statements ON occupation_data.onetsoc_code = task_statements.onetsoc_code
        INNER JOIN career_cluster ON occupation_data.onetsoc_code = career_cluster.code
        WHERE MATCH(occupation_data.title, occupation_data.description) AGAINST('\"#{search_role}\"')
        UNION
        SELECT MATCH(occupation_data.title, occupation_data.description) AGAINST('\"#{search_role}\"') AS 'Score',
            occupation_data.onetsoc_code AS 'Code',
            occupation_data.title AS 'Role',
            occupation_data.description AS 'Description'
        FROM occupation_data
        INNER JOIN task_statements ON occupation_data.onetsoc_code = task_statements.onetsoc_code
        WHERE MATCH(task_statements.task) AGAINST('\"#{search_role}\"')
        UNION
        SELECT MATCH(occupation_data.title, occupation_data.description) AGAINST('\"#{search_role}\"') AS 'Score',
            occupation_data.onetsoc_code AS 'Code',
            occupation_data.title AS 'Role',
            occupation_data.description AS 'Description'
        FROM occupation_data
        INNER JOIN task_statements ON occupation_data.onetsoc_code = task_statements.onetsoc_code
        INNER JOIN lay_titles ON occupation_data.onetsoc_code = lay_titles.onetsoc_code
        WHERE MATCH(lay_titles.lay_title) AGAINST('\"#{search_role}\"')
        ) as sub_query
        ORDER BY Role ASC, Score DESC")
=end

    ############### Second last query ##########################
    search_role = search_role.downcase
    search_role = search_role.gsub("'"," ")
    find_by_sql("SELECT Score, Code, Role, Description
        FROM
        (
        SELECT MATCH(occupation_data.title, occupation_data.description) AGAINST('\"#{search_role}\"') AS 'Score',
             occupation_data.onetsoc_code AS 'Code',
             occupation_data.title AS 'Role',
             occupation_data.description AS 'Description'
        FROM occupation_data
        WHERE MATCH(occupation_data.title, occupation_data.description) AGAINST('\"#{search_role}\"')

        UNION
        SELECT MATCH(task_statements.task) AGAINST('\"#{search_role}\"') AS 'Score',
               task_statements.onetsoc_code AS 'Code',
               occupation_data.title AS 'Role',
               occupation_data.description AS 'Description'
        FROM task_statements
        INNER JOIN occupation_data ON occupation_data.onetsoc_code = task_statements.onetsoc_code
        WHERE MATCH(task_statements.task) AGAINST('\"#{search_role}\"')

        UNION
        SELECT MATCH(lay_titles.lay_title) AGAINST('\"#{search_role}\"') AS 'Score',
               lay_titles.onetsoc_code AS 'Code',
               occupation_data.title AS 'Role',
               occupation_data.description AS 'Description'
        FROM lay_titles
        INNER JOIN occupation_data ON occupation_data.onetsoc_code = lay_titles.onetsoc_code
        WHERE MATCH(lay_titles.lay_title) AGAINST('\"#{search_role}\"')

        ) as sub_query WHERE Score > #{sensitivity.blank? ? '5' : sensitivity}
        ORDER BY #{order.blank? ? 'Role ASC, Score DESC' : order}")
    #ORDER BY Role ASC, Score DESC

=begin
    ############ Query that is correct but taking lot of time ##############
    find_by_sql("SELECT Score, Code, Role, Description
                FROM (
                      SELECT MATCH(occupation_data.title, occupation_data.description) AGAINST('\"#{search_role}\"') AS 'Score',
                             occupation_data.onetsoc_code AS 'Code',
                             occupation_data.title AS 'Role',
                             occupation_data.description AS 'Description'
                      FROM occupation_data
                      WHERE MATCH(occupation_data.title, occupation_data.description) AGAINST('\"#{search_role}\"')

                      UNION
                      SELECT MATCH(task_statements.task) AGAINST('\"#{search_role}\"') AS 'Score',
                             task_statements.onetsoc_code AS 'Code',
                             occupation_data.title AS 'Role',
                             occupation_data.description AS 'Description'
                      FROM task_statements
                      INNER JOIN occupation_data ON occupation_data.onetsoc_code = task_statements.onetsoc_code
                      WHERE MATCH(task_statements.task) AGAINST('\"#{search_role}\"')

                      UNION
                      SELECT MATCH(lay_titles.lay_title) AGAINST('\"#{search_role}\"') AS 'Score',
                             lay_titles.onetsoc_code AS 'Code',
                             occupation_data.title AS 'Role',
                             occupation_data.description AS 'Description'
                      FROM lay_titles
                      INNER JOIN occupation_data ON occupation_data.onetsoc_code = lay_titles.onetsoc_code
                      WHERE MATCH(lay_titles.lay_title) AGAINST('\"#{search_role}\"')
                ) as sub_query
                WHERE Score > (
                SELECT AVG(Score)
                FROM (
                      SELECT Score
                      FROM (
                           SELECT MATCH(occupation_data.title, occupation_data.description) AGAINST('\"#{search_role}\"') AS 'Score'
                           FROM occupation_data
                           WHERE MATCH(occupation_data.title, occupation_data.description) AGAINST('\"#{search_role}\"')

                           UNION
                           SELECT MATCH(task_statements.task) AGAINST('\"#{search_role}\"') AS 'Score'
                           FROM task_statements
                           WHERE MATCH(task_statements.task) AGAINST('\"#{search_role}\"')

                           UNION
                           SELECT MATCH(lay_titles.lay_title) AGAINST('\"#{search_role}\"') AS 'Score'
                           FROM lay_titles
                           WHERE MATCH(lay_titles.lay_title) AGAINST('\"#{search_role}\"')
                           ) as sub_query WHERE Score > 0
                      )
                as ABC)
                ORDER BY Role ASC, Score DESC")

    find_by_sql("SELECT MATCH(occupation_data.title, occupation_data.description) AGAINST('\"#{search_role}\"') AS 'Score',
                      occupation_data.onetsoc_code AS 'Code',
                      occupation_data.title AS 'Role',
                      occupation_data.description AS 'Description'
                 FROM occupation_data
                 WHERE MATCH(occupation_data.title, occupation_data.description) AGAINST('\"#{search_role}\"')

                 UNION
                 SELECT MATCH(task_statements.task) AGAINST('\"#{search_role}\"') AS 'Score',
                        task_statements.onetsoc_code AS 'Code',
                        occupation_data.title AS 'Role',
                        occupation_data.description AS 'Description'
                 FROM task_statements
                 INNER JOIN occupation_data ON occupation_data.onetsoc_code = task_statements.onetsoc_code
                 WHERE MATCH(task_statements.task) AGAINST('\"#{search_role}\"')

                 UNION
                 SELECT MATCH(lay_titles.lay_title) AGAINST('\"#{search_role}\"') AS 'Score',
                        lay_titles.onetsoc_code AS 'Code',
                        occupation_data.title AS 'Role',
                        occupation_data.description AS 'Description'
                 FROM lay_titles
                 INNER JOIN occupation_data ON occupation_data.onetsoc_code = lay_titles.onetsoc_code
                 WHERE MATCH(lay_titles.lay_title) AGAINST('\"#{search_role}\"')

                GROUP BY Code HAVING Score > AVG(Score)
                ORDER BY Role ASC, Score DESC")
=end
  end

  def self.find_role_for_wrapped_jobs(role_string)
    role_string = role_string.downcase
    role_string = role_string.gsub("'"," ")
    find_by_sql("SELECT Score, Code, Role, Description
        FROM
        (
        SELECT MATCH(occupation_data.title, occupation_data.description) AGAINST('\"#{role_string}\"') AS 'Score',
             occupation_data.onetsoc_code AS 'Code',
             occupation_data.title AS 'Role',
             occupation_data.description AS 'Description'
        FROM occupation_data
        WHERE MATCH(occupation_data.title, occupation_data.description) AGAINST('\"#{role_string}\"')

        UNION
        SELECT MATCH(task_statements.task) AGAINST('\"#{role_string}\"') AS 'Score',
               task_statements.onetsoc_code AS 'Code',
               occupation_data.title AS 'Role',
               occupation_data.description AS 'Description'
        FROM task_statements
        INNER JOIN occupation_data ON occupation_data.onetsoc_code = task_statements.onetsoc_code
        WHERE MATCH(task_statements.task) AGAINST('\"#{role_string}\"')

        UNION
        SELECT MATCH(lay_titles.lay_title) AGAINST('\"#{role_string}\"') AS 'Score',
               lay_titles.onetsoc_code AS 'Code',
               occupation_data.title AS 'Role',
               occupation_data.description AS 'Description'
        FROM lay_titles
        INNER JOIN occupation_data ON occupation_data.onetsoc_code = lay_titles.onetsoc_code
        WHERE MATCH(lay_titles.lay_title) AGAINST('\"#{role_string}\"')

        ) as sub_query WHERE Score > 5
        ORDER BY Score ASC, Role DESC
        LIMIT 1")
  end
end