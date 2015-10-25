require "yaml/store"

class Memory

  def initialize(brain_location)
    database_path = File.join(brain_location, "db.yml")
    @database = YAML::Store.new(database_path)
  end

  def has_cue?(recall_cue)
    @database.transaction do
      @database.roots.any?{ |cue| cue == recall_cue }
    end
  end

end
