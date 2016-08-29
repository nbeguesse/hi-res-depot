#run in console with:
#require './db/seeds'
#include DbToFixture
#table_to_yaml ModelName
module DbToFixture
	TEMP_FIXTURE_PATH = Rails.root.join("spec","new_fixtures")

	def yaml_to_table table_name
		rows = YAML.load_file(Rails.root.join("spec","fixtures","#{table_name}.yml"))
		model = table_name.classify.constantize rescue nil
		model = ActsAsTaggableOn::Tag if table_name=="tags"
		model = ActsAsTaggableOn::Tagging if table_name=="taggings"
		model.delete_all
		rows.each do |array|
			model.create(array) rescue nil
		end
	end

	def table_to_yaml model
		Dir.mkdir(TEMP_FIXTURE_PATH) unless File.exists?(TEMP_FIXTURE_PATH)
		fname = model.table_name+".yml"
		file_path = TEMP_FIXTURE_PATH.join(fname)
		i=0
		models = model.all.map{|e| e.attributes}
		 File.open(file_path,'w') do |f|
		 	f.write models.to_yaml
		 end
	end

	def all_models
	  [Image, Match, User, ActsAsTaggableOn::Tag, ActsAsTaggableOn::Tagging]
	end

	def all_tables
	  %w(images matches users tags taggings)
	end


	#CSV file needs to have header row for this to work
	def csv_to_table
		path = File.join(Rails.root, "db/seed_data")
		Dir.foreach(path) do |file|
			if file.include?(".csv")
				header_row = nil
				model = File.basename(file, File.extname(file)).camelcase.constantize
				model.delete_all
				CSV.foreach(File.join(path,file)) do |row|
					if header_row.nil?
						header_row = row
						next
					end
					attributes = {}
					row.each_index do |i|
						attributes[header_row[i].to_sym] = row[i]
					end
					model.create!(attributes)
				end
			end

		end
	end
end
