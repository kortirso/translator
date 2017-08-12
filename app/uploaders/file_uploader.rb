# Uploader for tasks
class FileUploader < CarrierWave::Uploader::Base
    storage :file

    def store_dir
        "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end

    def extension_whitelist
        %w[yml resx strings json xml]
    end
end
