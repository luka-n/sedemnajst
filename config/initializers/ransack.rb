Ransack.configure do |config|
  config.custom_arrows = {
    default_arrow: nil,
    down_arrow: '<i class="bi bi-arrow-down"></i>',
    up_arrow: '<i class="bi bi-arrow-up"></i>'
  }

  config.add_predicate(
    "in_date_range",
    arel_predicate: "between",
    formatter: proc { |v| Range.new(*v.split(" - ").map { |s| Time.zone.parse(s) }) },
    type: :string,
    validator: proc { |v| v =~ /^\d{2}\.\d{2}\.\d{4} - \d{2}\.\d{2}\.\d{4}$/ }
  )
end
