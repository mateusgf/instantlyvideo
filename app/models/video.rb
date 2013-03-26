class Video < ActiveRecord::Base
  
  def self.upload_video(upload)
     name =  upload['video'].original_filename
     directory = "public/uploads"
     # create the file path
     path = File.join(directory, name)
     # write the file
     File.open(path, "wb") { |f| f.write(upload['video'].read) }
  end
end
