require "yaml/store"

class Memory

  def initialize(brain_location)
    database_path = File.join(brain_location, "db.yml")
    @database = YAML::Store.new(database_path)
  end

  def add(recall_cue, hash)
    raise "cue already used" if has_cue?(recall_cue)
    @database.transaction do
      @database[recall_cue] = hash
    end
    return true
  end

  def forget(recall_cue)
    raise "no entry for cue" unless has_cue?(recall_cue)
    @database.transaction{ @database.delete(recall_cue) }
    return true
  end

  def has_cue?(recall_cue)
    list_cues.any?{ |cue| cue == recall_cue }
  end

  def list_cues
    @database.transaction { @database.roots }
  end

  def recall(recall_cue)
    raise "no entry for cue '#{recall_cue}'" unless has_cue?(recall_cue)
    @database.transaction { @database[recall_cue] }
  end

  def size
    list_cues.size
  end

end
