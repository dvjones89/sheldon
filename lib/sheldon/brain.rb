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

  def recall(recall_cue)
    destination = memory.recall(recall_cue)
    source_cell = get_cell(recall_cue)
    FileUtils.ln_s(read_cell(source_cell), destination)
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

  def read_cell(cell)
    basename = (Dir.entries(cell) - [".", ".."]).first
    File.join(cell,basename)
  end

end
