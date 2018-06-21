module IcalParser
  class PeriodOfTime
    attr_reader :start_time, :end_time

    def initialize(start_time, end_time)
      raise "Invalid PeriodOfTime: end_time must be later than start time" if end_time <= start_time
      @start_time = start_time
      @end_time = end_time
    end

    def duration
      @end_time - @start_time
    end

    def start_time=(start_time)
      raise "Invalid start_time: must be earlier than end time" if start_time > @end_time
      @start_time = start_time
    end

    def end_time=(end_time)
      raise "Invalid end_time: must be later than start time" if end_time <= @start_time
      @end_time = end_time
    end
  end
end
