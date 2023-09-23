# This is experimental.  It's been run locally but not tested in production.
# At the type of this writing, the app used the prod DBs in both the development and production environments.

module ServiceHub
  class PopulateInstrumentsByShards < PopulateInstruments

    def run
      remove_unwanted_instruments

      model_data = Model.all.map do |model|
        { name: model.model, description: model.public_description }
      end

      model_data.in_groups(4).each do |model_group|
        process_data_for_shard(model_group.flatten)
      end

      true
    end

    private

    def process_data_for_shard(model_group)
      Process.fork {
        logger.info("Processing models #{model_names}.")

        model_group.each do |model_data|
          begin
            model_name = model_data[:name]
            generate_instrument(model_name, model_data[:description])
          rescue StandardError => error
            logger.info("Error encountered for instrument with model #{model_name}.")
            logger.info(error)
          end
        end
      }
    end

    def logger
      @logger ||= Logger.new("#{Rails.root}/log/populate_instruments.#{Rails.env}.log")
    end

  end
end