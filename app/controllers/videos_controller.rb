class VideosController < ApplicationController
  
  skip_before_filter :verify_authenticity_token
  
  def create_token
    session[:chave] = "463636334"
    puts 'sasd'
  end
  
  
  # GET /videos
  # GET /videos.json
  def index
    @videos = Video.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @videos }
    end
  end

  # GET /videos/1
  # GET /videos/1.json
  def show
    @video = Video.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @video }
    end
  end

  # GET /videos/new
  # GET /videos/new.json
  def new
    @video = Video.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @video }
    end
  end

  # GET /videos/1/edit
  def edit
    @video = Video.find(params[:id])
  end

  # POST /videos
  # POST /videos.json
  def create
    #make_upload = Video.upload_video(params[:video])
    uploaded_io = params[:video][:video]
    name_format_video = "#{Time.now.to_i}_" << uploaded_io.original_filename
    path_video = 'public/uploads'
    File.open(File.join(path_video, name_format_video), 'wb') do |file|
      file.write(uploaded_io.read)
      #@use_ffmpeg = 
      
      remove_format = name_format_video.split('.')
      format = remove_format.last
      
      filename_with_no_format = name_format_video.gsub('.' + format, '')
      @final_filename = "#{filename_with_no_format}_n.mp4"
      
      #check if the file exists on the folder
      if File.exists?("#{path_video}/#{name_format_video}")
        #perform the encoding to .webm
        `/usr/local/bin/ffmpeg -i #{path_video}/#{name_format_video} -acodec libvorbis -ac 2 -ab 128k -ar 44100 #{path_video}/#{@final_filename}`
        #`/usr/local/bin/ffmpegmov -i #{path_video}/video.avi -sameq -s 480x320 #{path_video}/TEST.MOV`

        #take a sceenshot of the original file because it has better quality
        `ffmpeg -i #{path_video}/#{name_format_video} -ss 10 -vframes 1 #{path_video}/#{filename_with_no_format}_n.jpg`
        #`ffmpeg -y -ss 00:00:10 -i #{path_video}/#{name_format_video} -an -r 1 -f mjpeg -vcodec mjpeg -vframes 1 "test.jpg"`
        #`ffmpeg -i #{path_video}/#{name_format_video} movie%d.jpg`

        #delete the original file
        File.delete("#{path_video}/#{name_format_video}")  
      end
      
    end
    
    
    params[:video][:video] = @final_filename
    @video = Video.new(params[:video])

    respond_to do |format|
      if @video.save
        format.html { redirect_to @video, notice: "Video was successfully created." }
        format.json { render json: @video, status: :created, location: @video }
      else
        format.html { render action: "new" }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /videos/1
  # PUT /videos/1.json
  def update
    @video = Video.find(params[:id])

    respond_to do |format|
      if @video.update_attributes(params[:video])
        format.html { redirect_to @video, notice: 'Video was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /videos/1
  # DELETE /videos/1.json
  def destroy
    @video = Video.find(params[:id])
    @video.destroy

    respond_to do |format|
      format.html { redirect_to videos_url }
      format.json { head :no_content }
    end
  end
end
