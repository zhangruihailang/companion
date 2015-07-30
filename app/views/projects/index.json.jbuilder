json.array!(@projects) do |project|
  json.extract! project, :id, :name, :yield_yearly, :investment_cycle, :risk_rank, :borrowing_total, :min_investment_amount, :latest_payment_date, :latest_expire_date, :repay_type, :introduction, :assets_explain, :risk_control_measures, :guarantee_status, :money_flow, :credentials
  json.url project_url(project, format: :json)
end
