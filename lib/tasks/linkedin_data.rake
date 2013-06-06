#coding: UTF-8
##--
#Important Note: This rake task is design to Crawl LinkedIn public profile as part of their Career Seeker profile.
#Author:###
##++

include ActionView::Helpers::SanitizeHelper

namespace :linkedin_data do
  desc "Linkedin public data import."
  task(:data => :environment) do
    
    def linkedin_public_data_import
      @all_job_seeker = JobSeeker.all()
      @all_job_seeker.each do |js|
        puts "JS : ID #{js.id}"
        website_hash = {}
        crawled_data = ''
        combining_crawled_data = ''
        website_hash.store("website_one", js.website_one)
        website_hash.store("website_two", js.website_two)
        website_hash.store("website_three", js.website_three)
        website_hash.delete_if { |k, v| v.nil? }
        website_hash.map { |k,v| v }.uniq.each { |link|
          if link.include? ".linkedin.com/pub/"
            crawled_data = pismo_crawl link
          end
          combining_crawled_data = combining_crawled_data + ' ' + crawled_data
        }

        unless combining_crawled_data.nil?
          js.update_column(:linkedin_crawl_data, combining_crawled_data)
        end
      end
    end

    def pismo_crawl website_link = nil
      ignore_word_arr = ["a's", "able", "about", "above", "according", "accordingly", "across", "actually", "after", "afterwards", "again", "against", "ain't", "all", "allow", "allows", "almost", "alone", "along", "already", "also", "although", "always", "am", "among", "amongst", "an", "and", "another", "any", "anybody", "anyhow", "anyone", "anything", "anyway", "anyways", "anywhere", "apart", "appear", "appreciate", "appropriate", "are", "aren't", "around", "as", "aside", "ask", "asking", "associated", "at", "available", "away", "awfully", "be", "became", "because", "become", "becomes", "becoming", "been", "before", "beforehand", "behind", "being", "believe", "below", "beside", "besides", "best", "better", "between", "beyond", "both", "brief", "but", "by", "c'mon", "c's", "came", "can", "can't", "cannot", "cant", "cause", "causes", "certain", "certainly", "changes", "clearly", "co", "com", "come", "comes", "concerning", "consequently", "consider", "considering", "contain", "containing", "contains", "corresponding", "could", "couldn't", "course", "currently", "definitely", "described", "despite", "did", "didn't", "different", "do", "does", "doesn't", "doing", "don't", "done", "down", "downwards", "during", "each", "edu", "eg", "eight", "either", "else", "elsewhere", "enough", "entirely", "especially", "et", "etc", "even", "ever", "every", "everybody", "everyone", "everything", "everywhere", "ex", "exactly", "example", "except", "far", "few", "fifth", "first", "five", "followed", "following", "follows", "for", "former", "formerly", "forth", "four", "from", "further", "furthermore", "get", "gets", "getting", "given", "gives", "go", "goes", "going", "gone", "got", "gotten", "greetings", "had", "hadn't", "happens", "hardly", "has", "hasn't", "have", "haven't", "having", "he", "he's", "hello", "help", "hence", "her", "here", "here's", "hereafter", "hereby", "herein", "hereupon", "hers", "herself", "hi", "him", "himself", "his", "hither", "hopefully", "how", "howbeit", "however", "i'd", "i'll", "i'm", "i've", "ie", "if", "ignored", "immediate", "in", "inasmuch", "inc", "indeed", "indicate", "indicated", "indicates", "inner", "insofar", "instead", "into", "inward", "is", "isn't", "it", "it'd", "it'll", "it's", "its", "itself", "just", "keep", "keeps", "kept", "know", "knows", "known", "last", "lately", "later", "latter", "latterly", "least", "less", "lest", "let", "let's", "like", "liked", "likely", "little", "look", "looking", "looks", "ltd", "mainly", "many", "may", "maybe", "me", "mean", "meanwhile", "merely", "might", "more", "moreover", "most", "mostly", "much", "must", "my", "myself", "name", "namely", "nd", "near", "nearly", "necessary", "need", "needs", "neither", "never", "nevertheless", "new", "next", "nine", "no", "nobody", "non", "none", "noone", "nor", "normally", "not", "nothing", "novel", "now", "nowhere", "obviously", "of", "off", "often", "oh", "ok", "okay", "old", "on", "once", "one", "ones", "only", "onto", "or", "other", "others", "otherwise", "ought", "our", "ours", "ourselves", "out", "outside", "over", "overall", "own", "particular", "particularly", "per", "perhaps", "placed", "please", "plus", "possible", "presumably", "probably", "provides", "que", "quite", "qv", "rather", "rd", "re", "really", "reasonably", "regarding", "regardless", "regards", "relatively", "respectively", "right", "said", "same", "saw", "say", "saying", "says", "second", "secondly", "see", "seeing", "seem", "seemed", "seeming", "seems", "seen", "self", "selves", "sensible", "sent", "serious", "seriously", "seven", "several", "shall", "she", "should", "shouldn't", "since", "six", "so", "some", "somebody", "somehow", "someone", "something", "sometime", "sometimes", "somewhat", "somewhere", "soon", "sorry", "specified", "specify", "specifying", "still", "sub", "such", "sup", "sure", "t's", "take", "taken", "tell", "tends", "th", "than", "thank", "thanks", "thanx", "that", "that's", "thats", "the", "their", "theirs", "them", "themselves", "then", "thence", "there", "there's", "thereafter", "thereby", "therefore", "therein", "theres", "thereupon", "these", "they", "they'd", "they'll", "they're", "they've", "think", "third", "this", "thorough", "thoroughly", "those", "though", "three", "through", "throughout", "thru", "thus", "to", "together", "too", "took", "toward", "towards", "tried", "tries", "truly", "try", "trying", "twice", "two", "un", "under", "unfortunately", "unless", "unlikely", "until", "unto", "up", "upon", "us", "use", "used", "useful", "uses", "using", "usually", "value", "various", "very", "via", "viz", "vs", "want", "wants", "was", "wasn't", "way", "we", "we'd", "we'll", "we're", "we've", "welcome", "well", "went", "were", "weren't", "what", "what's", "whatever", "when", "whence", "whenever", "where", "where's", "whereafter", "whereas", "whereby", "wherein", "whereupon", "wherever", "whether", "which", "while", "whither", "who", "who's", "whoever", "whole", "whom", "whose", "why", "will", "willing", "wish", "with", "within", "without", "won't", "wonder", "would", "would", "wouldn't", "yes", "yet", "you", "you'd", "you'll", "you're", "you've", "your", "yours", "yourself", "yourselves", "zero", "Join", "LinkedIn", 'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','Copyright','Policy','Cookie','Privacy','Agreement','User','Corporation','prohibited.','©','members','Browse','members','country','By','site',"LinkedIn's",'Commercial','authorization','India','&amp;','»','2011','express','agree','terms','use','View','site,','use.','-','Full','Profile','Not','for?','directly','full','profile','Search','people', '200', 'million', 'professionals', 'LinkedIn.','Today','Sign','In',"As",'member','join','sharing','connections','ideas','opportunities.','And','free!',"You'll","to:",'See','common','Get','introduced','Connections','Overview','Name','Search:','First','Last','Example:']
      html = open(website_link)
      n_doc = Nokogiri::HTML(html)
      n_doc.css('script').remove
      n_doc_text = n_doc.to_s
      n_doc_text = n_doc_text.split("<body")[1]

      n_doc_text = "<body" + n_doc_text
      n_doc_text = strip_tags n_doc_text
      n_doc_text = n_doc_text.gsub("\n"," ").gsub("/*","").gsub("*/","")
      n_doc_text = n_doc_text.squeeze(' ')
      linked_in_data = n_doc_text.split.delete_if{|x| ignore_word_arr.include?(x)}.join(' ')
      linked_in_data = linked_in_data.split('Viewers viewed...')[0] #Split this because we were getting irrelevant data of Viewers of this profile also viewed...
      linked_in_data = linked_in_data.split(' ').uniq.join(' ')
      return linked_in_data
    end
    
    linkedin_public_data_import()
  end
end