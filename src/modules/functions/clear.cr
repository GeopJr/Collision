module Hashbrown
  extend self

  def clear(page : Int32)
    return if page > 2 || page < 0
    if page <= 1
      COMPARE_STATUS.label = ""
    end
    if page != 1
      VERIFY_STATUS.label = ""
    end
  end
end
