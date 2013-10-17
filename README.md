rspec_threshold_formatter
=========================

### Description
Sometime slowest test report is not enough. With this formatter you can set execution time threshold for each type of your specs.

### Usage.

Copy code to ./spec/support/threshold_formatter.rb 

Enable formater:
```
--require ./spec/support/threshold_formatter.rb
--format RSpec::Formatters::ThresholdFormatter
```
Configure thresholds in spec_helper.rb:
```
config.thresholds = {
  :model => 0.5,
  :controller => 1,
  :your_custom_type => 2
}
```

