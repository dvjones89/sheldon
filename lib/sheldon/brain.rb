class Brain

  attr_reader :memory

  def initialize(sheldon_data_dir, opts = {})
    @brain_location = sheldon_data_dir
    @memory = opts[:memory] || Memory.new(@brain_location)
  end


  def learn(recall_cue, abs_learn_path)
    brain_path = brain_path_for_cue(recall_cue)
    FileUtils.mkdir_p(brain_path)
    FileUtils.mv(abs_learn_path, brain_path)
    entry = { filepath: remove_home(abs_learn_path) }
    memory.add(recall_cue, entry)
  end

  def recall(recall_cue)
    entry = memory.recall(recall_cue)
    destination_path = add_home(entry[:filepath])
    destination_dir = File.dirname(destination_path)
    FileUtils.mkdir_p(destination_dir) unless File.directory?(destination_dir)
    brain_path = brain_path_for_cue(recall_cue)
    FileUtils.ln_s(get_content(brain_path), destination_path, force: true)
  end

  def forget(recall_cue)
    entry = memory.recall(recall_cue)
    brain_path = brain_path_for_cue(recall_cue)
    destination_path = add_home(entry[:filepath])
    FileUtils.rm_r(brain_path)
    FileUtils.rm_r(destination_path)

    memory.forget(recall_cue)
  end

  def recalled?(recall_cue)
    entry = memory.recall(recall_cue)
    destination_path = add_home(entry[:filepath])
    destination_dir = File.dirname(destination_path)
    # Check for presence of symlink and that the symlink isn't broken
    File.symlink?(destination_path) && File.exists?(File.readlink(destination_path))
  end

  def has_cue?(recall_cue)
    memory.has_cue?(recall_cue)
  end

  def size
    memory.size
  end

  def list_cues
    memory.list_cues
  end

  private

  def brain_path_for_cue(recall_cue)
    File.join(@brain_location, recall_cue)
  end

  def get_content(path)
    basename = (Dir.entries(path) - [".", "..", ".DS_Store"]).first
    File.join(path, basename)
  end

end
