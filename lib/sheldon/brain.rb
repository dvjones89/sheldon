require "pathname"
require_relative "memory"

class Brain

  def initialize(sheldon_data_dir)
    @brain_location = sheldon_data_dir
  end


  def learn(recall_cue, abs_learn_path)
    cell = find_cell(recall_cue)
    FileUtils.mkdir_p(cell)
    FileUtils.mv(abs_learn_path, cell)
  end

  def recall(recall_cue, destination)
    FileUtils.ln_s(read_cell(recall_cue), destination)
  end

  def has_cue?(recall_cue)
    memory.has_cue?(recall_cue)
  end

  def memory
    @memory ||= Memory.new(@brain_location)
  end

  private

  def find_cell(recall_cue)
    File.join(@brain_location, recall_cue)
  end

  def read_cell(recall_cue)
    cell = find_cell(recall_cue)
    Dir.glob(cell).first
  end

end
