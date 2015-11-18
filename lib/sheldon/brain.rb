class Brain

  attr_reader :memory

  def initialize(sheldon_data_dir, opts = {})
    @brain_location = sheldon_data_dir
    @memory = opts[:memory] || Memory.new(@brain_location)
  end


  def learn(recall_cue, abs_learn_path)
    cell = get_cell(recall_cue)
    FileUtils.mkdir_p(cell)
    FileUtils.mv(abs_learn_path, cell)
    entry = { filepath: remove_home(abs_learn_path) }
    memory.add(recall_cue, entry)
  end

  def recall(recall_cue)
    entry = memory.recall(recall_cue)
    destination = add_home(entry[:filepath])
    source_cell = get_cell(recall_cue)
    FileUtils.ln_s(read_cell(source_cell), destination, force: true)
  end

  def has_cue?(recall_cue)
    memory.has_cue?(recall_cue)
  end

  def size
    memory.size
  end

  def list
    memory.list
  end

  private

  def get_cell(recall_cue)
    File.join(@brain_location, recall_cue)
  end

  def read_cell(cell)
    basename = (Dir.entries(cell) - [".", "..", ".DS_Store"]).first
    File.join(cell, basename)
  end

end
