require "./spec_helper"

describe CrystalAV do

  it "detects clean files" do
    CrystalAV::Engine.load do |engine|
      infected_file = File.expand_path(
        "./fixtures/clean.txt",
        File.dirname(__FILE__)
      )
      result = engine.scan(infected_file)
      result.clean?.should be_true
    end
  end

  it "detects viruses" do
    CrystalAV::Engine.load do |engine|
      infected_file = File.expand_path(
        "./fixtures/virus.txt",
        File.dirname(__FILE__)
      )
      results = engine.scan(infected_file)
      results.virus?.should be_true
    end
  end

  it "fails if file doesn't exist" do
    CrystalAV::Engine.load do |engine|
      infected_file = "/does/not/exist"
      result = engine.scan(infected_file)
      result.error?.should be_true
    end
  end

end
