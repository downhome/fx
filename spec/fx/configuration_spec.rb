require "spec_helper"

describe Fx::Configuration do
  before :each do
   Fx.configuration = Fx::Configuration.new
  end

  it "defaults the database adapter to postgres" do
    expect(Fx.configuration.database).to be_a Fx::Adapters::Postgres
    expect(Fx.database).to be_a Fx::Adapters::Postgres
  end

  it "allows the database adapter to be set" do
    adapter = double("Fx Adapter")

    Fx.configure do |config|
      config.database = adapter
    end

    expect(Fx.configuration.database).to eq adapter
    expect(Fx.database).to eq adapter
  end

  context '.schemas' do
    it "defaults to [:public]" do
      expect(Fx.configuration.schemas).to eq [:public]
    end

    it "accepts an array" do
      Fx.configure do |config|
        config.schemas = %i(test mest pest)
      end

      expect(Fx.configuration.schemas).to eq %i(test mest pest)
    end

    it "accepts a lambda function" do
      Fx.configure do |config|
        config.schemas = -> {%i(test mest pest)}
      end

      expect(Fx.configuration.schemas.call).to eq %i(test mest pest)
    end
  end

  context '.current_schema' do
    it "defaults to :public" do
      expect(Fx.configuration.current_schema).to eq :public
    end

    it "accepts an array" do
      Fx.configure do |config|
        config.current_schema = :test
      end

      expect(Fx.configuration.current_schema).to eq :test
    end

    it "accepts a lambda function" do
      Fx.configure do |config|
        config.current_schema = -> {:west}
      end

      expect(Fx.configuration.current_schema.call).to eq :west
    end
  end
end
