# TODO: Extract this into dropzone.

class ArticulatePresignedPost
  def initialize(extension)
    @extension = extension
    @prefix_name = SecureRandom.uuid
    setup_folder
    setup_key
  end

  def build
    {
      folder: @folder,
      key: @key,
      prefix: @prefix_name,
      presign: create_s3_post
    }
  end

  private

  def create_s3_post
    raise StandardError unless @key
    ASSETS_S3_BUCKET.presigned_post(
      key:  @key,
      success_action_status: '201',
      acl: 'public-read'
    )
  end

  def setup_folder
    @folder = 'cdn/articulate/' + @prefix_name
  end

  def setup_key
    @extension = @extension.tr('.', '')
    @key = "#{@folder}/#{SecureRandom.uuid}.#{@extension}"
  end
end
