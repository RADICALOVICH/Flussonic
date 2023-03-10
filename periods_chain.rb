# frozen_string_literal: true

require 'date'

# класс, содержащий сдвиг и цепочку
class PeriodsChain
  # инициализация + проверка сдвига
  def initialize(start_date, periods_chain)
    if check_input(start_date)
      @start_date = Date.parse(start_date)
      @periods_chain = periods_chain
      
    else
      @start_date = nil
    end
  end

  # основной метод
  def valid?
    return false if (@start_date.nil? || @periods_chain.nil?)

    current_date = @start_date
    @difference_day = @start_date.day
    @difference_month = @start_date.month
    @periods_chain.each do |period|
      return false unless check_period(period)

      if period.match(/D/)
        current_date == get_daily(period)[0] ? (current_date = get_daily(period)[1]) : (return false)
        @difference_day = current_date.day
        @difference_month = current_date.month
      elsif period.match(/M/)
        current_date == get_monthly(period)[0] ? (current_date = get_monthly(period)[1]) : (return false)
        @difference_month = current_date.month
      else
        current_date == get_annually(period)[0] ? (current_date = get_annually(period)[1]) : (return false)
      end
    end
    true
  end

  def add(period_type)
    return unless valid?

    period = @periods_chain[-1]
    case period_type
    when 'daily'
      @periods_chain.push("#{get_daily(period)[1].year}M#{get_daily(period)[1].month}D#{get_daily(period)[1].day}")
    when 'monthly'
      @periods_chain.push("#{get_monthly(period)[1].year}M#{get_monthly(period)[1].month}")
    when 'annually'
      @periods_chain.push(get_annually(period)[1].year.to_s)
    end
  end

  private

  def get_daily(daily)
    year, month, day = daily.gsub(/[MD]/, '.').split('.').map(&:to_i)
    left = Date.new(year, month, day)
    right = left + 1
    [left, right]
  end

  def get_monthly(monthly)
    year, month = monthly.gsub(/M/, '.').split('.').map(&:to_i)
    day = (@difference_day - Date.new(year, month, -1).day).positive? ? Date.new(year, month, -1).day : @difference_day
    left = Date.new(year, month, day)
    right_day = (@difference_day - Date.new(year, month + 1, -1).day).positive? ? Date.new(year, month + 1, -1).day : @difference_day
    right = Date.new(year, month + 1, right_day)
    [left, right]
  end

  def get_annually(annually)
    year = annually.to_i
    day = (@difference_day - Date.new(year, @difference_month, -1).day).positive? ? Date.new(year, @difference_month, -1).day : @difference_day
    left = Date.new(year, @difference_month, day)
    right_day = (@difference_day - Date.new(year + 1, @difference_month, -1).day).positive? ? Date.new(year + 1, @difference_month, -1).day : @difference_day
    right = Date.new(year + 1, @difference_month, right_day)
    [left, right]
  end

  def check_input(start_date)
    begin
      Date.parse(start_date)
      true
    rescue ArgumentError
      false
    end
  end

  def check_period(period)
    /((((\A\d{4}\z)|(\A\d{4}\z))|(\A\d{4})M(\d{1})D(\d{1,2}\z))|(\A\d{4}M\d{1,2}\z))/.match?(period)
  end
end