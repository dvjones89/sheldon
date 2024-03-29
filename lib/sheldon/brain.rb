class Brain

  attr_reader :memory, :location

  def initialize(sheldon_data_dir)
    @location = sheldon_data_dir
    @memory = Memory.new(@location)
  end

  def forget(recall_cue)
    entry = memory.recall(recall_cue)
    brain_path = brain_directory_for_cue(recall_cue)
    destination_path = add_home(entry[:filepath])
    FileUtils.rm_r(destination_path) if File.symlink?(destination_path)
    FileUtils.rm_r(brain_path) if Dir.exist?(brain_path)

    memory.forget(recall_cue)
  end

  def has_cue?(recall_cue)
    memory.has_cue?(recall_cue)
  end

  def learn(recall_cue, abs_learn_path)
    raise "recall cue cannot be empty." if recall_cue.strip.empty?
    raise "This cue has already been used." if has_cue?(recall_cue)
    raise "Unable to find a file or folder at #{abs_learn_path}" unless File.exist?(abs_learn_path)

    brain_path = brain_directory_for_cue(recall_cue)
    FileUtils.mkdir_p(brain_path)
    FileUtils.mv(abs_learn_path, brain_path)
    entry = { filepath: remove_home(abs_learn_path) }
    memory.add(recall_cue, entry)
  end

  def list_cues
    memory.list_cues
  end

  def path_for_cue(recall_cue)
    raise "no entry for cue '#{recall_cue}'" unless memory.has_cue?(recall_cue)
    brain_directory = brain_directory_for_cue(recall_cue)
    get_content(brain_directory)
  end

  def present?
    memory.present?
  end

  def recall(recall_cue, opts={})
    # Compute the absolute paths for recall
    brain_path = brain_directory_for_cue(recall_cue)
    entry = memory.recall(recall_cue)
    destination_path = add_home(entry[:filepath])
    destination_dir = File.dirname(destination_path)

    # Handle the destination file / directory already existing on the filesystem
    if File.exist?(destination_path) || File.symlink?(destination_path)
      if opts[:overwrite]
        FileUtils.remove_dir(destination_path) # this (badly named) method deletes both files and folders
      else
        raise DestinationNotEmptyException, "#{destination_path} already exists."
      end
    end

    # Create the destination directory if required
    FileUtils.mkdir_p(destination_dir) unless File.directory?(destination_dir)

    # Create the symbolic link between sheldon's brain and the destination
    FileUtils.ln_s(get_content(brain_path), destination_path)

    return recalled?(recall_cue)
  end

  def recalled?(recall_cue)
    entry = memory.recall(recall_cue)
    destination_path = add_home(entry[:filepath])
    destination_dir = File.dirname(destination_path)
    # Check for presence of symlink and that the symlink isn't broken
    File.symlink?(destination_path) && File.exists?(File.readlink(destination_path))
  end

  def size
    memory.size
  end

  private

  def brain_directory_for_cue(recall_cue)
    File.join(@location, recall_cue)
  end

  def get_content(path)
    basename = (Dir.entries(path) - [".", "..", ".DS_Store"]).first
    File.join(path, basename)
  end

end
