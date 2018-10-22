if Rails.env.test?
  CarrierWave.configure do |config|
    # skip image resizing in tests
    config.enable_processing = false
  end
end
