require "pathname"
require_relative "memory"

class Brain

  def initialize(sheldon_data_dir)
    @brain_location = sheldon_data_dir
  end


  def learn(recall_cue, abs_learn_path)
    synapse = find_synapse(recall_cue)
    FileUtils.mkdir_p(synapse)
    FileUtils.mv(abs_learn_path, synapse)
  end

  def recall(recall_cue, destination)
    FileUtils.ln_s(read_synapse(recall_cue), destination)
  end

  def has_cue?(recall_cue)
    memory.has_cue?(recall_cue)
  end

  def memory
    @memory ||= Memory.new(@brain_location)
  end

  private

  def find_synapse(recall_cue)
    File.join(@brain_location, recall_cue)
  end

  def read_synapse(recall_cue)
    synapse = find_synapse(recall_cue)
    Dir.glob(synapse).first
  end

end
