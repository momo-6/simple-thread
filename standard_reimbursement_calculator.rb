class StandardReimbursementCalculator


  def calculate_total_reimbursement(project_list, first_start_date, last_end_date)
    # get the full date range: earliest start date, and the latest start date

    # for each day in the full date range, get all the day types from the projects
    #   compute the reimbursement cost from that day type list. map this array of date types to a cost_day_type

  end

  def compute_cost_day_type(project_day_types)
    # rules for computing cost day type
    # 1. if any day is full, cost is full
    # 2. if we have both a before_travel and travel day; cost type is full day ( projects push up against each other)
    # 3. if we have both a after_travel and travel day; cost type is full day ( projects push up against each other )
    # 4. if we have more than one travel day, cost type is full day. ( projects overlap )
    # 5. if we have no travel days, and no full days, cost type is NO cost.
  end
end