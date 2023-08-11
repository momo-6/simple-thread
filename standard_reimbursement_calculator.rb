require "./project_set"


class StandardReimbursementCalculator

  def calculate_total_reimbursement(project_set, first_start_date, last_end_date)
    total_cost = 0
    (first_start_date..last_end_date).each do |date|
      day_citycost_types = project_set.day_citycost_types(date)
      day_city_cost_type = compute_day_city_cost_type(day_citycost_types)
      cost = project_set.cost(day_city_cost_type)
      total_cost += cost
    end
    total_cost
  end

  # for a given date: given a list of hashes, each hash describes that dates relationship to a specific project,
  # by telling us the day type and the city cost type.
  # this method computes a hash that tells us the day_cost type ( travel, full or none ), 
  # and the city cost type ( low or high, or none)
  # example parameter value: 
  # [
  #   {:day_type=> Project::DAY_TYPE[:travel], :city_cost_type=> Project::CITY_COST_TYPE[:low]}, 
  #   {:day_type=> Project::DAY_TYPE[:before_travel], :city_cost_type=> Project::CITY_COST_TYPE[:high]}, 
  # ]
  def compute_day_city_cost_type(day_citycost_types)
    # rules for computing:
    # 1. if any day is full, cost is full
    # 2. if we have both a before_travel and travel day; cost type is full day ( projects push up against each other)
    # 3. if we have both a after_travel and travel day; cost type is full day ( projects push up against each other )
    # 4. if we have more than one travel day, cost type is full day. ( projects overlap )
    # 5. at this point, if we have exactly one travel day, cost type is travel day.
    # 6. everything else is a no cost day ( outside any project )

    # the project_day_types is a list of maps: each map contains the day_type and the city_cost_type,
    # we need to figure out the day cost type, and select the correct city_cost_type, returning both in a hash.

    day_types = day_citycost_types.map {|x| x[:day_type]}

    if day_types.include?(Project::DAY_TYPE[:full])
      # The city cost type will be the highest cost of all the projects for which this day is a full day.
      return {day_cost_type: Project::DAY_COST_TYPE[:full], city_cost_type: highest_city_cost_type(day_citycost_types, :full)}
    end

    if day_types.include?(Project::DAY_TYPE[:before_travel]) && day_types.include?(Project::DAY_TYPE[:travel])
      # the city cost type will be the highest cost of all the projects for which this day is a travel day.
      return {day_cost_type: Project::DAY_COST_TYPE[:full], city_cost_type: highest_city_cost_type(day_citycost_types, :travel)}
    end

    if day_types.include?(Project::DAY_TYPE[:after_travel]) && day_types.include?(Project::DAY_TYPE[:travel])
      # the city cost type will be the highest cost of all the projects for which this day is a travel day.
      return {day_cost_type: Project::DAY_COST_TYPE[:full], city_cost_type: highest_city_cost_type(day_citycost_types, :travel)}
    end

    if day_types.count(Project::DAY_TYPE[:travel]) > 1
      # the city cost type will be the highest cost of all the projects for which this day is a travel day.
      return {day_cost_type: Project::DAY_COST_TYPE[:full], city_cost_type: highest_city_cost_type(day_citycost_types, :travel)}
    end

    if day_types.count(Project::DAY_TYPE[:travel]) == 1
      # the city cost type will be the highest cost of all the projects for which this day is a travel day.
      return {day_cost_type: Project::DAY_COST_TYPE[:travel], city_cost_type: highest_city_cost_type(day_citycost_types, :travel)}
    end

    # for all other cases, this day incures no cost, so cost type is none, and city cost type is irrelevant.
    {day_cost_type: Project::DAY_COST_TYPE[:none], city_cost_type: Project::CITY_COST_TYPE[:low]}
  end

  private

  # I am assuming that if multple projects overlap, we choose the highest city cost type to compute the 
  # cost of that day. 
  # Given a list of hashes that have a given dates day_type and city_cost_type, for each project
  # this method will return the highest city_cost_type ( high or low ), for all days with the given day_type
  def highest_city_cost_type(day_citycost_types, day_type)
    day_types = day_citycost_types.select {|x| x[:day_type] == Project::DAY_TYPE[day_type]}
    cost_types = day_types.map {|x| x[:city_cost_type]}
    cost_types.include?(Project::CITY_COST_TYPE[:high]) ? Project::CITY_COST_TYPE[:high] : Project::CITY_COST_TYPE[:low]
  end
end