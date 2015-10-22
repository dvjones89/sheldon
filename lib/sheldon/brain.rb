class Brain

  def learn(recall_cue, abs_learn_path)
    synapse = find_synapse(recall_cue)
    basename = File.basename(abs_learn_path)
    FileUtils.mkdir_p(synapse)
    FileUtils.mv(abs_learn_path, synapse)
  end

  def recall(recall_cue, destination)
    synapse = find_synapse(recall_cue)
    FileUtils.ln_s(read_synapse(recall_cue), destination)
  end

  private

  def find_self
    relative_path = '~/sheldon2'
    # relative_path = ENV['SHELDON_DATA_DIR'] || '~/sheldon'
    Pathname(relative_path).expand_path # Deals with the use of ~ when referencing home directories
  end

  def find_synapse(recall_cue)
    File.join(find_self,recall_cue)
  end

  def read_synapse(recall_cue)
    synapse = find_synapse(recall_cue)
    Dir.glob(File.join(synapse,'/*')).first
  end

end
