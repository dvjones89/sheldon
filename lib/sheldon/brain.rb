require_relative "memory"

class Brain

  def initialize(sheldon_data_dir)
    @brain_location = sheldon_data_dir
  end


  def learn(recall_cue, abs_learn_path)
    cell = get_cell(recall_cue)
    FileUtils.mkdir_p(cell)
    FileUtils.mv(abs_learn_path, cell)
    memory.add(recall_cue, abs_learn_path)
  end

  def recall(recall_cue, destination)
    FileUtils.ln_s(read_cell(recall_cue), destination)
  end

  def has_cue?(recall_cue)
    memory.has_cue?(recall_cue)
  end

  def size
    memory.size
  end

  private

  def memory
    @memory ||= Memory.new(@brain_location)
  end

  def get_cell(recall_cue)
    File.join(@brain_location, recall_cue)
  end

  def read_cell(recall_cue)
    cell = get_cell(recall_cue)
    Dir.glob(cell).first
  end

end
