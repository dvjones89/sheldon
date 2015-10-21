class Brain

  def learn(friendly_name, abs_learn_path)
    synapse = find_synapse(friendly_name, abs_learn_path)
    basename = File.basename(abs_learn_path)
    FileUtils.mkdir_p(synapse)
    FileUtils.mv(abs_learn_path, synapse)
    link(File.join(synapse, basename), abs_learn_path)
  end

  # TODO - Move this back into lib/sheldon.rb ; a brain doesn't link things!
  def link(source, destination)
    FileUtils.ln_s(source, destination)
  end
  

  private

  def find_self
    relative_path = '~/sheldon2'
    # relative_path = ENV['SHELDON_DATA_DIR'] || '~/sheldon'
    Pathname(relative_path).expand_path # Deals with the use of ~ when referencing home directories
  end

  def find_synapse(friendly_name, learn_path)
    # basename = File.basename(learn_path)
    File.join(find_self,friendly_name)
  end

end
