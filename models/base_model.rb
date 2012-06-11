module BaseModel

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def fetch
      all.first || create(:connect => 'false')
    end
  end

  def connect?
    self.connect == 'true'
  end

  def disconnect!
    self.connect = 'false'
    self.save
  end
end
