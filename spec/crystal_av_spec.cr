require "./spec_helper"

describe CrystalAV do

  it "detects viruses" do
    CrystalAV::Engine.run do |engine|
      infected_file = File.expand_path(
        "./fixtures/virus.txt",
        File.dirname(__FILE__)
      )
      results = engine.scan(infected_file)
      results.virus?.should eq(true)
    end
  end

end
