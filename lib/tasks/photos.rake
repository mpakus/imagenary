namespace :photos do

  desc "Resize all photos"
  task :resize => :environment do
    Photo.all.each { |photo| photo.image.recreate_versions! unless photo.image.nil? || photo.image.blank? }
  end

end
